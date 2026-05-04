# Commandes à faire pour rapidement inspecter les logs du relais Tor 

docker exec -it tor-relay /bin/bash
tail -f /var/log/tor/notices.log
