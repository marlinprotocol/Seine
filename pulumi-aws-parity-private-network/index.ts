import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as awsx from "@pulumi/awsx";

export class AWSParityPrivateNetwork extends pulumi.ComponentResource {

    constructor(name: string, args: AWSParityPrivateNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:AWSParityPrivateNetwork", name, {}, opts);
    }
}
