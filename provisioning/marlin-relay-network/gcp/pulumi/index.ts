import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

import { GCPGlobalNetwork } from "@marlinlabs/pulumi-gcp-global-network"
import { GCPInstances } from "@marlinlabs/pulumi-gcp-instances"


interface GCPRelayNetworkArgs {
    beacon_subnets: {[key: string]: {region: string, cidr: string}};
    monitoring_subnets: {[key: string]: {region: string, cidr: string}};
    relay_subnets: {[key: string]: {region: string, cidr: string}};
    firewalls?: {[key: string]: Omit<gcp.compute.FirewallArgs, "network">};
    labels?: pulumi.Input<{[key: string]: any}>;
}

export class GCPRelayNetwork extends pulumi.ComponentResource {
    readonly network: GCPGlobalNetwork;
    readonly beaconInstances: GCPInstances;
    readonly beaconIps: pulumi.Output<string>[];

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

        this.beaconInstances = new GCPInstances(`${name}-beacons`, {
            subnets: Object.keys(args.beacon_subnets).reduce((o, key) => { return { ...o, [key]: this.network.subnets[key] }; }, {}),
            instanceType: "g1-small",
            count: 1,
            networkTags: ["beacon"],
            labels: {
                ...args.labels,
                "role": "beacon",
            },
        });

        this.beaconIps = Object.values(this.beaconInstances.instances).map((i) => {
            return i.apply((i) => {
                return i.networkInterfaces.apply((i) => {
                    return i[0].networkIp;
                });
            });
        });
    }
}
