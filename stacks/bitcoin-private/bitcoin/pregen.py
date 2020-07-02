import subprocess
import random
import time
import json
import shlex

with open("/home/ubuntu/address.txt", "r") as f:
	address = f.read()

unspent_list = json.loads(subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest listunspent", shell=True).decode('utf8').strip())
unspent_list = [o for o in unspent_list if (o['amount'] >= 1 and o['address'] == address)][0:100]

# Gen
with open("gen.txt", 'w') as f:
	for i in range(10000):
		unspent = unspent_list[i]
		# print(unspent)
		amount = unspent['amount']
		hash = subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest createrawtransaction '[{{\"txid\": \"{unspent['txid']}\",\"vout\": {unspent['vout']}}}]' '[{{\"{address}\": {amount}}}]'", shell=True).decode('utf8').strip()
		# print(hash)
		outjson = shlex.quote(json.dumps([unspent]))
		hash = json.loads(subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest signrawtransactionwithwallet '{hash}' {outjson}", shell=True).decode('utf8').strip())['hex']
		# print(hash)
		f.write(hash + '\n')
		unspent = json.loads(subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest decoderawtransaction '{hash}'", shell=True).decode('utf8').strip())
		# print(unspent)
		unspent = {
			'txid': unspent['txid'],
			'vout': unspent['vout'][0]['n'],
			'scriptPubKey': unspent['vout'][0]['scriptPubKey']['hex'],
			'amount': unspent['vout'][0]['value'],
		}
		# print(unspent)
		unspent_list.append(unspent)
