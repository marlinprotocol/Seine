import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

interface GCPInstancesArgs {
    subnets: {[key: string]: pulumi.Input<gcp.compute.Subnetwork>};
    instanceType: string;
    count: number;
    preemptible?: boolean;
    localssd?: boolean;
    networkTags?: pulumi.Input<pulumi.Input<string>[]>;
    labels?: pulumi.Input<{[key: string]: any}>;
}

export class GCPInstances extends pulumi.ComponentResource {
    public readonly instances: {[key: string]: pulumi.Output<gcp.compute.Instance>};

    constructor(name: string, args: GCPInstancesArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:GCP:Instances", name, {}, opts);

        this.instances = {};

        for(let subnetName in args.subnets) {
            let subnet = args.subnets[subnetName];

            for (let idx = 0; idx < args.count; ++idx) {
                this.instances[`${name}-${subnetName}-${idx+1}`] = pulumi.output(subnet).apply(subnet => {
                    return new gcp.compute.Instance(`${name}-${subnetName}-${idx+1}`, {
                        allowStoppingForUpdate: false,
                        bootDisk: {
                            initializeParams: {
                                image: "ubuntu-1804-lts",
                                labels: args.labels,
                            }
                        },
                        labels: args.labels,
                        machineType: args.instanceType,
                        networkInterfaces: [{
                            accessConfigs: [{}],
                            subnetwork: subnet.name,
                        }],
                        scheduling: args.preemptible ? {
                            automaticRestart: false,
                            preemptible: true,
                        } : undefined,
                        scratchDisks: args.localssd ? [{
                            interface: "NVME",
                        }] : undefined,
                        tags: args.networkTags,
                        zone: subnet.region.apply(region => { return `${region}-c`; }),
                    }, {
                        parent: subnet,
                    });
                });
            }
        }
    }
}
