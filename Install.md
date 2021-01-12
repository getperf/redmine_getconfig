インストール手順
================

前提条件
--------

* RHEL 7 / CentOS 7
* Bitnami Redmine 4.0.5 を使用

**注釈**

* Redmine はソフトウエアの特性から、バージョンの違いにより 
Ruby, Rails 等のライブラリで互換性の問題が発生しやすいため、
フルスタックパッケージの Bitnami Redmine を使用します。

リファレンス

* [Bitnami Redmine Stack](https://docs.bitnami.com/installer/apps/redmine/)
* [Related Guides For Redmine](https://docs.bitnami.com/installer/apps/redmine/related-how-tos/)
* [bitnamiでCentOS7にRedmineをインストール](https://corgi-lab.com/linux/bitnami-install-redmine/)


Bitnami Redmine Stack 4.0.5 インストール
----------------------------------------

### 事前準備

OS 初期設定ではfirewallが有効になっているため、firewall を無効化します。

```
sudo systemctl stop firewalld
sudo systemctl disable firewalld
```

Bitnami Redmine Stack の必須パッケージをインストールします。

    sudo yum groupinstall "Development Tools"
    sudo yum install wget glibc-devel perl perl-Data-Dumper

### Bitnami Redmine Stackダウンロード

ダウンロードサイトから 4.0 系のBitnami Redmine Stack 最新版をダウンロードしてます。
[ChangeLog](https://bitnami.com/stack/redmine/changelog.txt)を参照し、
4.0 の最新版バージョンを確認します。確認したバージョン番号をファイル名に
指定して以下の wget コマンドでダウンロードします。

**注釈**

* 最新版の 4.1 はプラグインの互換性の問題が発生するため、1つ前の
 4.0 の最新バージョンを導入します。
* Bitnami サイトのダウンロードリンクは最新版の 4.1 のみのため、上記 ChangeLogから4.0 のバージョンを検索して、
  wget コマンドでダウンロードしてください

```
cd /tmp
wget https://downloads.bitnami.com/files/stacks/redmine/4.0.5-6/bitnami-redmine-4.0.5-6-linux-x64-installer.run
```

インストーラを起動します。

```
chmod a+x bitnami-redmine-4.0.5-6-linux-x64-installer.run
sudo ./bitnami-redmine-4.0.5-6-linux-x64-installer.run
```

Bitnami インストーラが起動され、コンソールに以下を入力します。

* Language Selection　で、[3] Japanese - 日本語　を選択
* 管理者アカウントを作成
    * 表示用氏名 ： CMDB
    * Email アドレス： 管理者のメールアドレス
    * ログイン名： psadmin
    * パスワード：アルファベットと数字のみ、8文字以上を入力
* configure mail support? を 'y' にして、メール設定
    * [2] Custom を選択
    * ユーザ名： psadmin
    * パスワード：psadmin パスワードを入力
    * ポート番号：25
    * Secure connection: [1] None を選択

コンソールに完了メッセージが表示されるまで待ちます。

### ウェブブラウザから動作確認

インストーラのコンソールメッセージに記されたURLを参考にして、
ウェブブラウザからホストのIPアドレスの80番ポートにアクセスし、ホームページを表示
します。「Access Redmine」のリンクをクリックして、Redmine の画面が表示されれば OK です。

Redmine Getconfig プラグインのインストール
------------------------------------------

Getconfig 構成管理データベース用プラグインをインストールします。
以降の作業は root で実行します。 sudo su などで root にスイッチしてください。

### 環境変数の設定

Bitnami 環境編集を読込み、 redmine, mysql, ruby パスを設定します。

```
source /opt/redmine-4.0.*/.bitnamirc
export REDMINE_HOME=$BITNAMI_ROOT/apps/redmine/htdocs
export PATH=$REDMINE_HOME/bin:$BITNAMI_ROOT/ruby/bin:$BITNAMI_ROOT/mysql/bin:$PATH
```

### プラグインのインストール

redmine/plugins にディレクトリ移動し、git clone でプラグインをダウンロードします。

```
cd $REDMINE_HOME/plugins
git clone http://github.com/getperf/redmine_getconfig
```

bundle install でプラグインをインストールします。

```
cd $REDMINE_HOME
bundle install  --no-deployment
```

### データベース設定

Redmine データベース内にプラグイン用テーブルを作成します。

```
bundle exec bin/rake redmine:plugins:migrate
```

作成したテーブルの文字コードを utf8 から utf8mb4 に変更します。

```
mysql -u root -p bitnami_redmine < docs/db_change_utf8_to_utf8mb4.sql
```

### MySQL リモートアクセス許可設定

初期設定では MySQL のリモートアクセス許可が無効になっているため、
[Connect to MySQL/MariaDB from a different machine](https://docs.bitnami.com/virtual-machine/infrastructure/mysql/administration/connect-remotely/)
の手順で設定を変更します。

MySQL 設定ファイルを開いて、bind-address パラメータをコメントアウトします。

```
vi /opt/redmine-4.1.1-6/mysql/my.cnf
(以下のbind-addressパラメータをコメントアウトします)
#bind-address=127.0.0.1
```

MySQL root ユーザのリモートアクセス許可設定を行います。

```
mysql -u root -p -e "grant all privileges on *.* to 'root'@'%' identified by '{パスワード}' with grant option";
```

設定を反映させるため、各種サービスを再起動します。

```
/opt/bitnami/ctlscript.sh restart
```

再起動後、 ウェブブラウザから Redmine にアクセスできるか確認してください。

Redmine 基本設定
----------------

Redmine 管理画面から Redmine の環境設定を行います。
ウェブブラウザから Redmine URL を開き、ログインを選択します。
ログイン画面で以下を入力してログインします。

* ログインID を admin
* パスワード を Bitnami インストーラで入力した管理者パスワード

ログイン後、パスワード更新画面が表示されるので、新規パスワードを入力して
更新します。

### 管理、設定メニューを開く

新規パスワードでのログイン後、メニュー、管理、設定を選択して各種タブから Redmine の基本設定を行います。

**注釈** 
各タブを選択して入力が完了したら、都度、保存ボタンで設定を反映してください。

### 全般設定

Redmineタイトルを変更します。

* タイトルを 「構成管理データベース」 に
* テキスト形式を 「Markdowon」 に

### 認証設定

ログインしていないユーザには情報を見せない設定をします。

* 認証が必要を 「ON」 に
* ユーザによるアカウント登録を 「無効」 に

### API設定

Getconfig ツールからのデータ登録ができる様、REST と JSONNP をチェックします。

### プロジェクト設定

* 新たに作成したプロジェクトを「公開」にしない設定をします。

* デフォルトで有効になるモジュールで以下のチェックを外します。

    * 時間管理
    * ニュース
    * リポジトリ
    * フォーラム
    * カレンダー
    * ガントチャート

* デフォルトで有効になるトラッカーをすべてチェックします。

Redmine プロジェクト設定
------------------------

続けて、構成管理用プロジェクトの初期設定を行います。
Redmine 管理者アカウントで以下を設定します。

### トラッカー設定

管理メニュー、トラッカーを選択し、既定のトラッカー名を修正します。

* バグ ... 名称を「障害対応」に
* 機能 ... 名称を「作業」に

「サマリー」ボタンをクリックし、各トラッカーの設定フィールドの
サマリを表示します。
以下の標準フィールドのチェックを外します。

* IAサーバからソフトウエアまでの全ての設備チケットトラッカーを対象とします。
* 以下のフィールドのチェックを外します。
    * 期限
    * 予定工数
    * 進捗率
    * 説明

「保存」をボタンをクリックします。

### カスタムフィールド設定

使用環境にあわせて一部の変更が必要なカスタムフィールドの設定を行います。
管理メニュー、カスタムフィールドを選択し、以下のカスタムフィールドを変更します。

* インベントリ
    * Getconfig 構成収集ツール結果の検索用画面のURLリンクの指定となり、ホスト名を入力することで、そのホスト名の検索結果のリンクを参照します。以下URLを設定します。
    * URL に、「/redmine/inventory?node=%value%」を入力
* ラック位置
    * サーバ室のラック構成を管理するツール [Racktables](https://www.racktables.org/) のリンクを指定します。
      ホスト名を入力することで、そのホスト名の Racktables リンクを参照します。
    * 正規表現に、「^RackTables:(.+)$」を入力
    * URL に以下を入力
        * http://{サーバ名}/racktables/index.php?page=search&last_page=object&last_tab=default&q=%m1%
    * **注釈** Racktables を使用しない場合は本カスタムフィールドを削除してください

### プロジェクトの作成

管理対象サイト毎にプロジェクトを作成します。
ここではテスト用に test1 プロジェクトを作成します。

メニュー、プロジェクトを選択し、「新しいプロジェクト」をクリックします。

* 名称に、「テスト用１」
* 識別子に、「test1」
* メンバーを継承をチェックして、保存をクリック
* メンバータブを選択
    * 新しいメンバーをクリックし、以下ユーザを追加
        * 管理者ユーザ
        * 非メンバー

データ登録動作確認
------------------

実際に Getconfig を用いて Redmine へのデータ登録処理を確認します。データは Getconfig デモデータを使用します。
[Getconfig](https://github.com/getperf/getconfig) がインストールされている環境を前提とし、Windows サーバでの手順を以下に記します。

### データベース接続設定ファイルの編集

構成管理データベースの接続設定ファイルを編集します。
PowerShell コンソールを開いて既存の設定ファイルをコピーして、データベース接続
設定ファイルを編集します。

```
cd C:\server-config\config
copy cmdb_sample.groovy cmdb.groovy
notepad cmdb.groovy
```

以下の MySQL 接続アカウントの接続パラーメータを編集します。

```
# MySQL 接続アカウント設定
cmdb.username = "root"                # root を指定
cmdb.password = "{MySQL パスワード}"  # MySQL リモートアクセス許可設定で設定したパスワード
# IPアドレスに MySQL サーバのIPアドレスを指定。データベース名にbitnami_redmineを指定
cmdb.url = "jdbc:mysql://{IPアドレス}:3306/bitnami_redmine?useUnicode=true&characterEncoding=utf8"       
cmdb.driver = "com.mysql.jdbc.Driver"
```

続けて Redmine API キーの接続パラメータを編集します。
ウェブブラウザで Redmine を開き、Redmine 画面右上の「個人設定」を選び、
API アクセスキーの「表示」をクリックします。表示されたキーを入力してください。

**注釈** Redmine API キーの入力は、登録を実行する Redmine アカウントの API キーを指定してください

```
# Redmine API 接続設定
redmine.url = "{Redmine URL}"   # Redmine ホームページの URLを指定
redmine.api_key = "{Redmine API キー}" # Redmine APIキー
```


### デモデータの登録

Getconfig デモデータを用いて登録処理の動作確認をします。

```
# 一時ディレクトリの下に異動し、 dbtest1 プロジェクト作成
cd $env:TEMP
getcf init dbtest1 -t  
cd dbtest1
# デモデータのインベントリ収集を実行
getcf run -d
# 収集した結果をデータベース
getcf update all -r test1 
```

Redmine画面から登録結果を確認します。

* ウェブブラウザから Redmine を開いてログインします
* メニュー、プロジェクトを選択し、テスト用に作成した test1 を選択します
* メニュー、チケットを選択し、リストから、centos80 設備チケットをを選択します
