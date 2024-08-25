REM DML Update operations & TCL statements
REM***************************************

REM DROPPING THE RELATION
REM ---------------------

DROP TABLE Classes CASCADE CONSTRAINTS;

REM CREATING THE RELATION
REM ---------------------

CREATE TABLE Classes(
Class VARCHAR2(25) PRIMARY KEY,
type VARCHAR2(2),
country VARCHAR2(25),
numGuns NUMBER(3),
bore NUMBER(3),
displacement NUMBER
);

REM 1. Populate the relation with the above set of tuples using 
REM	INSERT clause.
REM -----------------------------------------------------------

INSERT INTO Classes VALUES(
'Bismark', 'bb', 'Germany', 8, 14, 32000
);

INSERT INTO Classes VALUES(
'Iowa', 'bb', 'USA', 9, 16, 46000
);

INSERT INTO Classes VALUES(
'Kongo', 'bc', 'Japan', 8, 15, 42000
);

INSERT INTO Classes VALUES(
'North Carolina', 'bb', 'USA', 9, 16, 37000
);

INSERT INTO Classes VALUES(
'Revenge', 'bb', 'Gt. Britain', 8, 15, 29000
);

INSERT INTO Classes VALUES(
'Renown', 'bc', 'Gt. Britain', 6, 15, 32000
);

COMMIT;


REM 2. Display the populated relation.
REM -----------------------------------------------------------

SELECT * FROM Classes;


REM 3. Mark an intermediate point here in this transaction.
REM -----------------------------------------------------------

SAVEPOINT a;


REM 4. For the battleships having at least 9 number of guns or 
REM	the ships with at least 15 inch bore, increase the 
REM	displacement by 10%.
REM -----------------------------------------------------------

UPDATE Classes SET displacement = displacement + displacement * 
0.10 WHERE numGuns >= 9 OR bore >= 15;


REM 5. Delete Kongo class of ship from Classes table.
REM -----------------------------------------------------------

DELETE FROM Classes WHERE Class = 'Kongo';


REM 6. Display your changes to the table.
REM -----------------------------------------------------------

SELECT * FROM Classes;


REM 7. Discard the recent updates to the relation without 
REM	discarding the earlier INSERT operation(s).
REM -----------------------------------------------------------

ROLLBACK TO SAVEPOINT a;

SELECT * FROM Classes;


REM 8. Commit the changes.
REM -----------------------------------------------------------

COMMIT;