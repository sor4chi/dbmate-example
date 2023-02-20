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
