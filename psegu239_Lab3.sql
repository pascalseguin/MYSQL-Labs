/*1*/
SELECT loc_id, COUNT(course_section.loc_id) 
FROM course_section RIGHT OUTER JOIN location USING (loc_id)
GROUP BY (loc_id);

/*2*/

INSERT INTO course_section VALUES
(16, 3, 6, 1, 2, 'MTWRF', '09:00 AM','0 00:01:30.00', NULL, 35);

DELETE FROM course_section
WHERE c_sec_id = 16;

SELECT DISTINCT cs.c_sec_id, f.f_last, l.bldg_code, l.room
FROM course_section cs JOIN faculty f USING (f_id)
LEFT OUTER JOIN location l ON (cs.loc_id = l.loc_id);


/*3*/

INSERT INTO course_section VALUES
(17, 3, 6, 1, NULL , 'MTWRF', '09:00 AM','0 00:01:30.00', NULL, 35);

SELECT DISTINCT cs.c_sec_id, f.f_last, l.bldg_code, l.room
FROM course_section cs LEFT OUTER JOIN faculty f USING (f_id)
LEFT OUTER JOIN location l ON (cs.loc_id = l.loc_id);

/*4*/

SELECT cs.c_sec_id, COUNT(e.s_id)
FROM enrollment e RIGHT OUTER JOIN course_section cs USING (c_sec_id)
GROUP BY (cs.c_sec_id);

/*5*/

SELECT t.term_desc, COUNT(cs.term_id)
FROM course_section cs JOIN term t USING (term_id)
GROUP BY (term_id);

/*A.*/
SELECT t.term_desc, COUNT(cs.term_id)
FROM course_section cs RIGHT OUTER JOIN term t USING (term_id)
GROUP BY (term_id);

/*6*/

SELECT t.term_desc, COUNT(cs.term_id)
FROM term t LEFT OUTER JOIN course_section cs USING (term_id)
GROUP BY (term_id);

/*7*/

SELECT t.term_desc, t.term_id, SUM(cs.max_enrl)
FROM term t  JOIN course_section cs USING (term_id)
GROUP BY (t.term_id);

/*a.*/

SELECT t.term_desc, t.term_id, SUM(cs.max_enrl)
FROM term t LEFT OUTER JOIN course_section cs USING (term_id)
GROUP BY (t.term_id);

/*8*/

SELECT t.term_desc, t.term_id, SUM(cs.max_enrl)
FROM term t LEFT OUTER JOIN course_section cs USING (term_id)
GROUP BY (t.term_id)
HAVING (SUM(cs.max_enrl) < 200)
OR SUM(cs.max_enrl) IS NULL;

/*9*/

SELECT f.f_last
FROM faculty f JOIN course_section cs USING (f_id)
WHERE cs.term_id IN (SELECT term_id
       FROM term
	   WHERE term_desc LIKE "Summer 2007");
	   
/*10*/

SELECT c_sec_day, loc_id
FROM course_section cs JOIN term t USING (term_id)
WHERE status LIKE "OPEN" AND course_id IN (SELECT course_id
                                              FROM course
											  WHERE course_name LIKE "Database Management");
											 
/*11*/

SELECT f.f_id
FROM faculty f
WHERE f.f_last IN (SELECT s_last
                   FROM student)
AND f.f_first IN (SELECT s_first
                  FROM student);
				  
/*12*/

SELECT cs.c_sec_id, cs.max_enrl
FROM course_section cs 
WHERE cs.max_enrl = (SELECT MAX(max_enrl)
                      FROM course_section);
					  
/*13*/

SELECT cs.c_sec_id, cs.max_enrl
FROM course_section cs 
WHERE cs.max_enrl != (SELECT MAX(max_enrl)
                      FROM course_section);
					  
/*14*/

SELECT cs.c_sec_id, cs.max_enrl
FROM course_section cs 
WHERE cs.max_enrl < (SELECT AVG(max_enrl)
                      FROM course_section);
					  
/*15*/

SELECT grade, term_id
FROM enrollment e JOIN student s USING(s_id)
JOIN course_section cs ON e.c_sec_id = cs.c_sec_id
WHERE s.s_first LIKE "Sarah" 
AND s.s_last LIKE "Miller" 
AND course_id = (SELECT course_id
FROM course WHERE course_name LIKE "Systems Analysis");

/*16*/

SELECT course_name, course_id
FROM course
WHERE course_id IN(SELECT preq
                   FROM course);
				   
/*17*/

SELECT term_desc
FROM term
WHERE term_id NOT IN (SELECT term_id
                      FROM course_section);
					  
/*18*/

SELECT term_desc
FROM term
WHERE term_id <(SELECT MIN(term_id)
                      FROM course_section);
					  
/*19*/
SELECT s_last, s_first, "STUDENT" as person
FROM student 
UNION
SELECT f_last, f_first, "FACULTY" as person
FROM faculty
ORDER BY 1;