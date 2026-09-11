---
name: fdev
description: "freee の開発環境向け CLI ツール fdev の使い方ガイド。fdev コマンドの使い方、開発環境のセットアップ、認証、API リクエスト、シークレット管理、データベース、EC2 管理、repocfg バリデーションなどについて質問されたときに使う。「fdev の使い方」「開発環境のセットアップ」「ローカルで API を叩きたい」「シークレットを追加したい」「EC2 を起動したい」「repocfg を検証したい」といった文脈でも積極的にトリガーすること。"
---

# fdev — freee 開発環境 CLI ツール

fdev は freee の開発環境をセットアップ・管理するための CLI ツール。認証付き API リクエスト、シークレット管理、データベースリストア、EC2 インスタンス操作などを提供する。

## 初期セットアップ

開発環境を使い始める前に以下の順序でセットアップする。

```sh
# 1. fdev の初期設定（ユーザー情報、メールアドレスなど）
fdev configure

# 2. 必要なツールのセットアップ（Mac の場合）
fdev setup ssh-key            # SSH 鍵の生成と Git 署名設定
fdev setup command-line-tools # Xcode CommandLineTools
fdev setup rosetta            # Rosetta2（ARM64 Mac のみ）
fdev setup brew               # Homebrew
fdev setup awscli             # AWS CLI
fdev setup saml2aws           # saml2aws（AWS SSO 認証）
fdev setup session-manager    # Session Manager（SSM）
fdev setup gnupg              # GnuPG（Mac のみ）
fdev setup sops               # sops（シークレット暗号化）
fdev setup gitleaks           # gitleaks + pre-commit hook
fdev setup freee-feature-flag # freee-feature-flag CLI
fdev setup inowright-cli      # inowright-cli（inoC）
```

Linux（EC2）環境では `fdev setup cron` で定期ジョブのセットアップも可能。

`fdev setup freee-feature-flag` は gh CLI を使ってリリースをダウンロードし、build provenance attestation を検証してからインストールする。デフォルトのインストール先は `~/.local/bin/freee-feature-flag`。

```sh
fdev setup freee-feature-flag --path ~/bin/freee-feature-flag # インストール先を変更する
fdev setup freee-feature-flag --force                         # インストール済みでも再インストールする
```

インストール済みの場合は何も行われない。更新は `freee-feature-flag upgrade` を使う。

`fdev setup inowright-cli` は inoC の platform 別 release archive（dist + production 依存 + Node runtime 同梱）をダウンロードし、build provenance attestation を検証してから `~/.local/share/inowright-cli/<version>` に展開し、`~/.local/bin/inowright-cli` に symlink する。

```sh
fdev setup inowright-cli                 # 最新版をインストール
fdev setup inowright-cli --version 0.3.1 # 特定 version を指定（rollback にも使う）
```

release archive は immutable なので、指定した version が既に展開済みならダウンロードはスキップして symlink だけ張り替える。ローカルの展開先が壊れている疑いがある場合は `~/.local/share/inowright-cli/<version>` を削除してから再実行する。

## 認証と API リクエスト

> **注意: `fdev request login` / `fdev request admin-login` は LLM から実行しないこと。**
> 認証情報（email、パスワード）を扱うため、ユーザーにターミナルで直接実行するよう案内すること。

ローカル開発環境の API を叩くために、まず認証を行う。

### ログイン

```sh
# 対話的にログイン（email, password を入力）
fdev request login

# ユーザーID + 事業所ID でログイン
fdev request login -c <company-id> -u <user-id>

# email + password でログイン
fdev request login --email <email> --password <password>

# actor chain を含む delegated InternalSession でログイン（ローカル開発環境専用）
# 通常ログイン後、指定した subject で machine admin login と Session Delegation Token の発行を行う
# delegated InternalSession は API リクエスト時に都度 exchange される
fdev request login --email <email> --password <password> --admin-subject <subject>

# 管理者ログイン
fdev request admin-login

# 管理者ログイン（machine admin user、subject のみ。パスワード不要。ローカル開発環境専用）
fdev request admin-login --subject <subject>

# ログアウト
fdev request logout
fdev request admin-logout
```

### セッション・トークン情報の取得

`fdev request show [key]` で、保存されているログインセッション・トークン情報を出力できる。`key` を省略すると JSON で全情報を出力し、指定するとその値のみを出力する（パイプや `$(...)` での利用を想定）。

```sh
# すべての情報を JSON で出力
fdev request show

# login session key のみ出力（_n_auth_session_id cookie として利用）
fdev request show web-session

# access token のみ出力（public API 用）
fdev request show access-token

# internal session token のみ出力（X-Omega-Internal-Session-Token として利用）
# 通常・delegated login ともに InternalSession は都度サーバーに問い合わせて発行する
fdev request show internal-session

# 利用可能な key（括弧内はエイリアス）:
#   web-session (login-session, login-session-key), access-token,
#   internal-session (internal-session-token),
#   admin-session (admin-session-key), admin-internal-session (admin-internal-session-token),
#   cid (company-id), uid (user-id), auid (admin-user-id)
```

### Internal Session Token のデコード

> **注意: このコマンドは LLM から実行しないこと。**
> Internal Session Token はクレデンシャルであり、デコード結果にも認証情報が含まれるため、ユーザー自身のターミナルで実行するよう案内すること。

`fdev request decode-token` は Internal Session Token を JSON にデコードする。署名検証は行わないため、出力を認証・認可の判断には利用しないこと。通常の Internal Session、Admin Internal Session、Session Delegation Token は header から自動判定される。トークンは標準入力で渡すことを推奨する。引数で渡すと shell history やプロセス引数を通じてクレデンシャルが露出する可能性がある。

```sh
fdev request show internal-session | fdev request decode-token
```

### API リクエスト（curl ラッパー）

`fdev curl` は URL パスとポートに応じて認証情報を自動で付与する。

| 種別 | 付与される認証情報 | 対象 |
|---|---|---|
| Internal | `X-Omega-Internal-Session-Token` | `/api/internal/` |
| Public | access token | `/api/1/` 等 |
| Private | web session + CSRF token | その他 |
| AdminWeb | admin session key（cookie）+ CSRF token | `/admin/api/`、admin service の `/api/internal/` 以外すべて、`--admin-web` フラグ |
| AdminInternal | `X-Omega-Admin-Internal-Session-Token` ヘッダー† | `/api/admin/`、admin service の `/api/internal/`、`--admin` フラグ |

admin service は `pkg/curl/request_type.go` の `adminServicePorts` で管理している。現在は central-admin(Port:3090)のみ。

```sh
# Private API — web session + CSRF token を自動付与
fdev curl -X POST -d '{"foo":"bar"}' localhost:3000/api/p/hoge

# Private API（CSRF スキップ）
fdev curl -X POST -d '{"foo":"bar"}' --csrf-skip localhost:3000/api/p/hoge

# Public API — access token を自動付与
fdev curl localhost:3000/api/1/users/me

# Internal API — internal session token を自動付与
fdev curl localhost:3000/api/internal/companies/preparation_job

# AdminWeb
fdev curl localhost:3000/admin/api/roles
fdev curl localhost:3090/api/p/admin_users/me
fdev curl --admin-web -X POST localhost:3000/some/path

# AdminInternal
fdev curl localhost:3000/api/admin/users
fdev curl localhost:3090/api/internal/some/resource
fdev curl --admin -X POST localhost:3000/some/path
```

### gRPC リクエスト

gRPC の Admin リクエストはすべて AdminInternal として扱われる（`X-Omega-Admin-Internal-Session-Token` を付与）。`x-n-admin-auth-session-id` も同時付与するが廃止予定。

```sh
# grpcurl — internal session token 付きで gRPC リクエスト
fdev grpcurl -d '{"shop_id":1}' localhost:50051 warehouse.Inventory.ListItems

# grpcurl — AdminInternal（サービス名が Admin または AdminService で終わる場合に自動判定）
#   事前に fdev request admin-login が必要
fdev grpcurl -d '{"email":"test@c-fo.com"}' localhost:50053 nest_auth.InfoAdmin.ListUsersAsAdmin
fdev grpcurl -d '{}' localhost:50051 foo.FooAdminService.ListItems

# grpcurl — --admin フラグで強制指定
fdev grpcurl --admin -d '{}' localhost:50051 foo.SomeService.SomeMethod

# evans — 対話的 gRPC クライアント（internal API）
fdev evans
fdev evans -r --port 50061

# evans — AdminInternal（--admin フラグで指定）
fdev evans --admin -r --port 50053
```

## シークレット管理

> **注意: secrets 系コマンドは LLM から実行しないこと。**
> `fdev secrets` はクレデンシャルや環境変数を扱うため、セキュリティ上の理由から LLM が直接実行すべきではない。
> ユーザーに対してコマンドをターミナルで直接実行するよう案内すること。

開発環境で必要なシークレット（API キー、認証情報など）を管理する。デフォルトで GPG + sops による暗号化が有効。

### 事前準備（暗号化を使う場合）

```sh
# PGP 鍵の生成（初回のみ）
fdev secrets gen-key
```

gpg と sops が必要。Mac では `fdev setup gnupg` と `fdev setup sops` でインストールできる。

### AWS Secrets Manager からの取得

```sh
# AWS Secrets Manager からシークレットを取得してローカルに保存
fdev secrets get aws_ses_credentials

# 取得したシークレットを環境変数にロード
eval "$(fdev secrets load aws_ses_credentials)"

# fish shell の場合
eval (fdev secrets load --format fish aws_ses_credentials)

# シークレットを環境変数にロードしてコマンドを実行（-- の後にコマンドを記述）
fdev secrets exec aws_ses_credentials -- your-command --with-args

# 複数のシークレットを同時にロード（カンマ区切り）
fdev secrets exec aws_ses_credentials,some_api_keys -- your-command --with-args
```

### ローカルシークレットの管理

```sh
# シークレットを対話的に追加（キー名と値のペアを入力）
fdev secrets add some_token

# シークレットを対話的に編集
fdev secrets edit some_token

# ローカルに保存済みのシークレット一覧
fdev secrets list

# AWS Secrets Manager 上の全シークレット一覧
fdev secrets list --all

# シークレットのキー名のみ表示（値は出力しない）
fdev secrets load --keys-only aws_ses_credentials

# ローカルのシークレットファイルを削除
fdev secrets remove some_token
```

### シークレット検出

```sh
# 環境変数・Git リポジトリ・シェル履歴からシークレットを検出
fdev secrets detect

# 環境変数のみスキャン
fdev secrets detect --type env
```

## データベース

> **注意: `fdev database restore` は LLM から実行しないこと。**
> 既存データを上書きする破壊的操作のため、ユーザーにターミナルで直接実行するよう案内すること。

```sh
# データベースコンソール（REPL）を起動
fdev database console
```

## AWS 認証・設定

> **注意: `fdev aws login` / `fdev aws configure` は LLM から実行しないこと。**
> saml2aws 経由で AWS クレデンシャルを発行する認証コマンドのため、ユーザーにターミナルで直接実行するよう案内すること。

```sh
# default / saml / dev プロファイルのデフォルトリージョンを設定（デフォルト: ap-northeast-1）
fdev aws configure

# saml2aws でログイン（デフォルトは dev プロファイル）
fdev aws login

# profile を指定してログイン
fdev aws login -p saml

# TOTP で MFA 認証
fdev aws login --totp
```

Linux 環境では `fdev aws login` 実行時、GPG/pass キーリングを事前に起動する。事前に `fdev setup saml2aws` で saml2aws が構成済みであること。

## EC2 インスタンス管理（Mac のみ）

Mac からリモートの EC2 開発環境を操作する。事前に `fdev ec2 configure` でインスタンス ID を設定する。

```sh
# インスタンス ID を設定
fdev ec2 configure

# 起動（status-ok まで待機）
fdev ec2 start

# 停止（ハイバネート対応）
fdev ec2 stop

# 再起動
fdev ec2 reboot

# インスタンスの準備完了を待機
fdev ec2 wait

# TOTP を使う場合は --totp フラグを付与
fdev ec2 start --totp
```

## GitHub PAT 管理

> **注意: `fdev pat` は LLM から実行しないこと。**
> GitHub トークンを扱うため、ユーザーにターミナルで直接実行するよう案内すること。

```sh
# PAT を保存（対話的にトークンを入力）
fdev pat save

# 保存した PAT を環境変数 GITHUB_TOKEN_FOR_GITHUB_PACKAGES に設定
eval "$(fdev pat load)"

# 保存した PAT を使う読み取り専用 proxy を常駐プロセスとして起動しておく
fdev pat rubygems-proxy

# 別の shell で Bundler から proxy 経由で GitHub Packages にアクセス
bundle config set --global mirror.https://rubygems.pkg.github.com/c-fo http://127.0.0.1:58083

# proxy を利用しなくなったら mirror 設定を削除
bundle config unset --global mirror.https://rubygems.pkg.github.com/c-fo

# proxy を起動した shell で Ctrl+C を押して停止
```

## DynamoDB ロック管理

localstack 上の DynamoDB ロックを管理する。

```sh
fdev dynamolock list              # ロック一覧
fdev dynamolock show <lock-key>   # 詳細表示
fdev dynamolock delete <lock-key> # 削除
fdev dynamolock clear             # 全削除
```

## その他

```sh
# 現在の環境情報を表示（OS、アーキテクチャ等）
fdev status

# fdev を最新版に更新
# ダウンロードした binary の GitHub build provenance attestation
# （署名 + Deploy Environment が cli-stable であること）を検証してから置き換える。
# 検証には gh CLI（認証済み）が必要。
fdev update

# バージョン表示
fdev version
```

## よくあるワークフロー

### ローカル API を叩きたい

```sh
fdev request login
fdev curl localhost:3000/api/1/users/me
```

### シークレットを使ってコマンドを実行したい

```sh
fdev secrets gen-key              # 初回のみ
fdev secrets get aws_ses_credentials
fdev secrets exec aws_ses_credentials -- rails console
```

## repocfg バリデーション

repocfg.yml が JSON Schema に準拠しているか検証する。

```sh
# カレントディレクトリ以下の repocfg.yml / repocfg.yaml を再帰的に検証
fdev repocfg validate

# ファイルを直接指定して検証（複数指定可）
fdev repocfg validate -f path/to/repocfg.yml
fdev repocfg validate -f service1/repocfg.yml -f service2/repocfg.yml
```

検証に失敗したファイルはエラー内容とともに表示され、exit code 1 で終了する。
