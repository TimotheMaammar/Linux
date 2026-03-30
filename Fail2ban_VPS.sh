#!/bin/bash

# ─── INSTALLATION ─────────────────────────────────────────────────

apt update -q && apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban

# ─── CONFIGURATION PRINCIPALE ────────────────────────────────────────────
# On fait un jail.local 
# Ne jamais toucher jail.conf car il est écrasé à chaque mise à jour

cat > /etc/fail2ban/jail.local << 'EOF'
[DEFAULT]
# Durée de ban : 1 heure
bantime  = 3600

# Fenêtre d'observation : 10 minutes
findtime = 600

# Nombre de tentatives avant ban : 10
maxretry = 10

# Backend de logs (auto-détection de systemd ou fichier)
backend = auto

ignoreip = 127.0.0.1/8 ::1

# Action par défaut : ban uniquement
banaction = iptables-multiport

# ── SSH : protection principale ──────────────────────────────────
[sshd]
enabled  = true
port     = ssh
filter   = sshd
logpath  = /var/log/auth.log
maxretry = 6
bantime  = 7200

# ── Logging des connexions SSH réussies ────────────────────────────
[sshd-success]
enabled  = true
port     = ssh
filter   = sshd-success
logpath  = /var/log/auth.log
maxretry = 9999
bantime  = 1

# ── Scan de ports ─────────────────────────────────────────
[portscan]
enabled  = true
filter   = portscan
logpath  = /var/log/syslog
maxretry = 3
bantime  = 86400
findtime = 60
# 3 ports inconnus en 1 minute = nmap → ban 24h

# ── Fuzzing et scans ────────────
[http-scan]
enabled  = true
port     = http,https,8080,8888
filter   = http-scan
logpath  = /var/log/nginx/access.log
           /var/log/apache2/access.log
maxretry = 20
bantime  = 86400
findtime = 60
# 20 requêtes suspectes en 1 minute = ban de 24 heures

# ── Brute force HTTP ─────────────────────────────────────────
[nginx-http-auth]
enabled  = true
port     = http,https
filter   = nginx-http-auth
logpath  = /var/log/nginx/error.log
maxretry = 8
bantime  = 3600

EOF


# ─── FILTRES ───────────────────────────────────────────────

# Filtre : connexions SSH réussies
cat > /etc/fail2ban/filter.d/sshd-success.conf << 'EOF'
[Definition]
failregex = Accepted \S+ for \S+ from <HOST>
ignoreregex =
EOF

# Filtre : scan de ports
cat > /etc/fail2ban/filter.d/portscan.conf << 'EOF'
[Definition]
failregex = kernel.*IN=.*SRC=<HOST>.*DPT=(?!22|80|443|8080)\d+
ignoreregex =
EOF

# Filtre : fuzzing HTTP et scans
cat > /etc/fail2ban/filter.d/http-scan.conf << 'EOF'
[Definition]
failregex = ^<HOST> -.*"(GET|POST|HEAD).*(\.\./|\.env|\.git|wp-admin|phpmyadmin|\.php\?|union.*select|exec\(|eval\(|<script|/etc/passwd|/proc/self|nuclei|sqlmap|nikto|dirbuster|gobuster|ffuf|wfuzz)
ignoreregex =
EOF


# ─── LOG DANS UN FICHIER DÉDIÉ ────────────────────

cat > /etc/fail2ban/action.d/log-custom.conf << 'EOF'
[Definition]
actionban   = echo "[BAN]     <ip> — jail=<name> — $(date '+%%Y-%%m-%%d %%H:%%M:%%S')" >> /var/log/fail2ban-events.log
actionunban = echo "[UNBAN]   <ip> — jail=<name> — $(date '+%%Y-%%m-%%d %%H:%%M:%%S')" >> /var/log/fail2ban-events.log
EOF

# Ajouter cette action en plus du ban par défaut dans jail.local
sed -i 's/^banaction = iptables-multiport/banaction = iptables-multiport\naction = %(action_)s\n         log-custom/' /etc/fail2ban/jail.local

touch /var/log/fail2ban-events.log
chmod 644 /var/log/fail2ban-events.log


# ─── REDÉMARRAGE ET VÉRIFICATION ──────────────────────────────────

systemctl restart fail2ban
sleep 2

echo ""
echo "═══════════════════════════════════════"
echo "  Fail2ban installé et configuré ✓"
echo "═══════════════════════════════════════"
echo ""
echo "Commandes utiles :"
echo "  fail2ban-client status sshd            # Voir les IPs bannies SSH"
echo "  fail2ban-client status http-scan       # Voir les scanneurs bannis"
echo "  fail2ban-client unban X.X.X.X          # Débannir une IP"
echo "  tail -f /var/log/fail2ban.log          # Logs en direct"
echo "  tail -f /var/log/fail2ban-events.log   # Bans / unbans uniquement"
