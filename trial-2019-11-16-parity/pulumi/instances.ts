import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

export class GCPInstances extends pulumi.ComponentResource {
    constructor(name: string, args: GCPInstancesArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:GCP:Instances", name, {}, opts);
    }
}
