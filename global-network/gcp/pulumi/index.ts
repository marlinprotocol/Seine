import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

export class GCPGlobalNetwork extends pulumi.ComponentResource {

    constructor(name: string, args: GCPGlobalNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:GCP:GlobalNetwork", name, {}, opts);
    }
}
