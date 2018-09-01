#!/bin/sh
##
## 自動ログインしコマンド実行
##
auto_ssh() {
	host=$1
	port=$2
	id=$3
	pass=$4
	ssh_key=$5
	command=$6

	if [ -n "${ssh_key}" ]; then
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

##
## 自動ログインしコマンド実行
##
auto_scp() {
	host=$1
	port=$2
	id=$3
	pass=$4
	ssh_key=$5
	mode=$6
	myself=$7
	remote=$8

	fileCommand=""
	if [ ${mode} = "download" ];then
		fileCommand="${id}@${host}:${remote} ${myself}"
	elif [ ${mode} = "upload" ];then
		fileCommand=" ${myself} ${id}@${host}:${remote}"
	fi

	#statements
	#空白じゃなければ
	if [ -n "${ssh_key}" ]; then
		expect -c "
			set timeout 10
			spawn scp -P ${port}  -i ${ssh_key} ${fileCommand}
			expect \"Enter passphrase for key ${ssh_key} :\"
			send \"${pass}\n\"
			expect eof
			exit
"
	else
		expect -c "
			set timeout 10
			spawn scp -P ${port}  ${fileCommand}
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
