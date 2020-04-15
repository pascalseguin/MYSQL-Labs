/*Lab4 Pascal Seguin*/

/*Exercise1*/

DROP PROCEDURE add_author;

delimiter $$
CREATE PROCEDURE add_author
(
IN id CHAR(11),
IN last VARCHAR(40),
IN first VARCHAR(20)
)
BEGIN 
INSERT INTO author (au_id, au_lname, au_fname)
VALUES (id, last, first);
END $$
delimiter ;
-------------------------------------------------------------
CALL add_author('300', 'Collins', 'Suzanne');
CALL add_author('400', 'Ittyipe', 'Shoba');
-------------------------------------------------------------
SELECT au_id, au_lname, au_fname
FROM author
WHERE au_id = 300 OR au_id = 400;
-------------------------------------------------------------
DROP PROCEDURE add_title;

delimiter $$
CREATE PROCEDURE add_title
(
IN tit_id CHAR(6),
IN tit_name VARCHAR(80),
IN publisher CHAR(4)
)

BEGIN 
INSERT INTO title (title_id, title, pub_id)
VALUES(tit_id, tit_name, publisher);
END $$
delimiter ;
--------------------------------------------------------------
CALL add_title ("123", "About Life", "0877");
CALL add_title ("789", "Udacity", "1389");
--------------------------------------------------------------
SELECT title_id, title, pub_id
FROM title
WHERE title_id = 123 OR title_id = 789;
--------------------------------------------------------------
DROP FUNCTION find_title;
delimiter $$
CREATE FUNCTION find_title(titleName CHAR(80))
 RETURNS char(6)
BEGIN
 DECLARE id CHAR(6);
 SELECT title_id
 INTO id
 FROM title WHERE title = titleName;
 return id;
END$$
delimiter ;
--------------------------------------------------------------
SELECT find_title ("About Life") as id;
--------------------------------------------------------------
SELECT *
FROM author_title
ORDER BY title_id, au_id;
--------------------------------------------------------------
DROP PROCEDURE addAuthorTitle;
delimiter $$
CREATE PROCEDURE addAuthorTitle(
IN auNbr CHAR(11),
IN titleName VARCHAR(80),
IN ordering DECIMAL(3,0),
IN royalty decimal(6,2))
BEGIN
 DECLARE aid INT;
 INSERT INTO author_title (au_id, title_id, au_ord, royaltyshare)
 VALUES (auNbr, find_title(titleName), ordering, royalty);
END$$
delimiter ;
-------------------------------------------------------------
CALL addAuthorTitle(300, "About Life", 1, 0.6);
CALL addAuthorTitle(400, "About Life", 2, 0.4);
-------------------------------------------------------------
SELECT *
FROM author_title
WHERE au_id = 300 OR au_id = 400;
-------------------------------------------------------------
DROP PROCEDURE add_author_check;
delimiter $$
CREATE PROCEDURE add_author_check
(
 IN id CHAR(11),
 IN last VARCHAR(40),
 IN first VARCHAR(20),
 IN a VARCHAR(50),
 OUT b VARCHAR(20)
)
BEGIN
IF a LIKE 'Justin Beiber%' THEN
 SET b = 'Invalid Entry!';
ELSE
 INSERT INTO author (au_id, au_lname, au_fname, address)
 VALUES (id, last, first, a);
END IF;
END$$
delimiter ;
----------------------------------------------------------------
CALL add_author_check('11', 'Gomez', 'Selena', 'Justin Beiber',
@just);
----------------------------------------------------------------
select @just;
----------------------------------------------------------------
/*Exercise 2*/

/*1*/

DROP TABLE IF EXISTS book_price_audit;
CREATE TABLE book_price_audit (
title_id char(6),
type char(12),
old_price numeric(6,2),
new_price numeric(6,2),
)ENGINE InnoDB;

/*EXERCISE 2*/

DROP TRIGGER IF EXISTS audit_book_price_BUR;

delimiter $$
CREATE TRIGGER audit_book_price_BUR
BEFORE UPDATE
ON title
FOR EACH ROW
BEGIN
IF (new.price / old.price >= 1.1) THEN
INSERT INTO book_price_audit
VALUES(new.title_id, new.type, old.price, new.price);
END IF;
END$$
delimiter ;

UPDATE title 
SET price = 21.00
WHERE title_id LIKE "PC8888";

UPDATE title 
SET price = 25.00
WHERE title_id LIKE "BU1032";

SELECT *
FROM book_price_audit;

/*Exercise 3*/

ALTER TABLE book_price_audit
ADD audit_nbr INT;

DROP TRIGGER IF EXISTS generate_audit_nbr_BIR;


delimiter $$
CREATE TRIGGER generate_audit_nbr_BIR
before insert
on book_price_audit
for each row
BEGIN
UPDATE book_price_audit
SET audit_nbr =  1+(SELECT MAX(audit_nbr)
FROM book_price_audit)
END IF;
END$$
delimiter ;

DROP TRIGGER IF EXISTS audit_book_price_BUR;

delimiter $$
CREATE TRIGGER audit_book_price_BUR
BEFORE UPDATE
ON title
FOR EACH ROW
BEGIN
IF (new.price / old.price >= 1.1) THEN
insert into book_price_audit (title_id, type, old_price, new_price)
 values (new.title_id, new.type, old.price, new.price);
END IF;
END$$
delimiter ;
