HOST_NAME=ホスト
HOST_USER=ユーザー
HOST_PASS=パスワード

# expect コマンドを実行
expect -c "
    # タイムアウト値を指定する
    set timeout 30
    # spawnでsshコマンドを実行する
    spawn ssh $HOST_USER@$HOST_NAME -p 2222

    # パスワード入力時に表示される「:(コロン)」の出力を待つ
    expect ":"

    # 「:(コロン)」が出力されたら、パスワードを送信する
    send \"$HOST_PASS\n\"

    # spawnの出力先を画面にする
    interact
    "
