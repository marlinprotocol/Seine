import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as awsx from "@pulumi/awsx";

import { RegionalNetwork } from "./regional-network"
import { PeeringConnection } from "./peering-connection"

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

        this.children = {};
        let processed: IAWSNewVpcArgs[] = [];
        for(let vpcCidr of args.vpcCidrs) {
            let rn = new RegionalNetwork(vpcCidr.name, {
                vpcCidr: vpcCidr.cidrBlock,
                tags: args.tags,
            }, {
                parent: this,
            });

            // Peer with other rn
            for(let peerVpcBlock of processed) {
                let prn = this.children[peerVpcBlock.name];
                new PeeringConnection(`${vpcBlock.name}-${peerVpcBlock.name}`, {
                    srcVpcId: rn.vpc.id,
                    dstVpcId: prn.vpc.id,
                    srcRouteTableId: rn.routeTable.id,
                    dstRouteTableId: prn.routeTable.id,
                    srcCidr: rn.vpc.cidrBlock,
                    dstCidr: prn.vpc.cidrBlock,
                    srcRegion: vpcBlock.region,
                    dstRegion: peerVpcBlock.region,
                    tags: args.tags,
                }, {
                    parent: this,
                });
            }

            processed.push(vpcBlock);
            this.children[vpcCidr.name] = rn;
        }
    }
}
