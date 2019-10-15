import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as awsx from "@pulumi/awsx";

interface AWSMarlinBeaconArgs {
    subnets: {[key: string]: pulumi.Input<aws.ec2.Subnet>};
    instanceType: pulumi.Input<aws.ec2.InstanceType>;
    keyName: pulumi.Input<string>;
    egress?: aws.types.input.ec2.SecurityGroupEgress[];
    ingress?: aws.types.input.ec2.SecurityGroupIngress[];
    tags?: pulumi.Input<{[key: string]: any}>;
}

export class AWSMarlinBeacon extends pulumi.ComponentResource {
    public readonly instances: {[key: string]: pulumi.Output<aws.ec2.Instance>};
    public readonly securityGroups: {[key: string]: aws.ec2.SecurityGroup};

    constructor(name: string, args: AWSMarlinBeaconArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:AWSMarlinBeacon", name, {}, opts);

        // IAM role
        let beaconRole = new aws.iam.Role(`${name}-beacon`, {
            assumeRolePolicy: `{
              "Version": "2012-10-17",
              "Statement": [
                {
                  "Effect": "Allow",
                  "Principal": {
                    "Service": "ec2.amazonaws.com"
                  },
                  "Action": "sts:AssumeRole"
                }
              ]
            }`,
            name: `${name}-beacon`,
        }, {
            parent: this,
        });

        // IAM profile
        let beaconInstanceProfile = new aws.iam.InstanceProfile(`${name}-beacon`, {
            name: `${name}-beacon`,
            role: beaconRole,
        }, {
            parent: this,
        });

        this.securityGroups = {};
        this.instances = {};
        for(let key in args.subnets) {
            let subnet = args.subnets[key];
            let instance = pulumi.output(subnet).apply(subnet => {
                let securityGroup = new aws.ec2.SecurityGroup(`${key}-beacon`, {
                    vpcId: subnet.vpcId,
                    egress: args.egress,
                    ingress: args.ingress,
                    tags: args.tags,
                }, {
                    parent: subnet,
                })

                let ubuntu = aws.getAmi({
                    filters: [
                        {
                            name: "name",
                            values: ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"],
                        },
                        {
                            name: "root-device-type",
                            values: ["ebs"],
                        },
                        {
                            name: "virtualization-type",
                            values: ["hvm"],
                        },
                    ],
                    mostRecent: true,
                    owners: ["099720109477"], // Canonical
                }, {
                    parent: subnet,
                });

                let instance = new aws.ec2.Instance(`${key}-beacon`, {
                    ami: ubuntu.imageId,
                    iamInstanceProfile: beaconInstanceProfile,
                    instanceType: args.instanceType,
                    keyName: args.keyName,
                    rootBlockDevice: {
                        volumeType: "gp2",
                    },
                    subnetId: subnet.id,
                    tags: { ...args.tags, ...{role: "beacon"} },
                    volumeTags: { ...args.tags, ...{role: "beacon"} },
                    vpcSecurityGroupIds: [securityGroup.id],
                }, {
                    parent: subnet,
                });

                return instance;
            });
            this.instances[key] = instance;
        }
    }
}
