#!/bin/bash

USER="サーバーログイン時のユーザー名"
PASSWORD="サーバーログイン時のパスワード"

script_file_dir="/var/dev/autoreport/"
score_text_file="score.txt"
tmp_text_file="tmp.txt"

score_text_file_path="${script_file_dir}${score_text_file}"
tmp_text_file_path="${script_file_dir}${tmp_text_file}"
extract_key_word="予約"

#日付の決定
target_date=`date --date '1 day ago' +%Y/%m/%d`

#一連の処理の実行
cd ${script_file_dir}
. autoLogin.sh

#sshにログインしてログ出力
extract_record(){
    echo "$1"
    auto_ssh $2 $3 "${USER}" "${PASSWORD}" $4  " tail -100 "$5" |  grep "${target_date}" | grep "${extract_key_word}" "
    echo ""
}
#sshにログインしてログ出力
extract_record_no_key(){
    echo "$1"
    auto_ssh_no_key $2 $3 $4 $5  " tail -100 "$6" |  grep "${target_date}" | grep "${extract_key_word}" "
    echo ""
}

#一連の処理
action(){

	echo ""
	echo ${target_date}
	echo ""

#ssh keyあり
		extract_record "" "ホスト" "ポート番号" "鍵" "/var/www/html/metscola/autoreserve/record.txt"
#パスワードのみ
		extract_record_no_key "" "ホスト" "ポート番号" "ユーザー名" "パスワード"
}
#ログにはく
action > ${tmp_text_file_path}
#phpを発動させる
mail_message=`/usr/bin/php ${script_file_dir}makeRecordScore.php `
echo ${mail_message} >> ${score_text_file_path}

. sendMail.sh
#メール送信
sendMailShell "fromのメルアド" "toのメルアド" "本文"
