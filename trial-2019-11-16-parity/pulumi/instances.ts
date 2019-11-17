import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

interface GCPInstancesArgs {
    subnets: {[key: string]: pulumi.Input<gcp.compute.Subnetwork>};
    labels?: pulumi.Input<{[key: string]: any}>;
}

export class GCPInstances extends pulumi.ComponentResource {
    public readonly instances: {[key: string]: pulumi.Output<gcp.compute.Instance>};

    constructor(name: string, args: GCPInstancesArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:GCP:Instances", name, {}, opts);
    }
}
