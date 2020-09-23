import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

import { GCPRelayNetwork } from "@marlinprotocol/katara-gcp-pulumi"
import { GCPInstances } from "@marlinprotocol/pulumi-gcp-instances"

let labels = {
    "project": "bsc",
    "manager": "pulumi",
};

let regions: string[] = [
    "asia-east1",
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

// delete subnets["asia-east1"];
// delete subnets["asia-northeast1"];
delete subnets["asia-south1"];
// delete subnets["asia-southeast1"];
delete subnets["australia-southeast1"];
delete subnets["europe-north1"];
// delete subnets["europe-west2"];
delete subnets["europe-west3"];
delete subnets["europe-west6"];
delete subnets["northamerica-northeast1"];
delete subnets["southamerica-east1"];
delete subnets["us-central1"];
delete subnets["us-east1"];
// delete subnets["us-east4"];
// delete subnets["us-west1"];
delete subnets["us-west2"];

let relayNetwork = new GCPRelayNetwork(`${labels["project"]}`, {
    beaconSubnets: {"us-west1": {...subnets["us-west1"], count: 1}},
    monitoringSubnets: {"us-west1": {...subnets["us-west1"], count: 1}},
    relaySubnets: Object.keys(subnets).reduce((o, key) => {
        return {
            ...o,
            [key]: {...subnets[key], count: 1},
        };
    }, {}),
    labels: labels,
    firewalls: {
        "bsc": {
            direction: "INGRESS",
            allows: [{
                protocol: "tcp",
                ports: ["30311-30311"],
            }, {
                protocol: "udp",
                ports: ["30311-30311"],
            }],
            sourceRanges: ["0.0.0.0/0"],
            targetTags: ["relay"],
        },
        "discovery": {
            direction: "INGRESS",
            allows: [{
                protocol: "udp",
                ports: ["5002", "8002"],
            }],
            sourceRanges: ["0.0.0.0/0"],
            targetTags: ["beacon", "relay"],
        },
        "relay": {
            direction: "INGRESS",
            allows: [{
                protocol: "udp",
                ports: ["5000"],
            }],
            sourceRanges: ["0.0.0.0/0"],
            targetTags: ["relay"],
        },
    }
});
