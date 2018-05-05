#!/bin/bash
#引数1:メール送信宛先
#引数2:件名
#引数3:本文

sendMailShell(){
from=$1
to=$2
subject=$3
contents=$4

/usr/sbin/sendmail -f ${from} ${to} <<EOM
From: ${from}
To: ${to}
Subject:${subject} 
Content-Type:text/plain;charset=UTF-8;

${contents}

EOM
  
}
