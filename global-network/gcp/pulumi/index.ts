import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

interface GCPGlobalNetworkArgs {
    subnets: {[key: string]: {region: string, cidr: string}};
    firewalls?: {[key: string]: Omit<gcp.compute.FirewallArgs, "network">};
}

export class GCPGlobalNetwork extends pulumi.ComponentResource {
    readonly network: gcp.compute.Network;
    readonly firewalls: {[key: string]: gcp.compute.Firewall};
    readonly subnets: {[key: string]: gcp.compute.Subnetwork};

    constructor(name: string, args: GCPGlobalNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:GCP:GlobalNetwork", name, {}, opts);
    }
}
