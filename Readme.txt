■ 概要
PowerShell で公開鍵方式暗号/復号をします
「パスワードは、別メールで」は不要です
Windows、Mac、Linux のマルチプラットフォームで使用できます


■ ファイル説明
Readme.txt : このファイル
PSCrypto.ps1 : 鍵ペア作成、暗号化、復号化、その他運用機能
Design.txt : ざっくり内部仕様


■ 特徴
・良いところ
	復号用のパスワードを送る必要がありません(公開鍵を一度だけ交換)
	指定した相手以外が復号できないので誤送信リスクが低減できます
	復号時に電子署名確認可能なで、なりすましと改ざんを検出する事が出来ます
	PowerShell Core(7 以降)対応しているので、Windows、Mac、Linux のマルチプラットフォームに対応しています
	Windows 環境であれば、Windows 標準機能である Windows PowerShellで実行可能なので、スクリプト以外ののインストールは必要がありません
	スクリプトなので、どんな処理をしているか確認できます

・ 残念なところ
	GUI が無いので PC ビギナーさん向けではないかも...


■ 必要環境
Windows PowerShell 5.x(Windows 10 推奨)
PowerShell Core 7 以降(Mac、Linux、Windows)


■ インストール方法
適当なフォルダーに .ps1 をすべてコピーします
この Readme.txt では C:\PSCrypto にコピーした想定で説明します


■ アンインストール方法
レジストリ等は使用していないので、ファイルを削除します

鍵ペアを作成したのなら、-Mode RemoveKey を実行し、キーコンテナを削除します
(作成した秘密鍵を継続して使用するのであれば、削除前にエクスポートしておきます)

スクリプトと公開鍵を削除します

■ 機能
・暗号化(-Mode Encrypto)
	相手の公開鍵を -PublicKeys で指定してファイルを暗号化します
	公開鍵で指定した相手以外は復号できないので、誤送によるリスクが大幅低減します
	自分の秘密鍵で電子署名するので、改ざん/なりすまし検出が可能です
	Mac、Linux 環境では、秘密鍵のパスワードの入力が必要です

・復号化(-Mode Decrypto)
	自分の秘密鍵を使って復号化します
	オプションで、ファイル送信者公開鍵を -PublicKeys で指定すると、電子署名を確認するので、なりすましや改ざん検出が可能です
	Mac、Linux 環境では、秘密鍵のパスワードの入力が必要です

・鍵ペア作成(-Mode CreateKey)
	公開鍵と秘密鍵のセットを作成します
	作成した公開鍵を相手に渡します
	相手にも鍵ペアを作成してもらい、相手の公開鍵を入手します
	Windows 環境では、キーコンテナを削除しない限り同じ公開鍵が出力されます
	Mac、Linux 環境では、新たに鍵ペアを作成します(上書き確認有)
	Mac、Linux 環境では、秘密鍵にパスワードを設定ます

・秘密鍵パスワードテスト(-Mode TestPrivateKey)
	Mac、Linux 環境専用オプション
	秘密鍵のパスワードが正しいかの確認をします

・秘密鍵の削除(-Mode RemoveKey)
	Windows 環境専用オプション
	秘密鍵(キーコンテナ)を削除します

・キーコンテナのエクスポート(-Mode Export)
	Windows 環境専用オプション
	秘密鍵(キーコンテナ)をエクスポート(バックアップ)します

・キーコンテナエクスポートテスト(-Mode Test)
	Windows 環境専用オプション
	エクスポートしたファイルがパスワードで復号できるかをテストします

・キーコンテナのインポート(-Mode Import)
	Windows 環境専用オプション
	エクスポートしたファイルから秘密鍵(キーコンテナ)をインポート(リストア)します

引数なしでスクリプトを実行するとヘルプが表示されます


■ インストール方法
任意のフォルダーに PSCrypto.ps1 をコピーします

チュートリアル等は、以下 Web ページを見てください
http://www.vwnet.jp/Windows/PowerShell/PublicKeyCrypto.htm

■ ディレクトリ構造
スクリプトは以下ディレクトリ構造を使用します
(サブディレクトリは自動作成)

スクリプト
	スクリプトディレクトリ\PSCrypto.ps1

公開鍵
	スクリプトディレクトリ\PSScript_PublicKeys

秘密鍵(Mac、Linux)
	スクリプトディレクトリ\PSScript_PrivateKeys

キーコンテナのエクスポート先(Windows)
	スクリプトディレクトリ\PSScript_Export\UserName


■ アンインストール方法
Windows 環境で鍵ペアを作成したのなら、-Mode RemoveKey を実行し、キーコンテナを削除します
(作成した秘密鍵を継続して使用するのであれば、削除前にエクスポートしておきます)

スクリプトと鍵を削除します

■ 実行例
    -------------------------- 例 1 --------------------------

    PS >.\PSCrypto.ps1 -Mode CreateKey

    鍵ペア作成

    スクリプトフォルダーのサブフォルダ(PSCrypto_PublicKeys)が作成され、公開鍵(UserName_Publickey.xml)が出力されます
    Windows 環境では、キーコンテナを削除しない限り同じ公開鍵が出力されます
    Mac、Linux 環境では、サブフォルダ(PSCrypto_PrivateKeys)が作成され、秘密鍵鍵(UserName_Privatekey.key)が出力されます

    ローカルに出力された鍵のファイル名は変更しないでください(スクリプトが処理内で参照しています)
    相手に渡す公開鍵のファイル名を変更したい場合は、別途公開鍵をコピーし、ファイル名変更してください




    -------------------------- 例 2 --------------------------

    PS >.\PSCrypto.ps1 -Mode TestPrivateKey

    Mac、Linux 用秘密鍵のパスワードをテストします
    (Mac、Linux 環境専用)




    -------------------------- 例 3 --------------------------

    PS >.\PSCrypto.ps1 -Mode RemoveKey

    キーコンテナ(Windows 用秘密鍵)を削除します
    (Windows 環境専用)




    -------------------------- 例 4 --------------------------

    PS >.\PSCrypto.ps1 -Mode Encrypto -PublicKeys .\PublicKey\UserName_Publickey.xml -Path C:\Data\SecretData.zip

    指定ファイルを暗号化します

    -PublicKeys に相手の公開鍵を指定します
    複数相手に対して暗号化する場合は、公開鍵をカンマで区切って下さい


    暗号化する元ファイルと同一フォルダーに暗号化ファイル(.enc)が出力されます
    -Outfile を指定すると暗号化ファイルのフルパスが指定できます

    Mac、Linux 環境では、秘密鍵のパスワード入力が必要です




    -------------------------- 例 5 --------------------------

    PS >.\PSCrypto.ps1 C:\Data\SecretData.zip UserName

    省略形で指定ファイルを暗号化します
    既定のフォルダ(スクリプトフォルダーの PublicKeys)に公開鍵を置いている場合は、公開鍵の Path と _Publickey.xml を省略
    し、相手の UserName だけで公開鍵を指定することが出来ます

    複数相手に対して暗号化する場合は、-PublicKeys オプションを明示的に指定し、公開鍵をカンマで区切って下さい

    PS > .\PSCrypto.ps1 C:\Data\SecretData.zip -PublicKeys UserA, UserB




    -------------------------- 例 6 --------------------------

    PS >.\PSCrypto.ps1 -Mode Decrypto -Path C:\Data\SecretData.enc

    暗号化されたファイルを復号化します

    暗号化ファイルと同一フォルダーに元ファイル名で復号化されます
    -Outfile を指定すると復号化ファイルの出力先フルパスが指定できます

    Mac、Linux 環境では、秘密鍵のパスワード入力が必要です




    -------------------------- 例 7 --------------------------

    PS >.\PSCrypto.ps1 C:\Data\SecretData.enc

    省略形で暗号化されたファイルを復号化します




    -------------------------- 例 8 --------------------------

    PS >.\PSCrypto.ps1 -Mode Decrypto -PublicKeys .\PublicKey\UserName_Publickey.xml -Path C:\Data\SecretData.enc

    暗号化されたファイルを復号化し、電子署名を検証します

    -PublicKeys に送信者の公開鍵を指定し、電子署名を確認します

    暗号化ファイルと同一フォルダーに元ファイル名で復号化されます
    -Outfile を指定すると復号化されたファイルの出力先フルパスが指定できます

    Mac、Linux 環境では、秘密鍵のパスワード入力が必要です




    -------------------------- 例 9 --------------------------

    PS >.\PSCrypto.ps1 C:\Data\SecretData.enc UserName

    省略形で暗号化されたファイルを復号化し、電子署名を検証します
    既定のフォルダ(スクリプトフォルダーの PublicKeys)に公開鍵を置いている場合は、公開鍵の Path と _Publickey.xml を省略
    し、相手の UserName だけで公開鍵を指定することが出来ます




    -------------------------- 例 10 --------------------------

    PS >.\PSCrypto.ps1 -Mode Export

    キーコンテナ(Windows 用秘密鍵)のエクスポート(バックアップ)をします

    スクリプトフォルダーのサブフォルダ(.\PSCrypto_Export\UserName)に PSCryptoExport.dat が出力されます
    (Windows 環境専用)




    -------------------------- 例 11 --------------------------

    PS >.\PSCrypto.ps1 -Mode Import

    キーコンテナ(Windows 用秘密鍵)のインポート(リストア)をします

    スクリプトフォルダーのサブフォルダ(.\PSCrypto_Export\UserName)にある PSCryptoExport.dat からインポートします
    スクリプトフォルダーのサブフォルダ(.\PSCrypto_Export\UserName)に PSCryptoExport.dat が無い場合は、スクリプトフォル
    ダーにある PSCryptoExport.dat からインポートします
    (Windows 環境専用)




    -------------------------- 例 12 --------------------------

    PS >.\PSCrypto.ps1 -Mode Test

    エクスポートしたキーコンテナのテスト

    エクスポートしたキーコンテナが復号できるかテストします
    スクリプトフォルダーのサブフォルダ(.\PSCrypto_\UserName)にある PSCryptoExport.dat をテストします

    キーコンテナ(Windows 用秘密鍵)をエクスポート(バックアップ)した際は、念のためにこのテストをしてください


■ 使用しているアルゴリズム
・暗号/復号/ハッシュ
	RSA 公開鍵暗号
	AES 256
	SHA 256

・電子署名
	RSA 電子証明(SHA256)


■ Web サイト
PowerShell で公開鍵方式暗号ファイルを交換をする
http://www.vwnet.jp/Windows/PowerShell/PublicKeyCrypto.htm


■ 更新履歴
0.10 2016/06/01 プロトタイプ完成
0.20 2016/06/05 Beta 1
0.30 2016/06/09 RC 1
0.32 2016/06/12 RC 2
2.00 2017/12/27 処理効率化と暗号データフォーマット変更
2.01 2017/12/29 細々と改良/エクスポートフォルダ場所変更
2.02 2007/12/31 Export/Import/Test フォルダを任意指定できるようにした
2.10 2020/10/15 Mac、Linux サポート(その他チューニング)
