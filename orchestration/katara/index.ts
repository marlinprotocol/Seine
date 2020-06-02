import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

import { GCPRelayNetwork } from "@marlinlabs/katara-gcp-pulumi"
import { GCPInstances } from "@marlinlabs/pulumi-gcp-instances"

let labels = {
    "project": "eth",
    "manager": "pulumi",
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

delete subnets["asia-east2"];
delete subnets["asia-northeast1"];
delete subnets["asia-south1"];
delete subnets["asia-southeast1"];
delete subnets["australia-southeast1"];
delete subnets["europe-north1"];
delete subnets["europe-west2"];
delete subnets["europe-west3"];
delete subnets["europe-west6"];
delete subnets["northamerica-northeast1"];
delete subnets["southamerica-east1"];
delete subnets["us-central1"];
delete subnets["us-east1"];
delete subnets["us-east4"];
// delete subnets["us-west1"];
delete subnets["us-west2"];

let relayNetwork = new GCPRelayNetwork(`${labels["project"]}`, {
    beaconSubnets: {"us-west1": {...subnets["us-west1"], count: 1}},
    monitoringSubnets: {"us-west1": {...subnets["us-west1"], count: 0}},
    relaySubnets: Object.keys(subnets).reduce((o, key) => {
        return {
            ...o,
            [key]: {...subnets[key], count: 0},
        };
    }, {}),
    labels: labels,
});

let masterInstances = new GCPInstances(`${labels["project"]}-masters`, {
    subnets: Object.keys(subnets).reduce((o, key) => {
        return {
            ...o,
            [key]: {subnet: relayNetwork.network.subnets[key], count: 0},
        };
    }, {}),
    instanceType: "n1-standard-1",
    networkTags: ["master"],
    labels: {
        ...labels,
        "role": "master",
    },
});

let masterIps = Object.values(masterInstances.instances).map((i) => {
    return i.apply((i) => {
        return i.networkInterfaces.apply((i) => {
            return i[0].networkIp;
        });
    });
});

let ethInstances = new GCPInstances(`${labels["project"]}-eths`, {
    subnets: Object.keys(subnets).reduce((o, key) => {
        return {
            ...o,
            [key]: {subnet: relayNetwork.network.subnets[key], count: 0},
        };
    }, {}),
    instanceType: "n1-standard-1",
    localssd: true,
    networkTags: ["eth"],
    labels: {
        ...labels,
        "role": "eth",
    },
});

let ethIps = Object.values(ethInstances.instances).map((i) => {
    return i.apply((i) => {
        return i.networkInterfaces.apply((i) => {
            return i[0].networkIp;
        });
    });
});