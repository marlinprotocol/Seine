import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

import { GCPGlobalNetwork } from "@marlinlabs/pulumi-gcp-global-network"
import { GCPInstances } from "./instances"

let labels = {
    "project": "trial-2019-11-16",
    "managed_by": "pulumi",
};

let regions: string[] = [
    "asia-east2",
    "asia-northeast1",
    "asia-south1",
    "asia-southeast1",
    "australia-southeast1",
    "europe-north1",
    "europe-west2",
    "europe-west3",
    "europe-west6",
    "northamerica-northeast1",
    "southamerica-east1",
    "us-central1",
    "us-east1",
    "us-east4",
    "us-west1",
    "us-west2",
];

let subnets: {[key: string]: {region: string, cidr: string}} = {};
regions.map((region, idx) => {
    subnets[region] = {
        region: region,
        cidr: `192.168.${idx}.0/24`,
    }
});

let globalNetwork = new GCPGlobalNetwork("globalnet", {
    subnets: subnets,
    firewalls: {
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
            sourceRanges: ["192.168.0.0/20"],
        },
    }
});

let beacons = new GCPInstances("beacon", {
    subnets: {"us-west1": globalNetwork.subnets["us-west1"]},
    instanceType: "g1-small",
    count: 1,
    networkTags: ["beacon"],
    labels: {
        ...labels,
        "role": "beacon",
    },
});

export let beaconIp = beacons.instances["us-west1-beacon-1"].apply((i) => {
    return i.networkInterfaces.apply((i) => {
        return i[0].networkIp;
    });
});

let relayers = new GCPInstances("relay", {
    subnets: globalNetwork.subnets,
    instanceType: "n1-standard-1",
    count: 1,
    networkTags: ["relay"],
    labels: {
        ...labels,
        "role": "relay",
    },
});

export let relayIps = Object.values(relayers.instances).map((i) => {
    return i.apply((i) => {
        return i.networkInterfaces.apply((i) => {
            return i[0].networkIp;
        });
    });
});

let eth = new GCPInstances("eth", {
    subnets: globalNetwork.subnets,
    instanceType: "n1-standard-2",
    count: 1,
    preemptible: true,
    localssd: true,
    networkTags: ["eth"],
    labels: {
        ...labels,
        "role": "eth",
    },
});

export let ethIps = Object.values(eth.instances).map((i) => {
    return i.apply((i) => {
        return i.networkInterfaces.apply((i) => {
            return i[0].networkIp;
        });
    });
});

let monitoring = new GCPInstances("monitoring", {
    subnets: {"us-west1": globalNetwork.subnets["us-west1"]},
    instanceType: "n1-standard-2",
    count: 1,
    networkTags: ["monitoring"],
    labels: {
        ...labels,
        "role": "monitoring",
    },
});
