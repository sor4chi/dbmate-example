# 開発の流れ

1. `dbmate new create_users_table` でマイグレーションファイルを作成
   1. `db/migrations/[timestamp]_create_users_table.sql` が作成される
2. `db/migrations/[timestamp]_create_users_table.sql` にSQLを記述
   1. `-- migrate:up` にはマイグレーション作成のSQLを記述
   2. ｀-- migrate:down` にはRollback用のSQLを記述
