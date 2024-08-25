REM MUSIC STORE
REM************


REM DROPING the relations
REM----------------------

drop table MUSICIAN;
drop table ALBUM;
drop table SONG;
drop table ARTIST;
drop table SUNGBY;
drop table STUDIO;


REM CREATING MUSICIAN RELATION
REM---------------------------

CREATE TABLE MUSICIAN(
Musician_ID NUMBER(5) PRIMARY KEY,
Musician_Name VARCHAR2(25),
Birth_Place VARCHAR2(25)
);


REM CREATING ALBUM RELATION
REM------------------------

CREATE TABLE ALBUM(
Album_Name VARCHAR2(25),
Album_ID NUMBER(5) PRIMARY KEY,
Year_Of_Release VARCHAR2(4)
CHECK(Year_Of_Release>1945),
Number_Of_Tracks NUMBER(5) NOT NULL,
Recorded_Studio VARCHAR2(25),
Album_Genre VARCHAR2(25) CHECK(
Album_Genre IN ('CAR', 'DIV', 'MOV', 'POP')),
Musician_Name VARCHAR2(25)
);


REM CREATING SONG RELATION
REM-----------------------

CREATE TABLE SONG(
Album_ID NUMBER(5),
Track_Number NUMBER(5) PRIMARY KEY,
Song_Name VARCHAR2(25),
Length NUMBER(5) 
CHECK(Length>7 where Song_Genre=='PAT'),
Song_Genre VARCHAR2(25) CHECK(
Song_Genre IN ('PHI', 'REL', 'LOV', 'DEV', 'PAT'))
);


REM CREATING ARTIST RELATION
REM-------------------------

CREATE TABLE ARTIST(
Artist_ID NUMBER(5) PRIMARY KEY,
Artist_Name VARCHAR2(25) UNIQUE
);


REM CREATING SUNGBY RELATION
REM-------------------------

CREATE TABLE SUNGBY(
Album_ID NUMBER(5),
Artist_ID NUMBER(5),
Track_Number NUMBER(5),
Recorded_Date DATE
);


REM CREATING STUDIO RELATION
REM-------------------------

CREATE TABLE STUDIO(
Studio_Name VARCHAR2(25) PRIMARY KEY,
Address VARCHAR2(50),
Phone_Number NUMBER(10)
);


REM : REPRESENT THE GENDER OF AN ARTIST IN THE TABLE

ALTER TABLE ARTIST ADD Gender VARCHAR2(1);


REM : FIRST FEW WORDS OF THE LYRICS CONSTITUTE THE 
REM   SONG NAME------------------------------------------------------------


REM : PHONE NUMBER OF EACH STUDIO MUST BE DIFFERENT

ALTER TABLE STUDIO MODIFY Phone_Number 
NUMBER(10) UNIQUE;


REM : INCLUDE NAT IN SONG GENRE FOR NATURE SONGS

ALTER TABLE SONG MODIFY Song_Genre VARCHAR2(25) 
CHECK(Song_Genre IN 
('PHI', 'REL', 'LOV', 'DEV', 'PAT', 'NAT')),
