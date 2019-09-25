import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as awsx from "@pulumi/awsx";

interface AWSParityPrivateNetworkArgs {
    subnets: {[key: string]: pulumi.Input<aws.ec2.Subnet>};
    instanceType: pulumi.Input<aws.ec2.InstanceType>;
    keyName: pulumi.Input<string>;
    egress?: aws.types.input.ec2.SecurityGroupEgress[];
    ingress?: aws.types.input.ec2.SecurityGroupIngress[];
    tags?: pulumi.Input<{[key: string]: any}>;
}

export class AWSParityPrivateNetwork extends pulumi.ComponentResource {
    public readonly instances: {[key: string]: pulumi.Output<aws.ec2.Instance>};
    public readonly securityGroups: {[key: string]: aws.ec2.SecurityGroup};

    constructor(name: string, args: AWSParityPrivateNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:AWSParityPrivateNetwork", name, {}, opts);

        // IAM role
        let ethRole = new aws.iam.Role(`${name}-eth`, {
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
            name: `${name}-eth`,
        }, {
            parent: this,
        });

        // IAM profile
        let ethInstanceProfile = new aws.iam.InstanceProfile(`${name}-eth`, {
            name: `${name}-eth`,
            role: ethRole,
        }, {
            parent: this,
        });

        this.instances = {};
        for(let key in args.subnets) {
            let subnet = args.subnets[key];
            let instance = pulumi.output(subnet).apply(subnet => {
                let instance = new aws.ec2.Instance(key, {
                    ami: "",
                    iamInstanceProfile: ethInstanceProfile,
                    instanceType: args.instanceType,
                    keyName: args.keyName,
                    rootBlockDevice: {
                        volumeType: "gp2",
                    },
                    subnetId: subnet.id,
                    tags: { ...args.tags, ...{role: "eth"} },
                    volumeTags: { ...args.tags, ...{role: "eth"} },
                    vpcSecurityGroupIds: [],
                }, {
                    parent: subnet,
                });

                return instance;
            });
            this.instances[key] = instance;
        }
    }
}
