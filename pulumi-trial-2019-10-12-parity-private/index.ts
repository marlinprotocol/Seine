import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";
import * as awsx from "@pulumi/awsx";

let regions: aws.Region[] = [
    "eu-north-1",
    "ap-south-1",
    "eu-west-3",
    "eu-west-2",
    "eu-west-1",
    "ap-northeast-2",
    "ap-northeast-1",
    "sa-east-1",
    "ca-central-1",
    "ap-southeast-1",
    "ap-southeast-2",
    "eu-central-1",
    "us-east-1",
    "us-east-2",
    "us-west-1",
    "us-west-2",
];

let vpcCidrs = regions.map((region, idx) => {
    return {
        name: region,
        region: region,
        cidrBlock: `192.168.16.${idx * 16}/28`,
    }
});

let providers: {[key: string]: aws.Provider} = {};
regions.map((region) => {
    providers[region] = new aws.Provider(region, {
        region: region,
    });
});
