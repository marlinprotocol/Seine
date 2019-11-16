import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

import { GCPGlobalNetwork } from "@marlinlabs/pulumi-gcp-global-network"

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
