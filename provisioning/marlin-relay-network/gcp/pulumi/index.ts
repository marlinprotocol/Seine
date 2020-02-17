import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

import { GCPGlobalNetwork } from "@marlinlabs/pulumi-gcp-global-network"


interface GCPRelayNetworkArgs {
    beacon_subnets: {[key: string]: {region: string, cidr: string}};
    monitoring_subnets: {[key: string]: {region: string, cidr: string}};
    relay_subnets: {[key: string]: {region: string, cidr: string}};
    firewalls?: {[key: string]: Omit<gcp.compute.FirewallArgs, "network">};
    labels?: pulumi.Input<{[key: string]: any}>;
}

export class GCPRelayNetwork extends pulumi.ComponentResource {
    readonly network: GCPGlobalNetwork;

    constructor(name: string, args: GCPRelayNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:GCP:RelayNetwork", name, {}, opts);

        let subnets = {...args.beacon_subnets, ...args.monitoring_subnets, ...args.relay_subnets}
        this.network = new GCPGlobalNetwork(`${name}-globalnet`, {
            subnets: subnets,
        });
    }
}
