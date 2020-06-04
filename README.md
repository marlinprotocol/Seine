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
1. Navigate to orchestration/katara.
2. Provision instances using `pulumi up`. Can change numbers/regions/config in `index.ts`.
3. Configure ansible inventory. An example is given in `inv.gcp.yml.example` to automatically configure inventory from running instances on GCP. It needs an env var `GCP_SERVICE_ACCOUNT_FILE` pointing to a service account file path (Ref: https://docs.ansible.com/ansible/latest/scenario_guides/guide_gce.html).
4. Configure ansible variables needed for various playbooks. An example is given in `ansiblevars.yml.example`.
5. Key scan instances to mark them as known hosts.
```
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" monitoring/monitoring.yml --tags=keyscan
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" beacon/beacon.yml --tags=keyscan
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" master/master.yml --tags=keyscan
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" relay/relay.yml --tags=keyscan
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" msggen/msggen.yml --tags=keyscan
```
6. Gather monitoring and beacon IPs which are used in other playbooks.
```
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" monitoring/monitoring.yml --tags=gather
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" beacon/beacon.yml --tags=gather
```
7. Deploy the various nodes
```
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" monitoring/monitoring.yml
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" beacon/beacon.yml
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" master/master.yml
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" relay/relay.yml
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" msggen/msggen.yml
```

Notes:
- monitoring.yml has a task to automatically provision a HTTPS certificate for the given domain. This needs DNS to be preconfigured to point to the monitoring instance before running.
- msggen.yml has a task tagged with `chaindata` which downloads chaindata from an existing GCS bucket to save sync time. It can be run (while geth isn't running) using
```
ansible-playbook -i inv.gcp.yml -e "@ansiblevars.yml" msggen/msggen.yml --tags=chaindata
```
