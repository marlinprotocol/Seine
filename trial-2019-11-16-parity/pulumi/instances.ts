import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

export class GCPInstances extends pulumi.ComponentResource {
    public readonly instances: {[key: string]: pulumi.Output<gcp.compute.Instance>};

    constructor(name: string, args: GCPInstancesArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:GCP:Instances", name, {}, opts);
    }
}
