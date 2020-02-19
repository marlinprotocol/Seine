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
    static readonly monitoringNetworkTag = "monitoring";
    static readonly beaconNetworkTag = "beacon";
    static readonly relayNetworkTag = "relay";

    constructor(name: string, args: GCPRelayNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:GCP:RelayNetwork", name, {}, opts);

        let subnets = {...args.beacon_subnets, ...args.monitoring_subnets, ...args.relay_subnets}
        this.network = new GCPGlobalNetwork(`${name}-globalnet`, {
            subnets: subnets,
            firewalls: {
                ...args.firewalls,
                "ssh": GCPGlobalNetwork.generateSSHFirewall(),
                "egress": GCPGlobalNetwork.generateEgressFirewall(),
                "internal": {
                    direction: "INGRESS",
                    allows: [{
                        protocol: "tcp",
                        ports: ["0-65535"],
                    }, {
                        protocol: "udp",
                        ports: ["0-65535"],
                    }],
                    sourceRanges: Object.values(subnets).map((subnet) => { return subnet.cidr }),
                },
                "www": {
                    direction: "INGRESS",
                    allows: [{
                        protocol: "tcp",
                        ports: ["80", "443"],
                    }],
                    sourceRanges: ["0.0.0.0/0"],
                    targetTags: [GCPRelayNetwork.monitoringNetworkTag],
                },
            },
        });
    }
}
