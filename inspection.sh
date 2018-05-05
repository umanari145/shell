#!/bin/bash

#################################################################
# 
# 簡易サービス稼働確認ツール
# zabbixで監視設定するまでの暫定的なシェル
#
#################################################################

#カレントディレクトリの取得
CURRENT_DIR=`dirname ${0}`

#設定ファイルの読み込み
#key=>value形式で値を保存
. ${CURRENT_DIR}/config.txt

#自動ログインとメール送信の読み込み
. ${CURRENT_DIR}/autoLogin.sh
. ${CURRENT_DIR}/sendMail.sh

#監視対象サービス
MONITORING_SERVICE_LIST=` cat monitoringServiceList.txt `
MONITORING_SERVICE_ARR=( `echo ${MONITORING_SERVICE_LIST} `)

alert_message(){
    ALERT_MESSAGE=`cat << EOS
$1が止まっています。
EOS
`
        sendMailShell "matsumoto@donow.jp" "matsumoto@donow.jp" "【警告】$1 is stop!" "${ALERT_MESSAGE}"
}

#対象サービスのモニタリング
for MONITORING_SERVICE in ${MONITORING_SERVICE_ARR[@]}; do
    #sshにログインしてログ出力
    echo ${MONITORING_SERVICE}
    #確認サービス
    RUNNIBG_PROCESS=`auto_ssh ${TARGET_HOST} ${SSH_PORT} ${USER_ID} ${PASSWORD} ${SSH_KEY} "ps -ef | grep ${MONITORING_SERVICE} | grep -v grep | wc -l" | tail -1 `
    echo "${MONITORING_SERVICE} has ${RUNNIBG_PROCESS}"
    if [[ $RUNNIBG_PROCESS < 1 ]];then
       alert_message "${MONITORING_SERVICE}" "${RUNNIBG_PROCESS}"
    fi
done


