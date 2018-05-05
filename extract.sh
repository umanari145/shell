#!/bin/bash

#################################################################
#
# 正規表現でファイルを抽出し、
# lessのコンパイルを行う
#
#################################################################

#カレントディレクトリの取得(ここは任意のディレクトに置き換える)
cd /Library/WebServer/Documents/css
#atomのプラグインに合わせoutの記述があるファイルをコンパイル対象にする
lessFileList=`grep -rEl "(.*)out(.*):(.*)css" ./* | grep .less`
lessFileARR=( `echo ${lessFileList} `)

#対象サービスのモニタリング
for lessFile in ${lessFileARR[@]}; do
  cssFilePath=`echo ${lessFile} | sed -e 's/\.less/\.css/g'`
  echo ${lessFile}
  lessc ${lessFile} ${cssFilePath}
done
