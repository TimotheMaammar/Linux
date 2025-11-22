# Conversion d'un format C à un format hexadécimal échappé

xxd -i shellcode.bin > shellcode.c
cat shellcode.c | grep -oP '0x\w+' | sed 's/0x/\\x/g' | tr -d '\n' | sed 's/^/echo -ne "/; s/$/"/'
