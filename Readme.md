Getconfig構成管理データベースのためのRedmineプラグイン
=======================================================

システム概要
------------

 [Redmine](http://www.redmine.org/) に、
インベントリ収集ツール [Getconfig](https://github.com/getperf/getconfig)
の収集結果の検索ページを追加します。
以下の利用を想定しています。

* Windows PC から、Getconfig 登録コマンドで Redmine データベースにインベントリ収集結果を登録
* Redmine にインベントリ収集検索メニューを追加
* Redmine チケットのカスタムフィールドに、インベントリ収集結果の検索ページをリンク

システム要件
------------

* RHEL 7/CentOS 7
* Bitnami Redmine Stack 4.0.5 [bitnami](https://bitnami.com/stack/redmine/installer)

*注意*

最新の 4.1 では互換性の問題が発生するため、4.0系の最新をインストールしてください

Version 4.0.5-6      2019-11-29

利用方法
--------

**Redmine 検索ページでの検査結果検索**

Redmine ベースURL の下の、「/inventory/{検査対象サーバ}」 が検索ページとなります。
ホスト ostrich の検索の場合、URLは以下となります。

```
http://{Redmineサーバ}:3000/inventory/ostrich
```

**Redmine カスタムフィールドのカスタマイズ**

チケットにカスタムフィールど追加することで、
チケット画面から検査結果検索ページをリンクすることが可能です。
メニュー管理、カスタムフィールドで以下のカスタムフィールドを登録してください。

* 書式 : 「テキスト」を選択
* 名称 : 「インベントリ情報」を入力
* 値に設定するリンクURL : 「/redmine/inventory/%value%」または、「/inventory/%value%」を入力
    * Redmine のベース URL に合わせて設定してください

リファレンス
------------

* [Getconfig](https://github.com/getperf/getconfig)
* [Plugin Tutorial](http://www.redmine.org/projects/redmine/wiki/Plugin_Tutorial)

AUTHOR
------

Minoru Furusawa <minoru.furusawa@toshiba.co.jp>

COPYRIGHT
-----------

Copyright 2020-2021, Minoru Furusawa, Toshiba corporation.
