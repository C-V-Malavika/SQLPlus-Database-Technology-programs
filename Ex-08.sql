REM DATABASE DESIGN USING NORMAL FORMS
REM **********************************

REM Dropping the relations
REM ----------------------

DROP TABLE ClientRental CASCADE CONSTRAINTS;
DROP TABLE Client CASCADE CONSTRAINTS;
DROP TABLE Rental CASCADE CONSTRAINTS;
DROP TABLE PropertyForRent CASCADE CONSTRAINTS;
DROP TABLE Owner CASCADE CONSTRAINTS;

REM Creating the relations
REM ----------------------

REM ClientRental(clientNo, cName, propertyNo, pAddress, rentStart, rentFinish,
REM rent, ownerNo, oName)

CREATE TABLE ClientRental(
clientNo VARCHAR2(4), 
cName VARCHAR2(20), 
propertyNo VARCHAR2(4),
pAddress VARCHAR2(30),
rentStart DATE,
rentFinish DATE, 
rent NUMBER(3),
ownerNo VARCHAR2(4),
oName VARCHAR2(20)
);

REM Client(clientNo, cName)

CREATE TABLE Client(
clientNo VARCHAR2(4), 
cName VARCHAR2(20)
);

REM Rental(clientNo, propertyNo, rentStart, rentFinish)


CREATE TABLE Rental(
clientNo VARCHAR2(4), 
propertyNo VARCHAR2(4),
rentStart DATE,
rentFinish DATE 
);


REM PropertyForRent(propertyNo, pAddress, rent, ownerNo)

CREATE TABLE PropertyForRent(
propertyNo VARCHAR2(4),
pAddress VARCHAR2(30),
rent NUMBER(3),
ownerNo VARCHAR2(4)
);

REM Owner(ownerNo, oName)

CREATE TABLE Owner(
ownerNo VARCHAR2(4),
oName VARCHAR2(20)
);


REM Adding the constraints
REM ----------------------

ALTER TABLE ClientRental ADD CONSTRAINT PrKey5 PRIMARY KEY(clientNo, propertyNo);

ALTER TABLE Client ADD CONSTRAINT PrKey6 PRIMARY KEY(clientNo);

ALTER TABLE Rental ADD CONSTRAINT PrKey7 PRIMARY KEY(clientNo, propertyNo);

ALTER TABLE PropertyForRent ADD CONSTRAINT PrKey8 PRIMARY KEY(propertyNo);

ALTER TABLE Owner ADD CONSTRAINT PrKey9 PRIMARY KEY(ownerNo);

ALTER TABLE Rental ADD CONSTRAINT FrKey6 FOREIGN KEY(clientNo)
REFERENCES Client(clientNo);


REM INSERTING OF DATA IN THE RELATIONS
REM ----------------------------------

REM ClientRental(clientNo, cName, propertyNo, pAddress, rentStart, rentFinish,
REM rent, ownerNo, oName)

insert into ClientRental values('CR76','John Kay','PG4','6 Lawrence St, Glasgow', TO_DATE('1-Jul-12', 'dd-MON-yy'), 
TO_DATE('1-Aug-13', 'dd-MON-yy'), 350, 'CO40', 'Tina Murphy');

insert into ClientRental values('CR76','John Kay','PG16','5 Novar Dr, Glasgow', TO_DATE('1-Sep-13', 'dd-MON-yy'), 
TO_DATE('1-Sep-14', 'dd-MON-yy'), 50, 'CO93', 'Tony Shaw');

insert into ClientRental values('CR56','Aline Stewart','PG4','6 Lawrence St, Glasgow', TO_DATE('1-Sep-11', 'dd-MON-yy'), 
TO_DATE('10-June-12', 'dd-MON-yy'), 350, 'CO40', 'Tina Murphy');

insert into ClientRental values('CR56','Aline Stewart','PG36','2 Manor Rd, Glasgow', TO_DATE('10-Oct-12', 'dd-MON-yy'), 
TO_DATE('1-Dec-13', 'dd-MON-yy'), 375, 'CO93', 'Tony Shaw');

insert into ClientRental values('CR56','Aline Stewart','PG16','5 Novar Dr, Glasgow', TO_DATE('1-Nov-14', 'dd-MON-yy'), 
TO_DATE('10-Aug-15', 'dd-MON-yy'), 450, 'CO93', 'Tony Shaw');

SELECT * FROM ClientRental;

REM Client(clientNo, cName)

insert into Client values('CR76','John Kay');
insert into Client values('CR56','Aline Stewart');

SELECT * FROM Client;

REM Rental(clientNo, propertyNo, rentStart, rentFinish)

insert into Rental values('CR76','PG4',TO_DATE('1-Jul-12', 'dd-MON-yy'),TO_DATE('1-Aug-13', 'dd-MON-yy'));
insert into Rental values('CR76','PG16',TO_DATE('1-Sep-13', 'dd-MON-yy'),TO_DATE('1-Sep-14', 'dd-MON-yy'));
insert into Rental values('CR56','PG4',TO_DATE('1-Sep-11', 'dd-MON-yy'),TO_DATE('10-June-12', 'dd-MON-yy'));
insert into Rental values('CR56','PG36',TO_DATE('10-Oct-12', 'dd-MON-yy'),TO_DATE('1-Dec-13', 'dd-MON-yy'));
insert into Rental values('CR56','PG16',TO_DATE('1-Nov-14', 'dd-MON-yy'),TO_DATE('10-Aug-15', 'dd-MON-yy'));

SELECT * FROM Rental;

REM PropertyForRent(propertyNo, pAddress, rent, ownerNo)

insert into PropertyForRent values('PG4','6 Lawrence St, Glasgow', 350, 'CO40');
insert into PropertyForRent values('PG16','5 Novar Dr, Glasgow', 50, 'CO93');
insert into PropertyForRent values('PG36','2 Manor Rd, Glasgow', 375, 'CO93');

SELECT * FROM PropertyForRent;

REM Owner(ownerNo, ownerName)

insert into Owner values('CO40', 'Tina Murphy');
insert into Owner values('CO93','Tony Shaw');

SELECT * FROM Owner;


REM Joining the four relations - Client, Rental, PropertyForRent and Owner tables
REM to compare with ClientRental relation

SELECT c.clientNo, c.cName, pfr.propertyNo, pfr.pAddress, r.rentStart, r.rentFinish, pfr.rent, o.ownerNo, o.oName
FROM Client c, PropertyForRent pfr, Rental r, Owner o
WHERE c.ClientNo = r.clientNo
AND r.propertyNo = pfr.propertyNo
AND pfr.ownerNo = o.ownerNo;

SELECT * FROM ClientRental;