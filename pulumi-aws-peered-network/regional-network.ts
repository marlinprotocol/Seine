import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

export class RegionalNetwork extends pulumi.ComponentResource {

    constructor(name: string, args: {}, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:AWSRegionalNetwork", name, {}, opts);
    }
}
