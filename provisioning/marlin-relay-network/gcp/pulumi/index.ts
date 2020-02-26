import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

import { GCPGlobalNetwork } from "@marlinlabs/pulumi-gcp-global-network"
import { GCPInstances } from "@marlinlabs/pulumi-gcp-instances"


interface GCPRelayNetworkArgs {
    beaconSubnets: {[key: string]: {region: string, cidr: string}};
    monitoringSubnets: {[key: string]: {region: string, cidr: string}};
    relaySubnets: {[key: string]: {region: string, cidr: string}};
    firewalls?: {[key: string]: Omit<gcp.compute.FirewallArgs, "network">};
    labels?: pulumi.Input<{[key: string]: any}>;
}

export class GCPRelayNetwork extends pulumi.ComponentResource {
    readonly network: GCPGlobalNetwork;
    readonly beaconInstances: GCPInstances;
    readonly beaconIps: pulumi.Output<string>[];
    readonly relayInstances: GCPInstances;
    readonly relayIps: pulumi.Output<string>[];
    readonly monitoringInstances: GCPInstances;
    readonly monitoringIps: pulumi.Output<string>[];

    static readonly monitoringNetworkTag = "monitoring";
    static readonly beaconNetworkTag = "beacon";
    static readonly relayNetworkTag = "relay";

    constructor(name: string, args: GCPRelayNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:GCP:RelayNetwork", name, {}, opts);

        let subnets = {...args.beaconSubnets, ...args.monitoringSubnets, ...args.relaySubnets}
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
            subnets: Object.keys(args.beaconSubnets).reduce((o, key) => { return { ...o, [key]: this.network.subnets[key] }; }, {}),
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

        this.relayInstances = new GCPInstances(`${name}-relays`, {
            subnets: Object.keys(args.relaySubnets).reduce((o, key) => { return { ...o, [key]: this.network.subnets[key] }; }, {}),
            instanceType: "n1-standard-1",
            count: 1,
            networkTags: ["relay"],
            labels: {
                ...args.labels,
                "role": "relay",
            },
        });

        this.relayIps = Object.values(this.relayInstances.instances).map((i) => {
            return i.apply((i) => {
                return i.networkInterfaces.apply((i) => {
                    return i[0].networkIp;
                });
            });
        });

        this.monitoringInstances = new GCPInstances(`${name}-monitorings`, {
            subnets: Object.keys(args.monitoringSubnets).reduce((o, key) => { return { ...o, [key]: this.network.subnets[key] }; }, {}),
            instanceType: "n1-standard-1",
            count: 1,
            networkTags: ["monitoring"],
            labels: {
                ...args.labels,
                "role": "monitoring",
            },
        });

        this.monitoringIps = Object.values(this.monitoringInstances.instances).map((i) => {
            return i.apply((i) => {
                return i.networkInterfaces.apply((i) => {
                    return i[0].networkIp;
                });
            });
        });
    }
}
