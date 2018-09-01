#!/bin/sh
auto_ssh() {
	host=$1
	port=$2
	id=$3
	pass=$4
	ssh_key=$5
	command=$6

	if [ -n "${SSH_KEY}" ]; then
		expect -c "
			set timeout 10
			spawn ssh ${id}@${host} -p ${port}  -i ${ssh_key}  ${command}
			expect \"Enter passphrase for key ${ssh_key} :\"
			send \"${pass}\n\"
			expect eof
			exit
"
	else
		expect -c "
			set timeout 10
			spawn ssh ${id}@${host} -p ${port} ${command}
			expect \"Are you sure you want to continue connecting (yes/no)?\" {
			send \"yes\n\"
			expect \"${id}@${host}'s password:\"
			send \"${pass}\n\"
		} \"${id}@${host}'s password:\" {
			send \"${pass}\n\"
		}
		expect eof
		exit
"
	fi
}
