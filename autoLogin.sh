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
			expect ":"
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



#すでに.ssh/configで設定がある場合は一気にいけるので、下記のようなシンプルなパターンでOK
#鍵認証
#auto_ssh_with_config "ユーザー@ホスト" "sshキーパスワード" "コマンド"
#鍵認証なし
#auto_ssh_with_config "ユーザー@ホスト" "サーバー入る時の平文パスワード" "コマンド"


auto_ssh_with_config() {
	ssh_account=$1
	pass=$2
	command=$4

	expect -c "
			set timeout 10
			spawn ssh -t ${ssh_account} ${command}
			expect ":"
			send \"${pass}\n\"			
			expect eof
			exit
"
}