import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

interface PeeringConnectionArgs {
    srcVpcId: pulumi.Input<string>;
    dstVpcId: pulumi.Input<string>;
    srcRouteTableId: pulumi.Input<string>;
    dstRouteTableId: pulumi.Input<string>;
    srcCidr: pulumi.Input<string>;
    dstCidr: pulumi.Input<string>;
    srcRegion: aws.Region;
    dstRegion: aws.Region;
    srcProvider: aws.Provider;
    dstProvider: aws.Provider;
    tags?: pulumi.Input<{[key: string]: any}>;
}

export class PeeringConnection extends pulumi.ComponentResource {

    constructor(name: string, args: PeeringConnectionArgs, opts?: pulumi.ComponentResourceOptions) {
        super("marlin:AWSPeeringConnection", name, {}, opts);

        let vpcPeeringConnection = new aws.ec2.VpcPeeringConnection(name, {
            vpcId: args.srcVpcId,
            peerVpcId: args.dstVpcId,
            peerRegion: args.dstRegion,
            tags: args.tags,
        }, {
            parent: this,
            provider: args.srcProvider,
        });

        new aws.ec2.VpcPeeringConnectionAccepter(name, {
            vpcPeeringConnectionId: vpcPeeringConnection.id,
            autoAccept: true,
            tags: args.tags,
        }, {
            parent: this,
            provider: args.dstProvider,
        });
    }
}
