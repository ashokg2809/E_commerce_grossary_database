-- TO CREATE DATABASE E_COMMERCE_Database
create database E_Commerce_Database;
-- TO USE DATABASE E_COMMERCE
use E_Commerce_Database;

-- TO CREATE TABLE CUSTOMERS
create table customers(
customer_id int primary key,
first_name varchar(20) not null,
last_name varchar(30),
age int,
city varchar(100)
);
-- TO CREATE TABLE INVENTORY
create table inventory(
item_code int primary key,
item_name varchar(100) not null,
quantity int,
expiry_date date
);
-- TO CREATE DELIVERY PARTNER TABLE
create table delivery_partner(
employee_id int primary key,
employee_name varchar(100) not null,
no_of_rides int default 0,
salary int
);
-- TO CREATE TABLE ORDERS 
create table orders(
order_id int primary key,
item varchar(100) not null,
amount int,
customer_id int,
product_code int,
-- TO CREATE foreign key COLUMN IN THE ORDERS TABLE
constraint fk_cust_id foreign key (customer_id) references customers(customer_id),
constraint fk_product_code foreign key (product_code) references inventory(item_code)
);
-- TO CREATE TABLE DELIVERY
create table delivery(
delivery_id int primary key,
delivery_partner_id int,
status varchar(25)  default 'pending',
order_id int,
payment_mode varchar(50),
-- TO CREATE A foreign key IN THE DELIVERY TABLE
constraint fk_order_id foreign key (order_id) references orders(order_id),
constraint fk_delivery_partner_id foreign key (delivery_partner_id) references delivery_partner(employee_id)
);
select*from customers;
select*from inventory;
select*from delivery_partner;
select*from orders;
select*from delivery;
-- TO INSERT VALUES INTO CUSTOMERS TABLE
insert into customers values(1,'Arun','kumar',34,'chennai'),
                            (2,'Aakash','kumar',33,'madurai'),
                            (3,'Albert','william',25,'chennai'),
                            (4,'Mohamed','afzal',31,'salem'),
                            (5,'Palani','vel',33,'madurai'),
                            (6,'Harish','kumar',31,'chennai'),
                            (7,'vicky','sankar',39,'salem'),
                            (8,'Nagamani','karthi',34,'madurai'),
                            (9,'Nikhil','amudhu',39,'madurai'),
                            (10,'Sri','dharan',28,'trichy'),
                            (11,'Aswin','rathish',27,'salem'),
                            (12,'Ram','kumar',25,'coimbatore'),
                            (13,'Krishna','raj',26,'trichy');
-- TO INSERT VALUES INTO INVENTORY TABLE
insert into inventory values(202,'urad_dal',20,'2025-07-23'),
                            (203,'toor_dal',22,'2025-07-22'),
                            (204,'rajma_dal',32,'2025-06-24'),
                            (212,'moong_dal',30,'2025-09-12'),
                            (222,'peanut',45,'2025-04-16'),
                            (246,'chana_dal',18,'2025-09-30'),
                            (277,'gingelly_oil',38,'2026-02-18'),
                            (278,'ground_nut',50,'2026-04-24'),
                            (281,'refined_oil',75,'2025-12-18'),
                            (282,'coconut_oil',60,'2025-09-21'),
                            (294,'mustard_oil',28,'2025-10-25'),
                            (295,'oilve_oil',48,'2025-11-30'),
                            (323,'wheat_flour',50,'2025-11-07'),
                            (326,'rice_flour',34,'2025-04-09'),
                            (327,'maida_flour',60,'2025-12-26'),
                            (350,'ragi_flour',46,'2025-08-08'),
                            (352,'puttu_flour',33,'2025-05-28'),
                            (359,'multigrain',20,'2025-05-20'),
                            (371,'fruit_jam',30,'2025-04-20'),
                            (372,'tomato_sauce',50,'2025-09-24'),
                            (378,'peanut_butter',10,'2025-07-04'),
                            (381,'almonds',8,'2025-05-28');
-- TO INSERT VALUES INTO DELIVERY PARTNER TABLE
insert into delivery_partner values(1,'raja',2,40),
                                   (2,'devan',2,40),
                                   (3,'ravi',0,0),
                                   (4,'vicky',1,20),
                                   (5,'mani',3,60),
						           (6,'prem',0,0),
                                   (7,'hari',0,0);
-- TO INSERT VALUES INTO ORDERS TABLE
insert into orders values(1,'urad_dal',160,5,202),
                         (2,'wheat_flour',80,11,323),
                         (3,'urad_dal',160,9,202),
                         (4,'fruit_jam',100,13,371),
                         (5,'chana_dal',170,10,246),
                         (6,'gingelly_oil',380,4,277),
                         (7,'almonds',600,8,381),
                         (8,'moong_dal',130,1,212),
                         (9,'urad_dal',160,3,202),
                         (10,'gingelly_oil',380,7,277),
                         (11,'moong_dal',130,6,212);
-- TO INSERT VALUES INTO DELIVERY TABLE
insert into delivery values(1,4,'delivered',4,'upi'),
						   (2,5,'delivered',6,'cod'),
                           (3,2,'pending',7,'upi'),
                           (4,5,'pending',10,'cod'),
                           (5,3,'delivered',1,'upi'),
                           (6,1,'pending',11,'upi'),
                           (7,1,'delivered',9,'upi'),
                           (8,5,'delivered',2,'upi'),
                           (9,1,'delivered',8,'cod'),
                           (10,2,'delivered',3,'upi'),
                           (11,4,'delivered',5,'cod');
select*from customers;
select*from inventory;
select*from delivery_partner;
select*from orders;
select*from delivery;

-- TO VIEW THE DETAILS OF ORDERED CUSTOMERS
create view ordered_customers as
select customers.first_name,city,amount from customers join orders on orders.customer_id = customers.customer_id;
select*from ordered_customers;

-- TO get second highest amount in orders
delimiter //
create procedure second_high_amount()
begin
select item,amount from orders where amount<(select max(amount)from orders) order by amount desc limit 1;

select distinct(amount),item from orders order by amount desc limit 1 offset 1 ;
end //
delimiter ;
call second_high_amount();

-- TO GET THE TOTAL AMOUNT ORDERED BY EACH CUSTOMERS
delimiter //
create procedure customer_total_sales()
begin
select distinct customer_id,item,amount,
sum(amount)over (partition by customer_id order by amount) as 'total_amount'
from orders;
end //
delimiter ;

call customer_total_sales();


-- TO FIND THE TOTAL SALES AMOUNT OF EACH ITEMS WHICH IS ORDERED
delimiter //
create procedure item_total_sales()
begin
select customer_id,item,amount,
sum(amount) over (partition by item order by item) as 'item_total_sales'
from orders;
end //
delimiter ;

call item_total_sales();

-- FIND THE CUSTOMER DETAILS TO GIVE OFFERS TO THE CUSTOMER WHOSE ORDER AMOUNT IS MORE THAN 200
delimiter //
create procedure cust_amount_200()
begin
select customer_id from orders where amount>200;
end //
delimiter ;

call cust_amount_200();


-- TO CHECK THE DELIVERY STATUS
create view delivery_status as
select customers.customer_id,customers.first_name,customers.city,delivery.status
from delivery 
inner join orders on orders.order_id=delivery.order_id 
inner join customers on customers.customer_id=orders.customer_id order by customer_id;
select*from delivery_status;


-- TO GET CUSTOMER DETAILS FROM EACH CITY
delimiter //
create procedure name_city(in a varchar(50))
begin
select *from customers
where city=a;
end //
delimiter ;
call name_city('madurai');

-- TO FIND THE PAYMENT MODE IN EACH DELIVERY
delimiter //
create procedure payment_mode_status(in input1 int ,out payment_mode_output varchar(90))
begin

select payment_mode into payment_mode_output from delivery 
where order_id= input1;

end //
delimiter ;
call payment_mode_status(5,@payment_mode_detail);
select @payment_mode_detail;

-- TO FIND THE PAYMENT MODE WHICH IS PAID BY CASH WHILE DELIVERY 
create view cod_payment as
select order_id,payment_mode from delivery 
where payment_mode='cod';
select*from cod_payment;


-- TO INSERT VALUES IN THE ORDERS TABLE
delimiter //
create procedure order_table_values(in order_id int,in item varchar(90),in amount int,in customer_id int,product_code int)
begin
insert into orders values(order_id,item,amount,customer_id,product_code);
end //
delimiter ;
call order_table_values(12,'wheat_flour',80,4,323);
call order_table_values(13,'ragi_flour',75,7,350);

-- TO SEE THE CUSTOMERS AND ORDERS DETAILS
delimiter //
create procedure customers_orders()
begin
select*from customers;
select*from orders;
end //
delimiter ;
call customers_orders();

-- TO FIND THE TOTAL SALES AMOUNT OF EACH PRODUCT
delimiter //
create procedure item_sales(in a varchar(90), out sales_amount int)
begin
select sum(amount) as 'item_total_sales' from orders
where item=a;
end //
delimiter ;
call item_sales( 'gingelly_oil',@item_toal_sales);


-- FIND THE NUMBER OF CUSTOMERS IN EACH CITY
delimiter //
create procedure city_count(in a varchar(90),out cust_city_count int)
begin
select city,count(city)  as 'customers_city_count' from customers 
where city=a group by city;
end //
delimiter ;
call city_count('madurai',@cust_city_count);

-- FIND THE NUMBER OF ORDERS BY CUSTOMERS IN EACH CITY
 delimiter //
 create procedure city_orders(in a varchar(90),out city_total_order int)
 begin
 select city,count(order_id) as 'city_total_order' from orders inner
 join customers on customers.customer_id=orders.customer_id where city=a group by city ;
 end //
 delimiter ;
 call city_orders('salem',@no_of_orders);