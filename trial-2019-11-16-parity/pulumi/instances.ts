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

        this.instances = {};

        for(let subnetName in args.subnets) {
            let subnet = args.subnets[subnetName];

            this.instances[`${subnetName}-${name}`] = pulumi.output(subnet).apply(subnet => {
                return new gcp.compute.Instance(`${subnetName}-${name}`, {
                    allowStoppingForUpdate: false,
                    bootDisk: {
                        initializeParams: {
                            image: "ubuntu-1804-lts",
                            labels: args.labels,
                        }
                    },
                    labels: args.labels,
                    machineType: "",
                    networkInterfaces: [{
                        accessConfigs: [{}],
                        subnetwork: subnet.name,
                    }],
                    scheduling: [{
                        interface: "NVME",
                    }],
                    tags: [],
                    zone: subnet.region.apply(region => { return `${region}-c`; }),
                }, {
                    parent: subnet,
                });
            });
        }
    }
}
