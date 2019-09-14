import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

export class PeeringConnection extends pulumi.ComponentResource {

    constructor(name: string, args: PeeringConnectionArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:AWSPeeringConnection", name, {}, opts);
    }
}
