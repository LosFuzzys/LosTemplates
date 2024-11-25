#!/usr/bin/env bash

# Generate temporary directory per connection
DIR=$(mktemp -d --suffix=--gctf-qemu)
cd ${DIR}

echo -e "\e[1;34m[+] Generating personal access key...\e[0m"
echo ""

ssh-keygen -t ed25519 -C "player@gctf" -q -N "" -f key
cat key

echo ""
echo -e "\e[1;34m[+] 1. Paste the key to a file 'key'\e[0m"
echo -e "\e[1;34m[+] 2. Fix key permissions with 'chmod 600 key'\e[0m"

# Copy the rootfs and kernel
cp /app/rootfs.qcow2 .
cp /app/bzImage .
cp /app/flag.txt .
cp /app/module.ko .

#PORT=$(ruby -e 'require "socket"; puts Addrinfo.tcp("", 0).bind {|s| s.local_address.ip_port }')
exec 100>/tmp/port.lock || (echo "Could not spawn instance, please contact an administrator!"; exit -1)
flock -x -w 10 100 
CURRENT_PORT=`cat /tmp/port`
expr \( $CURRENT_PORT + 1 \) % \( $PUBPORTEND - $PUBPORTSTART \) > /tmp/port
flock -u 100

PORT=`expr $CURRENT_PORT + $PUBPORTSTART`

qemu-system-x86_64 -kernel ${DIR}/bzImage \
	-drive file=${DIR}/rootfs.qcow2,format=qcow2 \
	-drive file=${DIR}/key.pub,format=file \
	-drive file=${DIR}/flag.txt,format=file \
	-drive file=${DIR}/module.ko,format=file \
	-net nic -net user,hostfwd=tcp::${PORT}-:22 \
	-nographic \
	-pidfile qemupid \
	-m 256M \
	-smp 1 \
	-append "root=/dev/sda console=ttyS0" 2>&1 >/dev/null &

echo -e "\e[1;34m[+] 3. Wait 10-30 seconds for the system to boot\e[0m"
echo -e "\e[1;34m[+] 4. Clean known_hosts with ssh-keygen -R \"[${DOMAIN}]:${PORT}\"\e[0m"
echo -e "\e[1;34m[+] 5. Connect with 'ssh -p${PORT} -i key user@${DOMAIN}'\e[0m"
echo -e "\e[1;34m[+] 6. Copy exploit files with 'scp -P ${PORT} -i key ./LOCALEXPLOIT user@${DOMAIN}:~/'\e[0m"

echo ""

echo -e "\e[1;34m[+] You have ${TIMEOUT} seconds to solve it. Avoid timeouts by running it locally.\e[0m"

echo ""
echo -e "Press [ENTER] to stop the instance"
read -n1

PID=`cat qemupid`
kill -s 9 ${PID} 2>&1 >/dev/null
rm -rf ${DIR} 2>&1 >/dev/null

echo -e "Instance stopped"
