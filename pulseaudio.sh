#/bin/bash
# Résolution du problème de son sous Kali 2021 après une mise à jour
# Tous les périphériques étaient muets voire non-détectés, même le "Dummy output"

systemctl --user enable pulseaudio && systemctl --user start pulseaudio
