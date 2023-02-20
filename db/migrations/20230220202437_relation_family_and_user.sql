-- migrate:up
alter table users add column family_id integer;
alter table users add constraint fk_users_family_id foreign key (family_id) references family(id);

-- migrate:down
alter table users drop constraint fk_users_family_id;
alter table users drop column family_id;
