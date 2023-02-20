docker-compose exec -T db mysql -u test -p -e "USE test; SHOW CREATE TABLE users\G"
