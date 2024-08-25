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


REM Write a PL/SQL block for the following: 
REM Note: 
REM a. Use implicit/explicit cursor wherever required.
REM b. Display appropriate message if the data is non-available. 

REM 1.Check whether the given pizza type is available. If available display its 
REM unit price. If not, display "The pizza is not available / Invalid pizza type". 

SET serveroutput ON;
SET VERIFY OFF;

DECLARE

  price pizza.unit_price%type;
  pizza_name pizza.pizza_type%type := '&Pizza_Type';

BEGIN  

  SELECT unit_price 
  INTO price 
  FROM pizza
  WHERE pizza_type = pizza_name;
  DBMS_OUTPUT.PUT_LINE
  ('Unit Price: '||price);

EXCEPTION

  WHEN NO_DATA_FOUND THEN
  DBMS_OUTPUT.PUT_LINE
  ('The pizza is not available / Invalid pizza type');

END;

/

REM 2.For the given customer name and a range of order date, find whether a customer 
REM had placed any order, if so display the number of orders placed by the customer 
REM along with the order number(s). 

SET serveroutput ON;
SET VERIFY OFF;

DECLARE

  name customer.cust_name%type := '&Customer_Name';
  start_date orders.order_date%type := '&Start_Date';
  end_date orders.order_date%type := '&End_Date';
  orderno orders.order_no%type;
  count_order NUMBER := 0;
  
  CURSOR cur1 IS SELECT COUNT(c.cust_id)
  FROM orders o, customer c WHERE 
  c.cust_id = o.cust_id 
  AND c.cust_name = name 
  AND order_date BETWEEN
  start_date AND end_date
  GROUP BY c.cust_id;

  CURSOR cur2 IS SELECT o.order_no
  FROM orders o, customer c WHERE 
  c.cust_id = o.cust_id 
  AND c.cust_name = name 
  AND order_date BETWEEN
  start_date AND end_date;

BEGIN
  
  OPEN cur1;
  FETCH cur1 INTO count_order;
  DBMS_OUTPUT.PUT_LINE
  ('Number of Orders: '||count_order);
  CLOSE cur1;

  OPEN cur2;
  DBMS_OUTPUT.PUT_LINE
  ('Order Numbers are : ');   
  LOOP
   FETCH cur2 INTO orderno;
   EXIT WHEN cur2%NOTFOUND;
   DBMS_OUTPUT.PUT_LINE
   (orderno);   
  END LOOP;
  CLOSE cur2;

END;

/

REM 3.Display the customer name along with the details of pizza type and its quantity 
REM ordered for the given order number. Also find the total quantity ordered for the 
REM given order number as shown below: 

REM SQL> /Enter value for oid: OP100 
REM old 11: oid:='&oid'; 
REM new 11: oid:='OP100'; 
REM Customer name: Hari 
REM Ordered Following Pizza 
REM PIZZA TYPE	QTY
REM Pan		3
REM Grilled	2
REM Italian	1
REM Spanish	5 
REM --------------------
REM Total Qty: 11

SET serveroutput ON;
SET VERIFY ON;

DECLARE

  oid order_list.order_no%type := '&oid';
  name customer.cust_name%type;
  pizza_name pizza.pizza_type%type;
  quantity order_list.qty%type;
  quantity_sum NUMBER;
  
  CURSOR cur1 IS SELECT c.cust_name 
  FROM customer c, orders o
  WHERE c.cust_id = o.cust_id
  AND o.order_no = oid;

  CURSOR cur2 IS SELECT p.pizza_type, ol.qty
  FROM pizza p, order_list ol
  WHERE p.pizza_id = ol.pizza_id
  AND ol.order_no = oid;

  CURSOR cur3 IS SELECT SUM(ol.qty)
  FROM pizza p, order_list ol
  WHERE p.pizza_id = ol.pizza_id
  AND ol.order_no = oid;

BEGIN
  
  OPEN cur1;
  FETCH cur1 INTO name;
  DBMS_OUTPUT.PUT_LINE
  ('Customer Name: '||name);
  DBMS_OUTPUT.PUT_LINE
  ('Ordered Following Pizza');
  DBMS_OUTPUT.PUT_LINE
  ('PIZZA TYPE	QTY');
  CLOSE cur1;

  OPEN cur2;
  LOOP
   FETCH cur2 INTO pizza_name, quantity;
   EXIT WHEN cur2%NOTFOUND;
   DBMS_OUTPUT.PUT_LINE
   (pizza_name||'		'||quantity);   
  END LOOP;
  CLOSE cur2;

  OPEN cur3;
  FETCH cur3 INTO quantity_sum;
  DBMS_OUTPUT.PUT_LINE
  ('-------------------');
  DBMS_OUTPUT.PUT_LINE
  ('Total Qty: '||quantity_sum);
  CLOSE cur3;

END;

/

REM 4.Display the total number of orders that contains one pizza type, two pizza type and so on.
 
REM Number of Orders that contains
REM Only ONE Pizza type  8
REM Two Pizza types      3
REM Three Pizza types    2
REM ALL Pizza types      1

SET serveroutput ON;
SET VERIFY OFF;

DECLARE

  count_order NUMBER := 0;
  count_one NUMBER := 0;
  count_two NUMBER := 0;
  count_three NUMBER := 0;
  count_four NUMBER := 0;
  count_five NUMBER := 0;
  
  CURSOR cur1 IS SELECT COUNT(ol.order_no)
  FROM order_list ol
  WHERE ol.qty IS NOT NULL 
  GROUP BY ol.order_no;

BEGIN

  OPEN cur1;
  LOOP
   FETCH cur1 INTO count_order;
   EXIT WHEN cur1%NOTFOUND;
   IF count_order = 1 THEN
      count_one := count_one + 1;
   ELSIF count_order = 2 THEN
      count_two := count_two + 1;
   ELSIF count_order = 3 THEN
      count_three := count_three + 1;
   ELSIF count_order = 4 THEN
      count_four := count_four + 1;
   ELSE
      count_five := count_five + 1;
   END IF;
  END LOOP;

  DBMS_OUTPUT.PUT_LINE
  ('Number of Orders that contains');
  DBMS_OUTPUT.PUT_LINE
  ('Only ONE Pizza type '||count_one);
  DBMS_OUTPUT.PUT_LINE
  ('Two Pizza types '||count_two);
  DBMS_OUTPUT.PUT_LINE
  ('Three Pizza types '||count_three);
  DBMS_OUTPUT.PUT_LINE
  ('Four Pizza types '||count_four);
  DBMS_OUTPUT.PUT_LINE
  ('ALL Pizza types '||count_five);
  
END;

/