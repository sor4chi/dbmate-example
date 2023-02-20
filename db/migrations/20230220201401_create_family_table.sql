-- migrate:up
create table family (
  id int not null auto_increment primary key,
  name varchar(255) not null,
  created_at timestamp not null default current_timestamp,
  updated_at timestamp not null default current_timestamp on update current_timestamp
) engine=innodb;

-- migrate:down
drop table family;

