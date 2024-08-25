REM PIZZA ORDERING SYSTEM
REM**********************

REM b)Create tables with appropriate data types and integrity constraints in
REM	order to populate tables from the Pizza_DB.sql file.
REM -------------------------------------------------------------------------


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

ALTER TABLE order_list ADD CONSTRAINT PrKey3 PRIMARY KEY(order_no, pizza_id);

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
REM ------------------------------------------------------------------------

ALTER TABLE order_list MODIFY qty NUMBER NOT NULL;


REM Write the following using JOIN:
REM -------------------------------

REM 1. For each pizza, display the total quantity ordered by the customers.
REM -----------------------------------------------------------------------------

SELECT p.pizza_id, SUM(qty) FROM pizza p, order_list o WHERE p.pizza_id = o.pizza_id
GROUP BY p.pizza_id;


REM 2. Find the pizza type(s) that is not delivered on the ordered day.
REM -----------------------------------------------------------------------------

SELECT DISTINCT(p.pizza_type) FROM pizza p, orders o, order_list ol  
WHERE o.order_date <> o.delv_date and ol.order_no = o.order_no and 
ol.pizza_id = p.pizza_id;


REM 3. Display the number of order(s) placed by each customer whether or not
REM he/she placed the order.
REM -----------------------------------------------------------------------------

SELECT c.cust_id, COUNT(c.cust_id) from customer c, orders o WHERE c.cust_id = o.cust_id
GROUP BY c.cust_id;


REM 4. Find the pairs of pizzas such that the ordered quantity of first pizza type 
REM	is more than the second for the order OP100.
REM ------------------------------------------------------------------------------

SELECT first.pizza_id||' & '||second.pizza_id pizza_pairs FROM order_list first, 
order_list second WHERE first.qty > second.qty AND first.order_no = 'OP100'
AND second.order_no = 'OP100' AND first.pizza_id < second.pizza_id;


REM Write the following using Sub query:
REM ------------------------------------

REM 5. Display the details (order number, pizza type, customer name, qty) of the
REM	pizza with ordered quantity more than the average ordered quantity of
REM	pizzas.
REM ----------------------------------------------------------------------------

SELECT ol.order_no, p.pizza_type, c.cust_name, ol.qty FROM customer c, order_list ol,
pizza p, orders o WHERE c.cust_id = o.cust_id AND p.pizza_id = ol.pizza_id AND o.order_no = 
ol.order_no AND ol.qty > (select AVG(ol.qty) FROM order_list ol);

REM 6. Find the customer(s) who ordered for more than one pizza type in each
REM	order.
REM -----------------------------------------------------------------------------

SELECT DISTINCT(c.cust_name) FROM customer c, order_list ol, orders o WHERE c.cust_id = o.cust_id
AND ol.order_no = o.order_no AND o.order_no IN (SELECT ol.order_no FROM order_list 
GROUP BY ol.order_no HAVING COUNT(ol.order_no) > 1);

REM 7. Display the details (order number, pizza type, customer name, qty) of the
REM	pizza with ordered quantity more than the average ordered quantity of
REM	each pizza type.
REM ----------------------------------------------------------------------------

SELECT ol.order_no, p.pizza_type, c.cust_name, ol.qty FROM customer c, order_list ol,
pizza p, orders o WHERE c.cust_id = o.cust_id AND p.pizza_id = ol.pizza_id AND o.order_no = 
ol.order_no AND ol.qty > ANY(select AVG(ol.qty) FROM order_list ol 
GROUP BY ol.order_no);

REM 8. Display the details (order number, pizza type, customer name, qty) of the
REM	pizza with ordered quantity more than the average ordered quantity of its
REM	pizza type. (Use correlated)
REM -----------------------------------------------------------------------------

SELECT ol.order_no, p.pizza_type, c.cust_name, ol.qty FROM customer c, order_list ol,
pizza p, orders o WHERE c.cust_id = o.cust_id AND p.pizza_id = ol.pizza_id AND o.order_no = 
ol.order_no AND ol.qty = ANY(select AVG(ol.qty) FROM order_list ol GROUP BY ol.order_no);

REM 9. Display the customer details who placed all pizza types in a single order.
REM -----------------------------------------------------------------------------

SELECT DISTINCT(c.cust_name) FROM customer c, orders o, order_list ol WHERE o.order_no = ol.order_no 
AND c.cust_id = o.cust_id AND o.order_no IN (SELECT ol.order_no FROM order_list ol, orders o
WHERE o.order_no = ol.order_no GROUP BY ol.order_no HAVING COUNT(ol.order_no) = 5 );

REM Write the following using Set Operations:
REM ----------------------------------------

REM 10.Display the order details that contains the pizza quantity more than the
REM	average quantity of any of Pan or Italian pizza type.
REM -----------------------------------------------------------------------------

SELECT ol.order_no, ol.pizza_id, ol.qty FROM orders o, order_list ol, pizza p 
WHERE o.order_no = ol.order_no AND p.pizza_id = ol.pizza_id AND ol.qty > ANY(SELECT AVG(ol.qty) 
FROM order_list ol, pizza p WHERE p.pizza_id = ol.pizza_id AND p.pizza_type = 'pan')
UNION
SELECT ol.order_no, ol.pizza_id, ol.qty FROM orders o, order_list ol, pizza p 
WHERE o.order_no = ol.order_no AND p.pizza_id = ol.pizza_id AND ol.qty > ANY(SELECT AVG(ol.qty) 
FROM order_list ol, pizza p WHERE p.pizza_id = ol.pizza_id AND p.pizza_type = 'italian');

REM 11.Find the order(s) that contains Pan pizza but not the Italian pizza type.
REM -----------------------------------------------------------------------------

SELECT ol.order_no FROM orders o, order_list ol, pizza p WHERE pizza_type = 'pan'
AND o.order_no = ol.order_no AND p.pizza_id = ol.pizza_id
MINUS
SELECT ol.order_no FROM orders o, order_list ol, pizza p WHERE pizza_type = 'italian' 
AND o.order_no = ol.order_no AND p.pizza_id = ol.pizza_id;


REM 12. Display the customer(s) who ordered both Italian and Grilled pizza type.
REM -----------------------------------------------------------------------------

SELECT cust_name FROM orders o, order_list ol, pizza p, customer c WHERE pizza_type = 'italian'
AND o.order_no = ol.order_no AND o.cust_id = c.cust_id AND p.pizza_id = ol.pizza_id
INTERSECT
SELECT cust_name FROM orders o, order_list ol, pizza p, customer c WHERE pizza_type = 'grilled' 
AND o.order_no = ol.order_no AND o.cust_id = c.cust_id AND p.pizza_id = ol.pizza_id;