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

REM orders(order_no, cust_id, order_date ,delv_date, total_amt)

CREATE TABLE orders(
order_no VARCHAR2(5), 
cust_id VARCHAR2(4),  
order_date DATE,
delv_date DATE,
total_amt NUMBER
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

insert into orders values('OP100','c001','28-JUN-2015','28-JUN-2015',0);
insert into orders values('OP200','c002','28-JUN-2015','29-JUN-2015',0);

insert into orders values('OP300','c003','29-JUN-2015','29-JUN-2015',0);
insert into orders values('OP400','c004','29-JUN-2015','29-JUN-2015',0);
insert into orders values('OP500','c001','29-JUN-2015','30-JUN-2015',0);
insert into orders values('OP600','c002','29-JUN-2015','29-JUN-2015',0);

insert into orders values('OP700','c005','30-JUN-2015','30-JUN-2015',0);
insert into orders values('OP800','c006','30-JUN-2015','30-JUN-2015',0);

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

SET serveroutput ON;

CREATE OR REPLACE PROCEDURE 
update_total_amt(O IN order_list.order_no%type) 
IS
BEGIN
 UPDATE orders SET total_amt = (SELECT SUM(ol.qty*p.unit_price)
 FROM pizza p, order_list ol, orders o 
 WHERE ol.pizza_id = p.pizza_id
 AND ol.order_no = o.order_no
 GROUP BY ol.order_no
 HAVING ol.order_no = O) WHERE order_no = O; 
END;

/

DECLARE
  orderno order_list.order_no%type;

  CURSOR cur IS SELECT ol.order_no
  FROM order_list ol, orders o
  WHERE ol.order_no = o.order_no
  GROUP BY ol.order_no;
BEGIN
  OPEN cur; 
  LOOP
   FETCH cur INTO orderno;
   EXIT WHEN cur%NOTFOUND;
   update_total_amt(orderno);   
  END LOOP;
  CLOSE cur;
END;

/

SELECT * FROM orders;

REM Write a PL/SQL trigger and implement the following constraints:
REM Note:
REM a. Choose appropriate event(s) to ensure the constraint.

REM 1. Ensure that the pizza can be delivered on same day or on the next day only.

CREATE OR REPLACE TRIGGER delivery_date BEFORE 
  INSERT ON orders
FOR EACH ROW
BEGIN
  IF :NEW.delv_date NOT IN (:NEW.order_date, :NEW.order_date+1) THEN
  RAISE_APPLICATION_ERROR(-20500, 'Pizza can be delivered on same day or on the next day only');
  END IF;
END;
/

INSERT INTO orders VALUES('OP900','c006','29-JUN-2015','29-JUN-2015',0);
INSERT INTO orders VALUES('OP900','c006','27-JUN-2015','29-JUN-2015',0);

REM 2. Update the total_amt in ORDERS while entering an order in 
REM ORDER_LIST.

CREATE OR REPLACE TRIGGER update_total_amount BEFORE
  INSERT ON order_list
FOR EACH ROW
BEGIN
 UPDATE orders SET total_amt =
 (SELECT SUM(:NEW.qty*p.unit_price)
 FROM pizza p, order_list ol 
 WHERE ol.pizza_id = p.pizza_id
 GROUP BY ol.order_no
 HAVING ol.order_no = :NEW.order_no) 
 WHERE order_no = :NEW.order_no; 
END;
/

INSERT INTO order_list values('OP400','p005',5);

SELECT * FROM orders WHERE order_no = 'OP400';

REM 3. To give preference to all customers in delivery of pizzas', a threshold is set on the 
REM number of orders per day per customer. Ensure that a customer can not place more 
REM than 5 orders per day.
 
CREATE OR REPLACE TRIGGER number_of_ordered_pizzas BEFORE
  INSERT ON orders
FOR EACH ROW
DECLARE 
  count_orders NUMBER;
BEGIN
 SELECT COUNT(*) INTO count_orders 
 FROM orders o
 WHERE o.cust_id = :NEW.cust_id 
 AND o.order_date = :NEW.order_date;

 IF count_orders > 5 THEN
   RAISE_APPLICATION_ERROR(-20500, 'Customer can not place more than 5 orders per day');
 END IF;
END;
/

DROP TRIGGER delivery_date;

insert into orders values('OP901','c004','29-JUN-2015','30-JUN-2015',0);
insert into orders values('OP101','c004','29-JUN-2015','30-JUN-2015',0);
insert into orders values('OP102','c004','29-JUN-2015','30-JUN-2015',0);
insert into orders values('OP103','c004','29-JUN-2015','30-JUN-2015',0);
insert into orders values('OP104','c004','29-JUN-2015','30-JUN-2015',0);
insert into orders values('OP105','c004','29-JUN-2015','30-JUN-2015',0);