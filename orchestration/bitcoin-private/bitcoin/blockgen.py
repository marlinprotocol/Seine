import subprocess
import random
import time

while True:
	delta = random.expovariate(1 / 36)
	print(delta)
	time.sleep(delta)
	subprocess.check_output(f"/home/ubuntu/bitcoin-cli -regtest generatetoaddress 1 $(cat /home/ubuntu/address.txt)", shell=True)
