DO $$
declare
  res jsonb;
  found int;
begin

set client_min_messages=NOTICE;
raise notice '******************** Using starts_with ********************';

raise notice 'Looking up customers by id returns';
select count(1) into found from dox.starts_with(
  collection => 'customers', 
  key => 'name',
  term => 'c'
);

raise notice '... and creates a column';
select count(1) into found from information_schema.columns
where table_name='customers' and table_schema='public' and column_name='lookup_name';

assert found = 1, 'No column added';

raise notice 'updates will reset the lookup';
update customers set body = '{"name": "rob", "email:":"chuck@test.com", "company":"red4"}'
where id = 1 returning body into res;

assert res ->> 'name' = 'rob', 'Nope, update didnt work';


end;
$$ language plpgsql;