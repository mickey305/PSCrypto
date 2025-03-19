<#
.SYNOPSIS
概要
公開鍵方式暗号を使用して、ファイルの暗号化/復号化をします
公開鍵方式なので、復号パスワードを相手に送る必要はありません

Windows、Mac、Linux のマルチプラットフォームで使用できます

任意のフォルダーに PSCrypto.ps1 を置いて使用してください
スクリプトを置いたサブフォルダーに公開鍵(Mac、Linuxは公開鍵)が配置されます

<CommonParameters> はサポートしていません

.DESCRIPTION
・暗号化(-Mode Encrypto)
    相手の公開鍵を -PublicKeys で指定してファイルを暗号化します
    公開鍵で指定した相手以外は復号できないので、誤送によるリスクが大幅低減します
    自分の秘密鍵で電子署名するので、改ざん/なりすまし検出が可能です
    Mac、Linux 環境では、秘密鍵のパスワードの入力が必要です

・復号化(-Mode Decrypto)
    自分の秘密鍵を使って復号化します
    ファイル送信者公開鍵を -PublicKeys で指定すると、電子署名を確認するので、なりすましや改ざん検出が可能です
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


.EXAMPLE
PS > .\PSCrypto.ps1 -Mode CreateKey
鍵ペア作成

スクリプトフォルダーのサブフォルダ(PSCrypto_PublicKeys)が作成され、公開鍵(UserName_Publickey.xml)が出力されます
Windows 環境では、キーコンテナを削除しない限り同じ公開鍵が出力されます
Mac、Linux 環境では、サブフォルダ(PSCrypto_PrivateKeys)が作成され、秘密鍵鍵(UserName_Privatekey.key)が出力されます

ローカルに出力された鍵のファイル名は変更しないでください(スクリプトが処理内で参照しています)
相手に渡す公開鍵のファイル名を変更したい場合は、別途公開鍵をコピーし、ファイル名変更してください

.EXAMPLE
PS > .\PSCrypto.ps1 -Mode TestPrivateKey
Mac、Linux 用秘密鍵のパスワードをテストします
(Mac、Linux 環境専用)

.EXAMPLE
PS > .\PSCrypto.ps1 -Mode RemoveKey
キーコンテナ(Windows 用秘密鍵)を削除します
(Windows 環境専用)

.EXAMPLE
PS > .\PSCrypto.ps1 -Mode Encrypto -PublicKeys .\PublicKey\UserName_Publickey.xml -Path C:\Data\SecretData.zip
指定ファイルを暗号化します

-PublicKeys に相手の公開鍵を指定します
複数相手に対して暗号化する場合は、公開鍵をカンマで区切って下さい


暗号化する元ファイルと同一フォルダーに暗号化ファイル(.enc)が出力されます
-Outfile を指定すると暗号化ファイルのフルパスが指定できます

Mac、Linux 環境では、秘密鍵のパスワード入力が必要です


.EXAMPLE
PS > .\PSCrypto.ps1 C:\Data\SecretData.zip UserName
省略形で指定ファイルを暗号化します
既定のフォルダ(スクリプトフォルダーの PublicKeys)に公開鍵を置いている場合は、公開鍵の Path と _Publickey.xml を省略し、相手の UserName だけで公開鍵を指定することが出来ます

複数相手に対して暗号化する場合は、-PublicKeys オプションを明示的に指定し、公開鍵をカンマで区切って下さい

PS > .\PSCrypto.ps1 C:\Data\SecretData.zip -PublicKeys UserA, UserB

.EXAMPLE
PS > .\PSCrypto.ps1 -Mode Decrypto -Path C:\Data\SecretData.enc
暗号化されたファイルを復号化します

暗号化ファイルと同一フォルダーに元ファイル名で復号化されます
-Outfile を指定すると復号化ファイルの出力先フルパスが指定できます

Mac、Linux 環境では、秘密鍵のパスワード入力が必要です


.EXAMPLE
PS > .\PSCrypto.ps1 C:\Data\SecretData.enc
省略形で暗号化されたファイルを復号化します


.EXAMPLE
PS > .\PSCrypto.ps1 -Mode Decrypto -PublicKeys .\PublicKey\UserName_Publickey.xml -Path C:\Data\SecretData.enc
暗号化されたファイルを復号化し、電子署名を検証します

-PublicKeys に送信者の公開鍵を指定し、電子署名を確認します

暗号化ファイルと同一フォルダーに元ファイル名で復号化されます
-Outfile を指定すると復号化されたファイルの出力先フルパスが指定できます

Mac、Linux 環境では、秘密鍵のパスワード入力が必要です


.EXAMPLE
PS > .\PSCrypto.ps1 C:\Data\SecretData.enc UserName
省略形で暗号化されたファイルを復号化し、電子署名を検証します
既定のフォルダ(スクリプトフォルダーの PublicKeys)に公開鍵を置いている場合は、公開鍵の Path と _Publickey.xml を省略し、相手の UserName だけで公開鍵を指定することが出来ます


.EXAMPLE
PS > .\PSCrypto.ps1 -Mode Export
キーコンテナ(Windows 用秘密鍵)のエクスポート(バックアップ)をします

スクリプトフォルダーのサブフォルダ(.\PSCrypto_Export\UserName)に PSCryptoExport.dat が出力されます
(Windows 環境専用)

.EXAMPLE
PS > .\PSCrypto.ps1 -Mode Import
キーコンテナ(Windows 用秘密鍵)のインポート(リストア)をします

スクリプトフォルダーのサブフォルダ(.\PSCrypto_Export\UserName)にある PSCryptoExport.dat からインポートします
スクリプトフォルダーのサブフォルダ(.\PSCrypto_Export\UserName)に PSCryptoExport.dat が無い場合は、スクリプトフォルダーにある PSCryptoExport.dat からインポートします
(Windows 環境専用)

.EXAMPLE
PS > .\PSCrypto.ps1 -Mode Test
エクスポートしたキーコンテナのテスト

エクスポートしたキーコンテナが復号できるかテストします
スクリプトフォルダーのサブフォルダ(.\PSCrypto_\UserName)にある PSCryptoExport.dat をテストします

キーコンテナ(Windows 用秘密鍵)をエクスポート(バックアップ)した際は、念のためにこのテストをしてください

.PARAMETER Mode
操作モード
    鍵ペア作成: CreateKey
    秘密鍵テスト: TestPrivateKey
    秘密鍵削除: RemoveKey
    暗号化: Encrypto
    復号化: Decrypto
    Export: Export
    Import: Import
    Test: Test


.PARAMETER PublicKeys
公開鍵
    複数指定する場合はカンマで区切ります
    既定のフォルダ(スクリプトフォルダーの PublicKeys)に公開鍵を置いている場合は、公開鍵の Path と _Publickey.xml を省略し、相手の UserName だけで公開鍵を指定することが出来ます

.PARAMETER Path
暗号/復号するファイルの Path
絶対 Path、相対 Path のいずれでも指定できます

.PARAMETER Outfile
出力ファイル(省略可)

<CommonParameters> はサポートしていません

.LINK
http://www.vwnet.jp/Windows/PowerShell/PublicKeyCrypto.htm
#>


##########################################################
# 暗号化、復号化、鍵生成、Export、Import
##########################################################
param(
	[string]$Path,			# 入力ファイル名
	[string[]]$PublicKeys,	# 公開鍵
	[ValidateSet("Decrypto", "Encrypto", "CreateKey", "TestPrivateKey", "RemoveKey", "Export", "Import", "Test")]
		[string]$Mode,		# モード
	[string]$Outfile		# 出力ファイル名
	)

# $Debug = $True

# 暗号データフォーマット バージョン
$C_Vertion = "02"

# モード
$C_Mode_Decrypto = "Decrypto"				# 復号
$C_Mode_Encrypto = "Encrypto"				# 暗号
$C_Mode_CreateKey = "CreateKey"				# キー作成
$C_Mode_RemoveKey = "RemoveKey"				# キー削除
$C_Mode_Export = "Export"					# Export
$C_Mode_Test = "Test"						# Test
$C_Mode_Import = "Import"					# Import
$C_Mode_PrivateKeyTest = "TestPrivateKey"	# プライベート鍵テスト

# セッション鍵サイズ(bit)
$C_SessionKeyLength = 256

# キーコンテナ名
$C_ContainerName = "PowerShellEncrypto"

# 署名サイズ(bit)
$C_SignatureLength = 128

# ハッシュ値サイズ(bit)
$C_HashLength = 256

# 暗号化したSessionキーサイズ
$C_EncryptoSessionKeyLength = 128

# 拡張子
$C_Extension = "enc"

# Windows ?
if( $PSVersionTable.PSVersion.Major -le 5 ){
	$C_IsWindows = $True
}
elseif( $PSVersionTable.Platform -eq "Win32NT" ){
	$C_IsWindows = $True
}
else{
	$C_IsWindows = $False
}

# ログインユーザー名
if( $C_IsWindows ){
	$C_UserName = $env:USERNAME
}
else{
	$C_UserName = $env:USER
}

# スクリプトフルパス
$C_ScriptFullFileName = $MyInvocation.MyCommand.Path

# スクリプトフォルダ
$C_ScriptDirectory = $PSScriptRoot

# (旧)公開鍵出力場所
$C_Old_PulicKeyLocation = Join-Path $C_ScriptDirectory "PublicKeys"

# 公開鍵出力場所
$C_PulicKeyLocation = Join-Path $C_ScriptDirectory "PSScript_PublicKeys"

# 公開鍵のプレフィックス + 拡張子
$C_PublicKeyExtentPart = ".xml"
$C_PublicKeyExtent = "_PublicKey" + $C_PublicKeyExtentPart

# 公開鍵名
$C_PublicKeyName = $C_UserName + $C_PublicKeyExtent

# 公開鍵のフルパス
$C_PublicKeyFullPath = Join-Path $C_PulicKeyLocation $C_PublicKeyName

# 秘密鍵出力場所
$C_PrivateKeyLocation = Join-Path $PSScriptRoot "PSScript_PrivateKeys"

# 秘密鍵のプレフィックス + 拡張子
$C_PrivateKeyExtentPart = ".key"
$C_PrivateKeyExtent = "_PrivateKey" + $C_PrivateKeyExtentPart

# 秘密鍵名
$C_PrivateKeyName = $C_UserName + $C_PrivateKeyExtent

# 秘密鍵のフルパス
$C_PrivateKeyFullPath = Join-Path $C_PrivateKeyLocation $C_PrivateKeyName


# キーコンテナ名 Export フォルダ
$TmpExportDirectory = Join-Path $C_ScriptDirectory "PSScript_Export"
$C_ExportDirectory = Join-Path $TmpExportDirectory $C_UserName

# キーコンテナ名 Export ファイル名
$C_ExportFileName = "PSCryptoExport.dat"

# キーコンテナ Export フルパス
$C_ExportFullFileName = Join-Path $C_ExportDirectory $C_ExportFileName


##################################################
# セッション鍵生成
##################################################
function CreateRandomKey( $KeyBitSize ){
	if( ($KeyBitSize % 8) -ne 0 ){
		Write-Output "Key size Error"
		return $null
	}
	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# バイト数にする
	$ByteSize = $KeyBitSize / 8

	# 入れ物作成
	$KeyBytes = New-Object byte[] $ByteSize

	# オブジェクト 作成
	$RNG = New-Object System.Security.Cryptography.RNGCryptoServiceProvider

	# 鍵サイズ分の乱数を生成
	$RNG.GetNonZeroBytes($KeyBytes)

	# オブジェクト削除
	$RNG.Dispose()

	return $KeyBytes
}

##################################################
# AES 暗号化
##################################################
function AESEncrypto($KeyByte, $PlainByte){
	$KeySize = 256
	$BlockSize = 128
	$Mode = "CBC"
	$Padding = "PKCS7"

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# AES オブジェクトの生成
	$AES = New-Object System.Security.Cryptography.AesCryptoServiceProvider

	# 各値セット
	$AES.KeySize = $KeySize
	$AES.BlockSize = $BlockSize
	$AES.Mode = $Mode
	$AES.Padding = $Padding

	# IV 生成
	$AES.GenerateIV()

	# 生成した IV
	$IV = $AES.IV

	# 鍵セット
	$AES.Key = $KeyByte

	# 暗号化オブジェクト生成
	$Encryptor = $AES.CreateEncryptor()

	# 暗号化
	$EncryptoByte = $Encryptor.TransformFinalBlock($PlainByte, 0, $PlainByte.Length)

	# IV と暗号化した文字列を結合
	$DataByte = $IV + $EncryptoByte

	# オブジェクト削除
	$Encryptor.Dispose()
	$AES.Dispose()

	return $DataByte
}

##################################################
# AES 復号化
##################################################
function AESDecrypto($ByteKey, $ByteString){
	$KeySize = 256
	$BlockSize = 128
	$IVSize = $BlockSize / 8
	$Mode = "CBC"
	$Padding = "PKCS7"

	# IV を取り出す
	$IV = @()
	for( $i = 0; $i -lt $IVSize; $i++){
		$IV += $ByteString[$i]
	}

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# オブジェクトの生成
	$AES = New-Object System.Security.Cryptography.AesCryptoServiceProvider

	# 各値セット
	$AES.KeySize = $KeySize
	$AES.BlockSize = $BlockSize
	$AES.Mode = $Mode
	$AES.Padding = $Padding

	# IV セット
	$AES.IV = $IV

	# 鍵セット
	$AES.Key = $ByteKey

	# 復号化オブジェクト生成
	$Decryptor = $AES.CreateDecryptor()

	try{
		# 復号化
		$DecryptoByte = $Decryptor.TransformFinalBlock($ByteString, $IVSize, $ByteString.Length - $IVSize)
	}
	catch{
		$DecryptoByte = $null
	}

	# オブジェクト削除
	$Decryptor.Dispose()
	$AES.Dispose()

	return $DecryptoByte
}


##################################################
# キーコンテナテスト
##################################################
function RSAKeyContainerTest(){

	# コンテナ名
	$ContainerName = $C_ContainerName

	# 自分の公開鍵
	$PublicKeyPath = $C_PublicKeyFullPath
	if( -not (Test-Path $PublicKeyPath)){
		Write-Output "Private key not found.: $PublicKeyPath"
		exit
	}

	$PublicKey = Get-Content -Path $PublicKeyPath -Encoding UTF8


	# テストする文字列
	$PlainDataString = "12345678901234567890123456789012"
	$PlainDataByte = String2Byte $PlainDataString

	# 自分の公開鍵で公開鍵暗号
	$EncryptedByte = RSAEncrypto $PublicKey $PlainDataByte

	# 自分の秘密鍵で秘密鍵復号
	$DecryptoByte = RSADecryptoCSP $ContainerName $EncryptedByte

	if( $null -eq $DecryptoByte ){
		return $False
	}
	else{
		$DecryptoString = Byte2String $DecryptoByte
		if( $DecryptoString -ne $PlainDataString){
			return $False
		}
	}

	return $True
}


##################################################
# 公開鍵 暗号化
##################################################
function RSAEncrypto($PublicKey, $PlainByte){
	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# RSACryptoServiceProviderオブジェクト作成
	$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider

	# 公開鍵を指定
	$RSA.FromXmlString($PublicKey)

	# 暗号化
	$EncryptedByte = $RSA.Encrypt($PlainByte, $False)

	# オブジェクト削除
	$RSA.Dispose()

	return $EncryptedByte
}

#####################################################################
#  CSP キーコンテナに保存されている秘密鍵を使って文字列を復号化する
#####################################################################
function RSADecryptoCSP($ContainerName, $EncryptedByte){

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# CspParameters オブジェクト作成
	$CSPParam = New-Object System.Security.Cryptography.CspParameters

	# CSP キーコンテナ名
	$CSPParam.KeyContainerName = $ContainerName

	# RSACryptoServiceProviderオブジェクト作成し秘密鍵を取り出す
	$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider($CSPParam)

	try{
		# 復号
		$DecryptedData = $RSA.Decrypt($EncryptedByte, $False)
	}
	catch{
		$DecryptedData = $null
	}
	# オブジェクト削除
	$RSA.Dispose()

	return $DecryptedData
}

#####################################################################
#  秘密鍵を使って文字列を復号化する
#####################################################################
function RSADecryptoPrivateKey($PrivateKey, $EncryptedByte){
	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# CspParameters オブジェクト作成
	$CSPParam = New-Object System.Security.Cryptography.CspParameters

	# 秘密鍵を取り出す
	$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider
	$RSA.FromXmlString($PrivateKey)

	try{
		# 復号
		$DecryptedData = $RSA.Decrypt($EncryptedByte, $False)
	}
	catch{
		$DecryptedData = $null
	}
	# オブジェクト削除
	$RSA.Dispose()

	return $DecryptedData
}

#####################################################################
# CSP キーコンテナに保存されている秘密鍵を使って署名を作る
#####################################################################
function RSASignatureCSP($ContainerName, $BaseByte){

	# SHA256 Hash 値を求める
	$HashBytes = GetSHA256Hash $BaseByte

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# CspParameters オブジェクト作成
	$CSPParam = New-Object System.Security.Cryptography.CspParameters

	# CSP キーコンテナ名
	$CSPParam.KeyContainerName = $ContainerName

	# RSACryptoServiceProviderオブジェクト作成し秘密鍵を取り出す
	$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider($CSPParam)

	# RSAPKCS1SignatureFormatterオブジェクト作成
	$Formatter = New-Object System.Security.Cryptography.RSAPKCS1SignatureFormatter($RSA)

	# ハッシュアルゴリズムを指定
	$Formatter.SetHashAlgorithm("SHA256")

	# 署名を作成
	$SignatureByte = $Formatter.CreateSignature($HashBytes)

	# オブジェクト削除
	$RSA.Dispose()

	return $SignatureByte
}

#####################################################################
# 秘密鍵の取得
#####################################################################
function GetPrivateKey(){
	# ログインユーザー名
	$MyName = $C_UserName

	# 秘密鍵 full path
	$PrivateKeyFile = $C_PrivateKeyFullPath

	# 秘密鍵を復号する
	if( Test-Path $PrivateKeyFile ){
		$PrivateKeyBase64 = Get-Content -Path $PrivateKeyFile -Encoding utf8
		$PrivateKeyByte = Base642Byte $PrivateKeyBase64

		$PlainPrivateKeyByte = DecryptoPasswordData "Input Private key password" $PrivateKeyByte

		$PrivateKey = Byte2String $PlainPrivateKeyByte

	}
	else{
		Write-Output "Private key not found : $PrivateKeyFile"
		exit
	}

	return $PrivateKey
}

#####################################################################
# 秘密鍵を使って署名を作る
#####################################################################
function RSASignaturePrivateKey($BaseByte){

	# 秘密鍵の取得
	$PrivateKey = GetPrivateKey

	# SHA256 Hash 値を求める
	$HashBytes = GetSHA256Hash $BaseByte

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# 秘密鍵をセット
	$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider
	$RSA.FromXmlString($PrivateKey)

	# RSAPKCS1SignatureFormatterオブジェクト作成
	$Formatter = New-Object System.Security.Cryptography.RSAPKCS1SignatureFormatter($RSA)

	# ハッシュアルゴリズムを指定
	$Formatter.SetHashAlgorithm("SHA256")

	# 署名を作成
	$SignatureByte = $Formatter.CreateSignature($HashBytes)

	# オブジェクト削除
	$RSA.Dispose()

	return $SignatureByte
}


#####################################################################
# 公開鍵を使って署名を確認する
#####################################################################
function RSAVerifySignature($PublicKey, $SignatureByte, $BaseByte){

	# SHA256 Hash 値を求める
	$HashBytes = GetSHA256Hash $BaseByte

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# RSACryptoServiceProviderオブジェクト作成
	$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider

	# 公開鍵をセット
	$RSA.FromXmlString($PublicKey)

	# RSAPKCS1SignatureDeformatterオブジェクト作成
	$Deformatter = New-Object System.Security.Cryptography.RSAPKCS1SignatureDeformatter($RSA)

	# ハッシュアルゴリズムを指定
	$Deformatter.SetHashAlgorithm("SHA256")

	# 署名を検証する
	$Result = $Deformatter.VerifySignature($HashBytes, $SignatureByte)

	# オブジェクト削除
	$RSA.Dispose()

	return $Result
}

##################################################
#  鍵を作成し CSP キーコンテナに保存
##################################################
function RSACreateKeyCSP($ContainerName){

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# CspParameters オブジェクト作成
	$CSPParam = New-Object System.Security.Cryptography.CspParameters

	# CSP キーコンテナ名
	$CSPParam.KeyContainerName = $ContainerName

	# RSACryptoServiceProviderオブジェクト作成し秘密鍵を格納
	$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider($CSPParam)

	# 公開鍵
	$PublicKey = $RSA.ToXmlString($False)

	# オブジェクト削除 (PS2 でサポートされていないのでコメントアウト)
	$RSA.Dispose()

	return $PublicKey
}

##################################################
# CSP キーコンテナのエクスポート
##################################################
function RSAExportCSP($ContainerName){

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# CspParameters オブジェクト作成
	$CSPParam = New-Object System.Security.Cryptography.CspParameters

	# CSP キーコンテナ名
	$CSPParam.KeyContainerName = $ContainerName

	# RSACryptoServiceProviderオブジェクト作成
	$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider($CSPParam)

	# エクスポート
	$ByteData = $RSA.ExportCspBlob($True)

	# オブジェクト削除
	$RSA.Dispose()

	return $ByteData
}

##################################################
# CSP キーコンテナのインポート
##################################################
function RSAImportCSP($ContainerName, $ExpoprtByte){
	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# CspParameters オブジェクト作成
	$CSPParam = New-Object System.Security.Cryptography.CspParameters

	# CSP キーコンテナ名
	$CSPParam.KeyContainerName = $ContainerName

	# RSACryptoServiceProviderオブジェクト作成
	$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider($CSPParam)

	# インポート
	$RSA.ImportCspBlob($ExpoprtByte)

	# オブジェクト削除
	$RSA.Dispose()

	return
}

##################################################
# CSP キーコンテナ削除
##################################################
function RSARemoveCSP($ContainerName){

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# CspParameters オブジェクト作成
	$CSPParam = New-Object System.Security.Cryptography.CspParameters

	# CSP キーコンテナ名
	$CSPParam.KeyContainerName = $ContainerName

	# RSACryptoServiceProviderオブジェクト作成
	$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider($CSPParam)

	# CSP キーコンテナ削除
	$RSA.PersistKeyInCsp = $False
	$RSA.Clear()

	# オブジェクト削除
	$RSA.Dispose()

	return
}

###########################################
# SHA256 ハッシュを求める
###########################################
function GetSHA256Hash($BaseByte){

	# アセンブリロード
	Add-Type -AssemblyName System.Security

	# SHA256 オブジェクトの生成
	$SHA = New-Object System.Security.Cryptography.SHA256CryptoServiceProvider

	# SHA256 Hash 値を求める
	$HashBytes = $SHA.ComputeHash($BaseByte)

	# SHA256 オブジェクトの破棄
	$SHA.Dispose()

	return $HashBytes
}


#####################################################################
# 文字列をバイト配列にする
#####################################################################
function String2Byte( $String ){
	$Byte = [System.Text.Encoding]::UTF8.GetBytes($String)
	return $Byte
}

#####################################################################
# バイト配列を文字列にする
#####################################################################
function Byte2String( $Byte ){
	$String = [System.Text.Encoding]::UTF8.GetString($Byte)
	return $String
}

#####################################################################
# Base64 をバイト配列にする
#####################################################################
function Base642Byte( $Base64 ){
	$Byte = [System.Convert]::FromBase64String($Base64)
	return $Byte
}

#####################################################################
# バイト配列を Base64 にする
#####################################################################
function Byte2Base64( $Byte ){
	$Base64 = [System.Convert]::ToBase64String($Byte)
	return $Base64
}

#####################################################################
# 指定場所から指定バイト数取り出す
#####################################################################
function GetByteDate($Byte, $Start, $Length ){
	if( $null -eq $Length ){
		$DataSize = $Byte.Length
		$Length = $DataSize - $Start
	}

	$ReturnData = New-Object byte[] $Length

	[System.Array]::Copy($Byte, $Start, $ReturnData, 0, $Length)

	return $ReturnData
}

#################################################
# セキュアストリングから平文にコンバートする
#################################################
function SecureString2PlainString($SecureString){
	$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecureString)
	$PlainString = [System.Runtime.InteropServices.Marshal]::PtrToStringBSTR($BSTR)

	# $BSTRを削除
	[System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR)

	return $PlainString
}

#####################################################################
# 公開鍵の存在確認
#####################################################################
function ExistTestPublicKey($PublicKey){
	# 公開鍵の存在確認
	if( -not ( Test-Path $PublicKey )){
		# 拡張子付加してみる
		$TmpPublicKey = $PublicKey + $C_PublicKeyExtentPart
		if( -not (Test-Path $TmpPublicKey )){
			# サフィックス追加してみる
			$TmpPublicKey = $PublicKey + $C_PublicKeyExtent
			if( -not (Test-Path $TmpPublicKey )){
				# default 格納場所確認
				$TmpPublicKey = Join-Path $C_PulicKeyLocation $PublicKey
				if( -not (Test-Path $TmpPublicKey )){
					# default に拡張子付加してみる
					$TmpPublicKey = Join-Path $C_PulicKeyLocation ($PublicKey + $C_PublicKeyExtentPart)
					if( -not (Test-Path $TmpPublicKey )){
						# default にサフィックス追加してみる
						$TmpPublicKey = Join-Path $C_PulicKeyLocation ($PublicKey + $C_PublicKeyExtent)
						if( -not (Test-Path $TmpPublicKey )){
							return $null
						}
					}
				}
			}
		}
		$PublicKey = Convert-Path $TmpPublicKey
	}
	return $PublicKey
}

#####################################################################
# 暗号化処理
#####################################################################
function Encrypto( [string[]]$PublicKeys, $Path, $Outfile ){

	# キーコンテナ確認
	if( $C_IsWindows ){
		$Status = RSAKeyContainerTest
		if( -not $Status ){
			Write-Output "Key Container not found."
			exit
		}
	}

	# 必須チェック
	if( $PublicKeys.Count -eq 0 ){
		Write-Output "-PublicKeys not set."
		exit
	}

	if( $Path -eq [string]$null ){
		Write-Output "-Path not set."
		exit
	}

	# バージョン番号をバイト配列にする
	$VertionNameByte = String2Byte $C_Vertion

	# 公開鍵
	$PublicKeyXMLs = @()
	foreach( $PublicKey in $PublicKeys ){
		$PublicKey = ExistTestPublicKey $PublicKey
		if( $null -eq $PublicKey ){
			Write-Output "Fail !! $PublicKey not found."
			exit
		}

		# 公開鍵を読む
		$PublicKeyXMLs += Get-Content $PublicKey -Encoding UTF8
	}

	# 公開鍵の数
	$PublicKeyNumber = $PublicKeys.Length
	if( $PublicKeyNumber -ge 0xff ){
		Write-Output "The number of public keys is greater than 255."
		exit
	}
	$PublicKeyNumberByte = New-Object byte[] 1
	$PublicKeyNumberByte[0] = [byte]$PublicKeyNumber

	# 対象ファイル存在確認
	if( -not (Test-Path $Path )){
		Write-Output "Fail !! $Path not found."
		exit
	}

	# 平文ファイルをバイナリリードする
    $Path = Convert-Path $Path
	$PlainFileDataByte = [System.IO.File]::ReadAllBytes($Path)

	# オリジナルファイル名
	$OriginalFileNameString = Split-Path $Path -Leaf

	# オリジナルファイル名をバイト配列にする
	$OriginalFileNameByte = String2Byte $OriginalFileNameString

	# ファイル名長
	$OriginalFileNameLength = $OriginalFileNameByte.Length
	if( $OriginalFileNameLength -ge 0xff ){
		Write-Output "The size of the file names longer than 255 characters."
		exit
	}
	$OriginalFileNameLengthByte = New-Object byte[] 1
	$OriginalFileNameLengthByte[0] = [byte]$OriginalFileNameLength

	# 256 bit のセッション鍵生成
	$SessionKeyByte = CreateRandomKey $C_SessionKeyLength

	# セッション鍵を使い平文を AES256 で暗号化
	$EncryptoFileDataByte = AESEncrypto $SessionKeyByte $PlainFileDataByte

	$EncryptoSessionKeyByte = @()
	foreach( $PublicKeyXML in $PublicKeyXMLs ){
		# セッション鍵を RSA 公開鍵で暗号化
		$EncryptoSessionKeyByte += RSAEncrypto $PublicKeyXML $SessionKeyByte
	}

	# 各データー連結
	# $EncriptoDataByte = $OriginalFileNameLengthByte + $OriginalFileNameByte + $PublicKeyNumberByte + $EncryptoSessionKeyByte + $EncryptoFileDataByte
	$EncriptoDataByte = $VertionNameByte + `			# バージョン
					$OriginalFileNameLengthByte + `		# ファイル名長
					$OriginalFileNameByte + `			# ファイル名
					$PublicKeyNumberByte + `			# 公開鍵数
					$EncryptoSessionKeyByte + `			# 公開鍵暗号化セッション鍵
					$EncryptoFileDataByte				# IV + AES256暗号文


	# 署名を作る
	if( $C_IsWindows ){
		$SignatureByte = RSASignatureCSP $C_ContainerName $EncriptoDataByte
	}
	else{
		$SignatureByte = RSASignaturePrivateKey $EncriptoDataByte
	}

	# 署名する
	# $SignaturedEncriptoDataByte = $SignatureByte + $EncriptoDataByte
	$SignaturedEncriptoDataByte = $SignatureByte + `	# 署名
					$EncriptoDataByte					# データ

	# 出力ファイル名が未指定の場合はデフォルトの出力ファイル名にする
	if( $Outfile -eq [string]$null ){
		# Path
		$Parent = Split-Path $path -Parent

		#ファイル名
		$Leaf = Split-Path $path -Leaf

		# 拡張子抜きのファイル名
		$FileName = $Leaf.Split(".")
		$NonExtensionFileName = ""
		$Index = $FileName.Length
		for( $i = 0; $i -lt ($Index -1); $i++){
			$NonExtensionFileName += $FileName[$i]
			$NonExtensionFileName += "."
		}

		# 拡張子付る
		$EncriptoFileName = $NonExtensionFileName + $C_Extension

		# 出力ファイル名にする
		$Outfile = Join-Path $Parent $EncriptoFileName
	}

	try{
		# ファイルに出力する
		[System.IO.File]::WriteAllBytes($Outfile ,$SignaturedEncriptoDataByte)
	}
	catch{
		Write-Output "Encrypto fail !! ： $Outfile"
		exit
	}

	Write-Output "Encrypto $Outfile"
}

#####################################################################
# 復号化処理
#####################################################################
function Decrypto( [string[]]$PublicKeys, $Path, $Outfile ){

	# キーコンテナ確認
	if( $C_IsWindows ){
		$Status = RSAKeyContainerTest
		if( -not $Status ){
			Write-Output "Key Container not found."
			exit
		}
	}

	# 必須チェック
	if( $Path -eq [string]$null ){
		Write-Output "-Path not set."
		exit
	}

	# バージョン番号をバイト配列にする
	$VertionNameByte = String2Byte $C_Vertion

	if($PublicKeys.Count -ne 0 ){
		# 公開鍵の存在確認
		$PublicKey = $PublicKeys[0]
		$PublicKey = ExistTestPublicKey $PublicKey
		if( $null -eq $PublicKey ){
			Write-Output "Fail !! $PublicKey not found."
			exit
		}

		# 公開鍵を読む
		$PublicKeyXML = Get-Content $PublicKey -Encoding UTF8
	}

	# 対象ファイル存在確認
	if( -not (Test-Path $Path )){
		Write-Output "Fail !! $Path not found."
		exit
	}

	# 署名済み暗号文を読む
    $Path = Convert-Path $Path
	$SignaturedEncriptoDataBytes = [System.IO.File]::ReadAllBytes($Path)

	### データーを署名と署名以外/各パートに分解
	# 署名
	$SignatureByte = GetByteDate $SignaturedEncriptoDataBytes 0 $C_SignatureLength
	$IndexPoint = $C_SignatureLength

	# バージョン
	$VertionLength = $VertionNameByte.Length
	$VertionByte = GetByteDate $SignaturedEncriptoDataBytes $IndexPoint $VertionLength
	$VertionByteString = Byte2String $VertionByte

	# バージョンチェック
	$VertionNum = $VertionByteString -as [int]
	if( $VertionNum -ge 2 ){
		# Ver. 2 以降
		$IndexPoint += $VertionLength
	}
	elseif( $VertionNum -eq 1 ){
		# Ver.1 互換
		# 署名済み暗号文を読む
		$SignaturedEncriptoDataBase64 = Get-Content $Path -Encoding UTF8
		# 署名済み暗号文をバイト配列にする
		$SignaturedEncriptoDataBytes = Base642Byte $SignaturedEncriptoDataBase64
		# 署名
		$SignatureByte = GetByteDate $SignaturedEncriptoDataBytes 0 $C_SignatureLength
		$IndexPoint = $C_SignatureLength
	}
	else{
		# PSCript の暗号データではない
		Write-Output "This file is not PSCript Data.: $Path"
		exit
	}

	# ファイル名長を格納している Index
	$OriginalFileNameLengthByte = GetByteDate $SignaturedEncriptoDataBytes $IndexPoint 1
	$IndexPoint += 1
	$FileNameLength = $OriginalFileNameLengthByte[0]

	# ファイル名
	$OriginalFileNameByte = GetByteDate $SignaturedEncriptoDataBytes $IndexPoint $FileNameLength
	$IndexPoint += $FileNameLength

	# セッション鍵の数
	$PublicKeyNumberByte = GetByteDate $SignaturedEncriptoDataBytes $IndexPoint 1
	$IndexPoint += 1
	$PublicKeyNumber = $PublicKeyNumberByte[0]

	# 暗号化されたセッション鍵
	$EncryptoSessionKeysLength = $C_EncryptoSessionKeyLength * $PublicKeyNumber
	$EncryptoSessionKeysByte = GetByteDate $SignaturedEncriptoDataBytes $IndexPoint $EncryptoSessionKeysLength
	$IndexPoint += $EncryptoSessionKeysLength

	# 暗号文
	$EncryptoFileDataByte = GetByteDate $SignaturedEncriptoDataBytes $IndexPoint $null

	# 署名されたブロック
	$IndexPoint = $C_SignatureLength
	$SignatureBlockByte = GetByteDate $SignaturedEncriptoDataBytes $IndexPoint $null

	# 公開鍵で署名確認
	if( $null -ne $PublicKeyXML ){
		$Result = RSAVerifySignature $PublicKeyXML $SignatureByte $SignatureBlockByte
		if( $Result -ne $True ){
			Write-Output "Signature fail !!"
			exit
		}
		else{
			Write-Output "Signature OK"
		}
	}

	# 秘密鍵を取得
	if( -not $C_IsWindows ){
		# 秘密鍵の取得
		$PrivateKey = GetPrivateKey
	}

	# セッション鍵を秘密鍵で復号
	$i = 0
	while($true){
		# セッション鍵を分解
		$IndexPoint = $C_EncryptoSessionKeyLength * $i
		$EncryptoSessionKeyByte = GetByteDate $EncryptoSessionKeysByte $IndexPoint $C_EncryptoSessionKeyLength

		if( $C_IsWindows ){
			$SessionKeyByte = RSADecryptoCSP $C_ContainerName $EncryptoSessionKeyByte
		}
		else{
			$SessionKeyByte = RSADecryptoPrivateKey $PrivateKey $EncryptoSessionKeyByte
		}

		# 復号出来たら抜ける
		if( $null -ne $SessionKeyByte ){
			break
		}

		$i++

		# 復号できなかった
		if( $i -ge $PublicKeyNumber){
			Write-Output "Session Key decrypto fail"
			exit
		}
	}

	# 暗号文をセッション鍵で復号
	$PlainFileDataByte = AESDecrypto $SessionKeyByte $EncryptoFileDataByte
	if( $null -eq $PlainFileDataByte ){
		Write-Output "Decrypto fail"
		exit
	}

	# ファイル名指定がなかったらオリジナルのファイル名を使う
	if( $Outfile -eq [string]$null ){
		# ファイル名を文字列にする
		$FileName =Byte2String $OriginalFileNameByte

		# 入力ファイルのパスと同じ場所に出力
		$Parent = Split-Path $path -Parent

		# パス組み立て
		$OutFile = Join-Path $Parent $FileName
	}

	# 平文ファイル出力
	try{
		[System.IO.File]::WriteAllBytes($Outfile, $PlainFileDataByte)
	}
	catch{
		Write-Output "Decrypto fail !! ： $Outfile"
		exit
	}

	Write-Output "Decrypto $Outfile"
}

#####################################################################
# 鍵ペア作成処理
#####################################################################
function CreateKeyPeers($Outfile){

	Add-Type -AssemblyName System.Security

	# ログインユーザー名
	$MyName = $C_UserName

	# 鍵ペア生成(Windows)
	if( $C_IsWindows ){
		$PublicKey = RSACreateKeyCSP $C_ContainerName
	}
	# 鍵ペア生成(Windows 以外)
	else{
		$RSA = New-Object System.Security.Cryptography.RSACryptoServiceProvider
		$PublicKey = $RSA.ToXmlString($false)
		$PrivateKey = $RSA.ToXmlString($true)
		$RSA.Dispose()

		# 出力フォルダがなければ作成
		if( -not (Test-Path $C_PrivateKeyLocation)){
			mkdir $C_PrivateKeyLocation
		}

		# 出力ファイル名
		$PrivateKeyFile = $C_PrivateKeyFullPath

		# パスワード設定
		$PasswordHashByte = InputPassword "Input Private Key Password"

		# 秘密鍵ををバイト列にする
		$PlainPrivateKeyByte = String2Byte $PrivateKey

		# 秘密鍵をを AES 256 で暗号化する
		$EncryptoPrivateKeyByte = AESEncrypto $PasswordHashByte $PlainPrivateKeyByte

		# Base64 にする
		$EncryptoPrivateKeyBase64 = Byte2Base64 $EncryptoPrivateKeyByte

		# 出力フォルダがなければ作成
		if( -not (Test-Path $C_PrivateKeyLocation)){
			mkdir $C_PrivateKeyLocation
		}
		elseif(Test-Path $PrivateKeyFile){
			# すでに秘密鍵があるので、上書き確認
			$Status = Read-Host -Prompt "Do you want to overwrite the private key ? [Y/N]"
			if( $Status -ne "Y" ){
				Write-Output "Create key canceled."
				exit
			}
		}

		# 秘密鍵出力
		Set-Content -Path $PrivateKeyFile -Value $EncryptoPrivateKeyBase64 -Encoding UTF8

		Write-Output "Private key : $PrivateKeyFile"
	}

	# 出力ファイル名が未指定の場合はデフォルトの出力ファイル名にする
	if( $Outfile -eq [string]$null ){
		# 出力フォルダがなければ作成
		if( -not (Test-Path $C_PulicKeyLocation)){
			mkdir $C_PulicKeyLocation
		}

		# 出力ファイル名
		$Outfile = $C_PublicKeyFullPath
	}

	# 公開鍵出力
	Set-Content -Path $Outfile -Value $PublicKey -Encoding UTF8

	Write-Output "Public key: $Outfile"

	if( $C_IsWindows ){
		# エクスプローラーで開く
		Invoke-Item (Split-Path $Outfile -Parent)
	}
}


#####################################################################
# Export ファイル名とディレクトリ名
#####################################################################
function ExportPathAndFileName($ExportDirectory){
	# エクスポート先のディレクトリとファイル名作成
	$Leaf = Split-Path -Leaf $ExportDirectory
	$Parent = Split-Path -Parent $ExportDirectory

	[array]$PartOfExt = $Leaf.Split(".")
	if( $PartOfExt.Count -eq 1 ){
		# ノーマル処理
		$ExportFullFileName = Join-Path $ExportDirectory $C_ExportFileName
	}
	else{
		# ファイル名が指定されているので、上位パスをエクスポート先ディレクトリにする
		$ExportDirectory = $Parent
		$ExportFullFileName = Join-Path $ExportDirectory $C_ExportFileName
	}

	return $ExportDirectory, $ExportFullFileName
}

#####################################################################
# パスワード入力 & SHA 256 ハッシュ化
#####################################################################
function InputPassword($Prompt){
	# パスワード入力
	$PasswordSecureString = Read-Host -Prompt $Prompt -AsSecureString
	$PlainPasswordString = SecureString2PlainString $PasswordSecureString

	# パスワード再入力
	$ConfirmPasswordSecureString = Read-Host -Prompt "Confirm Password" -AsSecureString
	$PlainConfirmPasswordString = SecureString2PlainString $ConfirmPasswordSecureString

	if( $PlainPasswordString -ne $PlainConfirmPasswordString ){
		Write-Output "Unmatch !!"
		exit
	}

	# パスワードをバイト列にする
	$PlainPasswordByte = String2Byte $PlainPasswordString

	# パスワードの SHA 256 ハッシュ値を求める
	$PasswordHashByte = GetSHA256Hash $PlainPasswordByte

	Return $PasswordHashByte
}

#####################################################################
# Export処理
#####################################################################
function Export($ExportDirectory){

	# キーコンテナ確認
	if( $C_IsWindows ){
		$Status = RSAKeyContainerTest
		if( -not $Status ){
			Write-Output "Key Container not found."
			exit
		}
	}

	$Return = ExportPathAndFileName $ExportDirectory

	$ExportDirectory = $Return[0]
	$ExportFullFileName = $Return[1]

	$PasswordHashByte = InputPassword "Input Password"

	# キーコンテナを Export する
	$PlainExportByte = RSAExportCSP $C_ContainerName

	# エクスポートデーターを AES 256 で暗号化する
	$EncryptoExportByte = AESEncrypto $PasswordHashByte $PlainExportByte

	# Base64 にする
	$EncryptoExportBase64 = Byte2Base64 $EncryptoExportByte

	# エクスポートフォルダがなければ作成
	if( -not (Test-Path $ExportDirectory)){
		mkdir $ExportDirectory
	}
	elseif(Test-Path $ExportFullFileName){
		# すでにエクスポートがあるので、上書き確認
		$Status = Read-Host -Prompt "Do you want to overwrite the export private key ? [Y/N]"
		if( $Status -ne "Y" ){
			Write-Output "Export canceled."
			exit
		}
	}

	# エクスポート出力
	Set-Content -Path $ExportFullFileName -Value $EncryptoExportBase64 -Encoding UTF8

	Write-Output "Export File: $ExportFullFileName"

	# エクスプローラーで開く
	Invoke-Item $ExportDirectory

}

#####################################################################
# パスワード暗号化されたデータを復号する
#####################################################################
function DecryptoPasswordData($Prompt, $EncryptoDataBytes){

	# パスワード入力
	$PasswordSecureString = Read-Host -Prompt $Prompt -AsSecureString
	$PlainPasswordString = SecureString2PlainString $PasswordSecureString

	# パスワードをバイト列にする
	$PlainPasswordByte = String2Byte $PlainPasswordString

	# パスワードの SHA 256 ハッシュ値を求める
	$PasswordHashByte = GetSHA256Hash $PlainPasswordByte

	# データーを AES 256 で復号化する
	$PlainDatatByte = AESDecrypto $PasswordHashByte $EncryptoDataBytes
	if( $null -eq $PlainDatatByte ){
		Write-Output "Password unmatch"
		exit
	}

	Return $PlainDatatByte
}


#####################################################################
# Export データー復号化
#####################################################################
function DecryptoExportData($ExportDirectory){

	$Return = ExportPathAndFileName $ExportDirectory

	$ExportDirectory = $Return[0]
	$ExportFullFileName = $Return[1]

	# エクスポートファイル存在確認
	if( -not (Test-Path $ExportFullFileName)){
		Write-Output "Fail !! $ExportFullFileName not found."
		exit
	}

	# Export ファイルを読む
	$EncryptoExportBase64 = Get-Content $ExportFullFileName -Encoding UTF8

	# バイト配列にする
	$EncryptoExportBytes = Base642Byte $EncryptoExportBase64

	# パスワードで復号する
	$PlainExportByte = DecryptoPasswordData "Input Password" $EncryptoExportBytes

	return $PlainExportByte
}

#####################################################################
# Import処理
#####################################################################
function Import($PlainExportByte){

	# キーコンテナを削除する
	RSARemoveCSP $C_ContainerName

	# キーコンテナを Import する
	RSAImportCSP $C_ContainerName $PlainExportByte
}


#####################################################################
# Main
#####################################################################

if( $Debug ){
	$C_IsWindows = $False
}

# PS バージョンチェック
$PSVertion = $PSVersionTable.PSVersion.Major
if( $PSVertion -lt 5 ){
	Write-Output "Not support Windows PowerShell Less than 5."
	exit
}
elseif($PSVertion -eq 6){
	Write-Output "Not support PowerShell Core 6."
	exit
}

# 旧バージョン互換性維持
if( Test-Path $C_Old_PulicKeyLocation ){
	Rename-Item $C_Old_PulicKeyLocation $C_PulicKeyLocation
}

# 省略オプションの補完
if( $Mode -eq $null ){
	if( $Path -ne [string]$null ){
		#ファイル名
		$Leaf = Split-Path $Path -Leaf

		# ファイル名を分解
		$FileName = $Leaf.Split(".")

		# 拡張子
		$ExtensionName = $FileName[$FileName.Count -1]

		if( $ExtensionName -eq $C_Extension ){
			# 拡張子が暗号ファイル名だったら復号
			$Mode = $C_Mode_Decrypto
		}
		else{
			# それ以外は暗号
			$Mode = $C_Mode_Encrypto
		}
	}
}

Switch($Mode){
	# 復号化
	$C_Mode_Decrypto {
		Decrypto $PublicKeys $Path $Outfile
	}

	# 暗号化
	$C_Mode_Encrypto {
		Encrypto $PublicKeys $Path $Outfile
	}

	# 鍵作成
	$C_Mode_CreateKey {
		CreateKeyPeers $Outfile
	}

	# 鍵削除
	$C_Mode_RemoveKey {
		if( $C_IsWindows ){
			$Status = Read-Host -Prompt "Do you want to remove the private key ? [Y/N]"
			if( $Status -eq "Y" ){
				RSARemoveCSP $C_ContainerName
				Write-Output "Remove complete"
			}
			else{
				Write-Output "Not removed"
			}
		}
		else{
			Write-Output "Remove Key is Windows option."
		}
	}

	# Export
	$C_Mode_Export {
		if( $C_IsWindows ){
			if( $Outfile -eq [string]$null ){
				# 無指定の場合は Default エクスポート先を使用
				$Outfile = $C_ExportDirectory
			}
			Export $Outfile
		}
		else{
			Write-Output "Export is Windows option."
		}
	}

	# Import
	$C_Mode_Import {
		if( $C_IsWindows ){
			if( $Path -eq [string]$null ){
				# 無指定の場合は Default エクスポート先を使用
				$Path = $C_ExportFullFileName

				# Default エクスポート先に無いので、スクリプトディレクトリを使用
				if( -not (Test-Path $Path)){
					$Path = Join-Path $PSScriptRoot $C_ExportFileName
				}

				# それでも無かった
				if( -not (Test-Path $Path)){
					Write-Output "Export file not found."
					exit
				}
			}
			$PlainExportByte = DecryptoExportData $Path
			Import $PlainExportByte
			if( -not (Test-Path $C_PulicKeyLocation)){
				mkdir $C_PulicKeyLocation
			}
			Write-Output "Import complete"
		}
		else{
			Write-Output "Import is Windows option."
		}
	}

	# Test
	$C_Mode_Test {
		if( $C_IsWindows ){
			if( $Path -eq [string]$null ){
				# 無指定の場合は Default エクスポート先を使用
				$Path = $C_ExportFullFileName
			}
			$PlainExportByte = DecryptoExportData $Path
			Write-Output "Test OK"
		}
		else{
			Write-Output "Test is Windows option."
		}
	}

	# Test Private Key
	$C_Mode_PrivateKeyTest {
		if( $C_IsWindows ){
			Write-Output "Test Private Key is not Windows Option."
		}
		else{
			$PrivateKey = GetPrivateKey
			Write-Output "Test OK"
		}
	}

	Default {
		if( $Path -eq [String]$null ){
			Get-Help $C_ScriptFullFileName -Full
		}
		else{
			$FileName = Split-Path $Path -Leaf
			$Parts = $FileName.Split(".")
			$Ext = $Parts[$Parts.Count -1]

			# 復号化
			if( $Ext -eq $C_Extension ){
				Decrypto $PublicKeys $Path $Outfile
			}
			# 暗号化
			else{
				Encrypto $PublicKeys $Path $Outfile
			}
		}
	}
}
