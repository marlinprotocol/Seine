import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as awsx from "@pulumi/awsx";

export class AWSPeeredNetwork extends pulumi.ComponentResource {

    constructor(name: string, args: AWSPeeredNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:AWSPeeredNetwork", name, {}, opts);
    }
}
