# Install

## macOS

```sh
brew install dbmate
```

## Linux

```sh
sudo curl -fsSL -o /usr/local/bin/dbmate https://github.com/amacneil/dbmate/releases/latest/download/dbmate-linux-amd64
sudo chmod +x /usr/local/bin/dbmate
```

## Windows

```sh
scoop install dbmate
```

## Docker

Dockerは.env上での他ENVの埋め込みができないため、DATABASE_URLを直接文字列で指定する必要があります。

```sh
 docker run --rm -it --network=host ghcr.io/amacneil/dbmate:1 [この後にdbmateのサブコマンドでそのまま実行できます]
```

# 開発の流れ

## 手順1、まずマイグレーション書いてみよう

1. `docker-compose up -d` でコンテナを起動
2. `dbmate new create_users_table` でマイグレーションファイルを作成
   1. `db/migrations/[timestamp]_create_users_table.sql` が作成される
3. `db/migrations/[timestamp]_create_users_table.sql` にSQLを記述
   1. `-- migrate:up` にはマイグレーション作成のSQLを記述
   2. `-- migrate:down` にはRollback用のSQLを記述
4. `sh check.sh` でテーブルが空であることを確認
   1. 実行時にpasswordを聞かれるので、`test` と入力（MYSQL_PASSWORD）
   2. この時点ではテーブルが存在しないので、`ERROR 1146 (42S02) at line 1: Table 'test.users' doesn't exist` と表示される
5. `dbmate up` でマイグレーションを実行
   1. `db/migrations/[timestamp]_create_users_table.sql` の`-- migrate:up` に記述したSQLが実行される
   2. `sh check.sh` でテーブルが空であることを確認
      1. 実行時にpasswordを聞かれるので、`test` と入力（MYSQL_PASSWORD）
      2. この時点ではテーブルが存在するので、`Create Table: CREATE TABLE ...` と表示され、さっき作ったテーブルが作成されていることが確認できる
6. `dbmate rollback` でマイグレーションをロールバック
   1. `db/migrations/[timestamp]_create_users_table.sql` の`-- migrate:down` に記述したSQLが実行される
   2. `sh check.sh` でテーブルが空であることを確認
      1. 実行時にpasswordを聞かれるので、`test` と入力（MYSQL_PASSWORD）
      2. この時点ではテーブルが存在しないので、`ERROR 1146 (42S02) at line 1: Table 'test.users' doesn't exist` と表示される

## 手順2、マイグレーションを実務的に使ってみよう

### 手順2-1、テーブルをさらに追加し、状態監視に慣れよう

1. `dbmate up` でマイグレーションを実行(テストで一度rollbackしてしまったので再度migrationをする)
2. `dbmate new create_family_table` でマイグレーションファイルを作成
   1. `db/migrations/[timestamp]_create_family.sql` が作成される
3. `db/migrations/[timestamp]_create_family.sql` にSQLを記述
   1. `-- migrate:up` にはマイグレーション作成のSQLを記述
   2. `-- migrate:down` にはRollback用のSQLを記述
4. `dbmate status` でマイグレーションの状態を確認
   1. `db/migrations/[timestamp]_create_family.sql` が`pending` と表示される（まだこのversionは実行されていないため）
5. `dbmate up` でマイグレーションを実行
   1. `db/migrations/[timestamp]_create_family.sql` の`-- migrate:up` に記述したSQLが実行される
   2. `dbmate status` でマイグレーションの状態を確認
      1. `db/migrations/[timestamp]_create_family.sql` が`migrated` と表示される（このversionは実行されたため）
   3. `sh check_2.sh` でテーブルが空であることを確認
      1. 実行時にpasswordを聞かれるので、`test` と入力（MYSQL_PASSWORD）
      2. familyテーブルが作成されていることが確認できる

### 手順2-2、既存のテーブルを変更してみよう

1. `dbmate new relation_family_and_user` でマイグレーションファイルを作成
   1. 現在のusersテーブルはfamilyテーブルとの関連がないため、familyテーブルとの関連を追加する
   2. 今回は`1`familyに`n`userが属する関係を想定する
2. `db/migrations/[timestamp]_relation_family_and_user.sql` にSQLを記述
   1. `-- migrate:up` にはマイグレーション作成のSQLを記述
   2. `-- migrate:down` にはRollback用のSQLを記述
3. `dbmate status` でマイグレーションの状態を確認
   1. `db/migrations/[timestamp]_relation_family_and_user.sql` が`pending` と表示される（まだこのversionは実行されていないため）
4. `dbmate up` でマイグレーションを実行
   1. `db/migrations/[timestamp]_relation_family_and_user.sql` の`-- migrate:up` に記述したSQLが実行される
   2. `dbmate status` でマイグレーションの状態を確認
      1. `db/migrations/[timestamp]_relation_family_and_user.sql` が`migrated` と表示される（このversionは実行されたため）
   3. `sh check.sh` でテーブルが空であることを確認
      1. 実行時にpasswordを聞かれるので、`test` と入力（MYSQL_PASSWORD）
      2. `users`テーブルに`family_id`カラムが追加され、さらに`family.id`へのFKが追加されていることが確認できる
5. `dbmate rollback` でマイグレーションをロールバック
   1. `sh check.sh` でちゃんとFKや`family_id`カラムが削除されていることを確認
