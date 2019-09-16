import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as awsx from "@pulumi/awsx";

import { RegionalNetwork } from "./regional-network"

interface IAWSNewVpcArgs {
    name: string;
    region: aws.Region;
    cidrBlock: string;
}

interface AWSPeeredNetworkArgs {
    vpcCidrs: IAWSNewVpcArgs[];
    tags?: pulumi.Input<{[key: string]: any}>;
}

export class AWSPeeredNetwork extends pulumi.ComponentResource {
    public readonly children: {[key: string]: RegionalNetwork};

    constructor(name: string, args: AWSPeeredNetworkArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:AWSPeeredNetwork", name, {}, opts);

        for(let vpcCidr of args.vpcCidrs) {
            let rn = new RegionalNetwork(vpcCidr.name, {
                vpcCidr: vpcCidr.cidrBlock,
                tags: args.tags,
            }, {
                parent: this,
            });

            this.children[vpcCidr.name] = rn;
        }
    }
}
