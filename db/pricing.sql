--select price, dt, '2014/05/11' as datedatedate from prices where product_id = 1 and store_id = 1 and dt <= '2014/05/11' order by dt desc limit 1
drop table resp;
create table resp (product_id int, store_id int, price numeric(5,2), begin_dt timestamp, end_dt timestamp, shop_dt timestamp);
DO $$
	declare product_id1 int;
	declare shop_dt timestamp = '2014/05/14';
begin
	delete from resp;
	insert into resp (product_id, store_id, price, begin_dt, end_dt, shop_dt)
	select P.product_id, P.store_id, P.price, P.begin_dt, P.end_dt, shop_dt as datedatedate 
	from prices P  
	where P.product_id in (select product_id from products) 
		and store_id = 1 and shop_dt >= begin_dt and shop_dt < end_dt;
end
$$;
select * from resp order by product_id;


select * from prices;
select * from products;
drop table prices;
delete from prices;
create table prices (product_id int, store_id int, price numeric(5,2), begin_dt timestamp, end_dt timestamp);
create table products (product_id int);
delete from products;
insert into products values (1);
insert into products values (2);
insert into products values (3);

insert into prices values (1, 1, 1.00, '1970/01/01', '2014/05/13');
insert into prices values (2, 1, 2.11, '1970/01/01', '2014/05/13');
insert into prices values (3, 1, 3.05, '1970/01/01', '2014/05/13');

insert into prices values (1, 1, 1.02, '2014/05/13', '2014/05/18');
insert into prices values (2, 1, 2.21, '2014/05/13', '2014/05/19');
insert into prices values (3, 1, 3.07, '2014/05/13', '2014/05/20');

insert into prices values (1, 1, 1.04, '2014/05/18', '2014/06/18');
insert into prices values (2, 1, 2.27, '2014/05/19', '2014/06/18');
insert into prices values (3, 1, 3.12, '2014/05/20', '2014/06/18');

insert into prices values (1, 1, 1.05, '2014/06/18', '2014/07/05');
insert into prices values (2, 1, 2.28, '2014/06/18', '9999/12/31');
insert into prices values (3, 1, 3.13, '2014/06/18', '9999/12/31');

insert into prices values (1, 1, 1.06, '2014/07/05', '9999/12/31');

