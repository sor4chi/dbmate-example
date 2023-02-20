# 開発の流れ

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
7. `dbmate up` でマイグレーションを実行(テストで一度rollbackしてしまったので再度migrationをする)
