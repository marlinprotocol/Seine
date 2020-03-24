import subprocess
import random
import time
import json

# Gen
with open("gen.txt", 'r') as f:
	for tx in f:
		delta = random.random()*0.01
		# print(delta)
		time.sleep(delta)
		tx = tx.strip()
		hash = subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest sendrawtransaction '{tx}'", shell=True).decode('utf8').strip()
		# print(hash)
