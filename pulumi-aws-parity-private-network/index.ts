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
    }
}
