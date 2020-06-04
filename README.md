# Network management

## General architecture
6 node types:
- Monitoring - Elasticsearch instance which aggregates logs from other nodes.
- Beacon - Acts as a bootstrap node to discover other nodes in the network
- Master, Relay - Form the propagation network
- Bridge - Acts as a gateway between Eth network and our propagation network. Needs to be added as a peer to the Eth full node.
- Eth - Eth full node which is the only publicly exposed component, prevents spam

## Setup instructions

The repo has a lot of legacy scripts. Current ones are in the provisioning, deployment and orchestration folders.
1. Navigate to orchestration/katara
2. Provision instances using `pulumi up`. Can change numbers/regions/config in `index.ts`.
3. Deploy the various node types using ansible playbooks (will add instructions)
