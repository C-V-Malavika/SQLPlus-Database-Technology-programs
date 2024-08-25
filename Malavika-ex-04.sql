REM PIZZA ORDERING SYSTEM
REM**********************

REM Consider the following relations for Pizza Ordering System:
REM CUSTOMER (cust_id, cust_name, address, phone) 
REM PIZZA (pizza_id,pizza_type, unit_price)
REM ORDERS (order_no, cust_id, order_date, delv_date) 
REM ORDER_LIST (order_no, pizza_id, qty)

REM b) Create tables with appropriate data types and integrity constraints in
REM	order to populate tables from the Pizza_DB.sql file.
REM -----------------------------------------------------------------------------

REM Dropping the relations
REM ----------------------

DROP TABLE customer CASCADE CONSTRAINTS;

DROP TABLE pizza CASCADE CONSTRAINTS;

DROP TABLE orders CASCADE CONSTRAINTS;

DROP TABLE order_list CASCADE CONSTRAINTS;


REM Creating the relations
REM ----------------------

REM customer(cust_id, cust_name, address, phone)

CREATE TABLE customer(
cust_id VARCHAR2(4), 
cust_name VARCHAR2(20), 
address VARCHAR2(35), 
phone NUMBER(10)
);

REM pizza (pizza_id, pizza_type, unit_price)

CREATE TABLE pizza(
pizza_id VARCHAR2(4), 
pizza_type VARCHAR2(20),  
unit_price NUMBER
);

REM orders(order_no, cust_id, order_date ,delv_date)

CREATE TABLE orders(
order_no VARCHAR2(5), 
cust_id VARCHAR2(4),  
order_date DATE,
delv_date DATE
);

REM order_list(order_no, pizza_id, qty)

CREATE TABLE order_list(
order_no VARCHAR2(5), 
pizza_id VARCHAR2(4),  
qty NUMBER
);


REM Adding the constraints
REM ----------------------

ALTER TABLE customer ADD CONSTRAINT PrKey1 PRIMARY KEY(cust_id);

ALTER TABLE pizza ADD CONSTRAINT PrKey2 PRIMARY KEY(pizza_id);

ALTER TABLE orders ADD CONSTRAINT PrKey3 PRIMARY KEY(order_no);

ALTER TABLE orders ADD CONSTRAINT FrKey1 FOREIGN KEY(cust_id)
REFERENCES customer(cust_id);

ALTER TABLE order_list ADD CONSTRAINT FrKey2 FOREIGN KEY(order_no)
REFERENCES orders(order_no);

ALTER TABLE order_list ADD CONSTRAINT FrKey3 FOREIGN KEY(pizza_id)
REFERENCES pizza(pizza_id);


REM INSERTING OF DATA IN THE RELATIONS
REM ----------------------------------

REM customer(cust_id, cust_name, address, phone)
 
insert into customer values('c001','Hari','32 RING ROAD,ALWARPET',9001200031);
insert into customer values('c002','Prasanth','42 bull ROAD,numgambakkam',9444120003);
insert into customer values('c003','Neethu','12a RING ROAD,ALWARPET',9840112003);
insert into customer values('c004','Jim','P.H ROAD,Annanagar',9845712993);
insert into customer values('c005','Sindhu','100 feet ROAD,vadapalani',9840166677);
insert into customer values('c006','Brinda','GST ROAD, TAMBARAM', 9876543210);
insert into customer values('c007','Ramkumar','2nd cross street, Perambur',8566944453);

SELECT * FROM customer;

REM pizza (pizza_id, pizza_type, unit_price)

insert into pizza values('p001','pan',130);
insert into pizza values('p002','grilled',230);
insert into pizza values('p003','italian',200);
insert into pizza values('p004','spanish',260);
insert into pizza values('p005','supremo',250);

SELECT * FROM pizza;

REM orders(order_no, cust_id, order_date ,delv_date)

insert into orders values('OP100','c001','28-JUN-2015','28-JUN-2015');
insert into orders values('OP200','c002','28-JUN-2015','29-JUN-2015');

insert into orders values('OP300','c003','29-JUN-2015','29-JUN-2015');
insert into orders values('OP400','c004','29-JUN-2015','29-JUN-2015');
insert into orders values('OP500','c001','29-JUN-2015','30-JUN-2015');
insert into orders values('OP600','c002','29-JUN-2015','29-JUN-2015');

insert into orders values('OP700','c005','30-JUN-2015','30-JUN-2015');
insert into orders values('OP800','c006','30-JUN-2015','30-JUN-2015');

SELECT * FROM orders;

REM order_list(order_no, pizza_id, qty)

insert into order_list values('OP100','p001',3);
insert into order_list values('OP100','p002',2);
insert into order_list values('OP100','p003',2);
insert into order_list values('OP100','p004',5);
insert into order_list values('OP100','p005',4);

insert into order_list values('OP200','p003',2);
insert into order_list values('OP200','p001',6);
insert into order_list values('OP200','p004',8);

insert into order_list values('OP300','p003',3);

insert into order_list values('OP400','p001',3);
insert into order_list values('OP400','p004',1);

insert into order_list values('OP500','p003',6);
insert into order_list values('OP500','p004',5);
insert into order_list values('OP500','p001',null);

insert into order_list values('OP600','p002',3);
insert into order_list values('OP600','p003',2);

SELECT * FROM order_list;

REM c) Include constraint : The quantity ordered for a pizza cannot be null.
REM -----------------------------------------------------------------------------

DELETE FROM order_list WHERE qty IS NULL;

ALTER TABLE order_list MODIFY qty NUMBER NOT NULL;

REM Create the following views and perform DML operations on it. Classify whether
REM a views is Updatable or not.
REM -----------------------------------------------------------------------------

REM 1. An user is interested to have list of pizza�s in the range of Rs.200-250.
REM	Create a view Pizza_200_250 which keeps the pizza details that has
REM	the price in the range of 200 to 250.
REM -----------------------------------------------------------------------------

DROP VIEW Pizza_200_250; 

CREATE VIEW Pizza_200_250 AS SELECT * FROM pizza WHERE unit_price
BETWEEN 200 AND 250;

SELECT * FROM Pizza_200_250;

REM 2. Pizza company owner is interested to know the number of pizza types
REM	ordered in each order. Create a view Pizza_Type_Order that lists the
REM	number of pizza types ordered in each order.
REM -----------------------------------------------------------------------------

DROP VIEW Pizza_Type_Order;

CREATE VIEW Pizza_Type_Order AS SELECT order_no, COUNT(order_no) pizza_count
FROM order_list GROUP BY order_no;

SELECT * FROM Pizza_Type_Order;

REM 3. To know about the customers of Spanish pizza, create a view
REM	Spanish_Customer that list out the customer id, name, order_no of
REM	customers who ordered Spanish type.
REM -----------------------------------------------------------------------------

DROP VIEW Spanish_Customer;

CREATE VIEW Spanish_Customer AS SELECT c.cust_id, c.cust_name,
ol.order_no FROM order_list ol, orders o, customer c, pizza p WHERE
c.cust_id = o.cust_id AND ol.order_no = o.order_no AND p.pizza_id =
ol.pizza_id AND p.pizza_type = 'spanish';

SELECT * FROM Spanish_Customer;

REM 4. Create a sequence named Order_No_Seq which generates the Order
REM	number starting from 1001, increment by 1, to a maximum of 9999.
REM	Include options of cycle, cache and order. Use this sequence to populate
REM	the rows of Order_List table.
REM	[Hint: Append the order_no generated by the sequence with 'OP' and
REM	then insert the values]
REM -----------------------------------------------------------------------------

DROP SEQUENCE Order_No_Seq;

CREATE SEQUENCE Order_No_Seq
START WITH 1001
INCREMENT BY 1
NOMINVALUE
MAXVALUE 9999
NOCYCLE
NOCACHE
NOORDER;

ALTER TABLE order_list DROP CONSTRAINT FrKey2;

ALTER TABLE order_list MODIFY order_no VARCHAR2(6);

UPDATE order_list SET order_no = CONCAT('OP', TO_CHAR(Order_No_Seq.nextval));

SELECT * FROM order_list;