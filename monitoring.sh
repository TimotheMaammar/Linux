#/bin/bash

sudo nohup konsole -e "tail -f /var/log/messages" &
sudo nohup konsole -e "tail -f /var/log/syslog" & 
