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

REM Write a PL/SQL stored procedure / stored function for the following:
REM Note:
REM a. Use implicit/explicit cursor wherever required.
REM b. Display appropriate message if the data is non-available.

REM 1. Write a stored procedure to display the total number of pizza's ordered by
REM the given order number.(Use IN, OUT)

SET serveroutput ON;

CREATE OR REPLACE PROCEDURE 
total_pizza(O IN order_list.order_no%type, 
  N OUT order_list.qty%type) 
IS
BEGIN
 SELECT SUM(ol.qty) INTO N
 FROM order_list ol
 GROUP BY ol.order_no
 HAVING ol.order_no = O;
END;

/

DECLARE
  X order_list.order_no%type := '&Order_Number';
  Y order_list.qty%type;
BEGIN
  total_pizza(X, Y);
  DBMS_OUTPUT.PUT_LINE('Total number of pizzas ordered: '|| Y);
END;

/

REM 2. For the given order number, calculate the Discount as follows:
REM For total amount > 2000 and total amount < 5000:  Discount=5%
REM For total amount > 5000 and total amount < 10000: Discount=10%
REM For total amount > 10000:                         Discount=20%
REM Calculate the total amount (after the discount) and update the same in
REM orders table. Print the order as shown below:

REM ************************************************************
REM Order Number:OP104            Customer Name: Hari
REM Order Date :29-Jun-2015       Phone: 9001200031
REM ************************************************************
REM SNo    Pizza Type    Qty     Price      Amount
REM 1.     Italian       6       200        1200
REM 2.     Spanish       5       260        1300
REM ------------------------------------------------------
REM        Total =       11                  2500
REM ------------------------------------------------------
REM Total Amount       :Rs.2500
REM Discount (5%)      :Rs. 125
REM ------------------------------
REM Amount to be paid  :Rs.2375
REM ------------------------------
REM Great Offers! Discount up to 25% on DIWALI Festival Day...
REM *************************************************************

SET serveroutput ON;
SET VERIFY ON;

CREATE OR REPLACE PROCEDURE
customer_details(ono IN order_list.order_no%type, 
  name OUT customer.cust_name%type,
  phno OUT customer.phone%type, 
  orderdate OUT orders.order_date%type)
IS
BEGIN  
  SELECT c.cust_name,
  o.order_date, c.phone
  INTO name, orderdate, phno
  FROM customer c, orders o
  WHERE o.cust_id = c.cust_id
  AND o.order_no = ono;
END;

/

CREATE OR REPLACE PROCEDURE
total_price(ono IN order_list.order_no%type, 
  quantity OUT order_list.qty%type,
  total_amount OUT orders.total_amt%type)
IS
BEGIN  
  SELECT SUM(ol.qty), SUM(ol.qty*p.unit_price)
  INTO quantity, total_amount
  FROM pizza p, order_list ol, orders o 
  WHERE ol.pizza_id = p.pizza_id
  AND ol.order_no = o.order_no
  GROUP BY ol.order_no
  HAVING ol.order_no = ono;
END;

/

DECLARE
  O order_list.order_no%type := '&Order_Number';
  N customer.cust_name%type;
  P customer.phone%type;
  OD orders.order_date%type;

  PT pizza.pizza_type%type;
  Q order_list.qty%type; 
  PR pizza.unit_price%type;
  AMT NUMBER;
  SNO NUMBER := 0;

  QTY order_list.qty%type;
  TA orders.total_amt%type;
  DIS NUMBER := 0;

  CURSOR cur IS SELECT p.pizza_type, ol.qty,
  p.unit_price, ol.qty*p.unit_price
  FROM pizza p, order_list ol, orders o
  WHERE p.pizza_id = ol.pizza_id
  AND o.order_no = ol.order_no
  AND o.order_no = O;

BEGIN
  customer_details(O, N, P, OD);
  DBMS_OUTPUT.PUT_LINE
  ('************************************************************');
  DBMS_OUTPUT.PUT_LINE
  ('Order Number:'||O||'          '||'Customer Name: '||N);
  DBMS_OUTPUT.PUT_LINE
  ('Order Date :'||OD||'       '||'Phone: '||TO_CHAR(P));
  DBMS_OUTPUT.PUT_LINE
  ('************************************************************');
  DBMS_OUTPUT.PUT_LINE
  ('SNo'||'    '||'Pizza Type'||'    '||'Qty'||'     '||'Price'||'      '||'Amount');

  OPEN cur;
  LOOP
   FETCH cur INTO PT, Q, PR, AMT;
   SNO := SNO + 1;
   EXIT WHEN cur%NOTFOUND;
   DBMS_OUTPUT.PUT_LINE
   (SNO||'      '||PT||'       '||Q||'       '||PR||'        '||AMT);
  END LOOP;
  CLOSE cur;

  total_price(O, QTY, TA);
  DBMS_OUTPUT.PUT_LINE
  ('------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE
  ('|              Total ='||'       '||QTY||'         '||TA);
  DBMS_OUTPUT.PUT_LINE
  ('------------------------------------------------------');
  DBMS_OUTPUT.PUT_LINE
  ('Total Amount       :Rs.'||TA);

  IF TA < 5000 AND TA > 2000 THEN
    DIS := DIS + 5;
  ELSIF TA < 10000 AND TA > 5000 THEN 
    DIS := DIS + 10;
  ELSIF TA > 10000 THEN 
    DIS := DIS + 20;
  END IF;
  
  DBMS_OUTPUT.PUT_LINE
  ('Discount ('||DIS||'%)      :Rs.'||(DIS*TA)/100);
  DBMS_OUTPUT.PUT_LINE
  ('------------------------------');
  DBMS_OUTPUT.PUT_LINE
  ('Amount to be paid  :Rs.'||(TA - (DIS*TA)/100));
  DBMS_OUTPUT.PUT_LINE
  ('------------------------------');
  DBMS_OUTPUT.PUT_LINE
  ('Great Offers! Discount up to 25% on DIWALI Festival Day...');
  DBMS_OUTPUT.PUT_LINE
  ('************************************************************');
  
END;
/

REM 3. Write a stored function to display the customer name who ordered
REM highest among the total number of pizzas for a given pizza type.

SET serveroutput ON;
SET VERIFY ON;

CREATE OR REPLACE FUNCTION cust_name
  (pizza_name pizza.pizza_type%type)
RETURN customer.cust_name%type
AS 
  customer_name customer.cust_name%type;
BEGIN
  SELECT c.cust_name INTO customer_name
   FROM customer c, orders o, order_list ol, pizza p
   WHERE o.cust_id = c.cust_id
   AND ol.order_no = o.order_no
   AND ol.pizza_id = p.pizza_id
   AND (ol.pizza_id, ol.qty) IN (SELECT ol.pizza_id, MAX(qty) 
   FROM orders o, order_list ol 
   WHERE o.order_no = ol.order_no 
   GROUP BY ol.pizza_id) AND p.pizza_type = pizza_name;
  RETURN customer_name;
EXCEPTION
 WHEN OTHERS THEN
  RETURN('Error in running cust_name');
END;
/

DECLARE
  CN customer.cust_name%type; 
  PID pizza.pizza_type%type := '&Pizza_Type'; 
BEGIN
  CN := cust_name(PID);
  DBMS_OUTPUT.PUT_LINE
  ('Customer who ordered the highest among the total number of pizzaa for '||PID||' is : '||CN);
END;
/

REM 4.Implement Question (2) using stored function to return the amount to be 
REM paid and update the same, for the given order number.

SET serveroutput ON;
SET VERIFY ON;

CREATE OR REPLACE FUNCTION return_amount
  (orderno orders.order_no%type)
RETURN orders.total_amt%type
AS 
  total_amount orders.total_amt%type;
BEGIN
  SELECT SUM(ol.qty*p.unit_price) INTO total_amount
   FROM pizza p, order_list ol, orders o 
   WHERE ol.pizza_id = p.pizza_id
   AND ol.order_no = o.order_no
   GROUP BY ol.order_no
   HAVING ol.order_no = orderno;
  RETURN total_amount;
EXCEPTION
 WHEN OTHERS THEN
  RETURN('Error in running return_amount');
END;
/

DECLARE
  ONO orders.order_no%type := '&Order_Number'; 
  TA orders.total_amt%type;
  DIS NUMBER := 0;
BEGIN
  TA := return_amount(ONO);

  UPDATE orders SET total_amt = TA WHERE order_no = ONO;

  IF TA < 5000 AND TA > 2000 THEN
    DIS := DIS + 5;
  ELSIF TA < 10000 AND TA > 5000 THEN 
    DIS := DIS + 10;
  ELSIF TA > 10000 THEN 
    DIS := DIS + 20;
  END IF;

  DBMS_OUTPUT.PUT_LINE
  ('Actual Amount      :Rs.'||TA);  
  DBMS_OUTPUT.PUT_LINE
  ('Discount ('||DIS||'%)      :Rs.'||(DIS*TA)/100);
  DBMS_OUTPUT.PUT_LINE
  ('Amount to be paid  :Rs.'||(TA - (DIS*TA)/100));
END;
/

