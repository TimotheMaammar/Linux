for i in {1..254} ; do (ping -c 1 10.10.10.$i | grep "bytes from" &) ; done

for i in {1..254} ; do for j in {1..254} ; do (ping -c 1 10.10.$i.$j | grep "bytes from" &) ; done ; done

cat resultats.txt | awk '{print $4}' | tr -d ":"

nmap -vv -iL ping_sweep.txt
