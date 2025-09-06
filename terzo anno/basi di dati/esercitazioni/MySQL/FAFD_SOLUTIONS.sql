
/*
STUDENT ( SId, Name, Birthdate, City, Sex )

COURSE ( CourseId, Title, Credits, Year, Professor )     
  Year is 1 for exams of the 1st year, 2 for exams of the 2nd year, ...

EXAM ( Sid, CId, Date, Grade ) 
  Grade is between 18 and 30
*/

-- --------------------------------------------------------------------------------
-- 1. Id of the students who got at least one 30

select distinct sid 
from exam
where grade = 30;


-- --------------------------------------------------------------------------------
-- 2. Id, Name and City of origin of the students who got at least one 30

select distinct s.sid, name, city
from student s join exam e on s.sid = e.sid
where grade = 30;

-- alternatively:

select sid, name, city
from student
where sid in ( select sid 
               from exam 
               where grade = 30);


-- --------------------------------------------------------------------------------
-- 3. The birthdate of the youngest student

select max(Birthdate)
from student;


-- --------------------------------------------------------------------------------
-- 4. The GPA of the student with ID = 107

select avg(grade)
from exam
where sid=107;


-- --------------------------------------------------------------------------------
-- 5. The GPA of each course

select cid, avg(grade)
from exam
group by cid;

-- or, better in terms of readability, at the cost of some more code:

select cid, avg(grade), Title, Professor
from exam join course on cid=courseid
group by cid;


-- --------------------------------------------------------------------------------
-- 6. The number of Credits acquired by each student

select sid, sum(credits)
from exam join course on cid = courseid
group by sid; 

-- and, for better readability:

select s.sid, sum(credits) as totCredits, Name
from student s join exam e on s.sid=e.sid join course on cid = courseid
group by s.sid; 

/* the previous solution is quite naive, as it does not include students who didn't 
   pass any exam (they should be included in the list with 0 credits). 
   It is the case of poor Sean Ever! We can add them in several ways... */

-- Adding the tuples relative to the students with no exams by means of a union
-- with the result of an ad-hoc query that extracts them :

select s.sid, sum(credits) as totCredits, Name
from student s join exam e on s.sid=e.sid join course on cid = courseid
group by s.sid 
 union
select sid, 0 as totCredits, Name
from student
where sid not in ( select sid 
                   from exam );

-- or with an outer join 

select s.sid, sum(credits) as totCredits, Name
from course join exam e on cid = courseid
       right join student s on e.sid = s.sid
group by s.sid; 

/* (but then there is a NULL value... as the sum of a null value is of course a null.
   This can be fixed (as we want to show a 0) using the coalesce() function 
   (it returns the first non-null value in the list of its arguments) */

select s.sid, coalesce(sum(credits), 0) as totCredits, Name
from course join exam e on cid = courseid
       right join student s on e.sid = s.sid
group by s.sid; 

/* or one could go creative and nest a query in the select clause... which allows
   to avoid the outer join (but not coalesce()). This can only be done as the query 
   nested in the select clause is guaranteed to return exactly one value */

select S.sid, ( select coalesce(sum(credits), 0)
                from course join exam e 
                      on cid = courseid
                where sid = S.sid ) as totCredits, Name
from student S;


-- --------------------------------------------------------------------------------
-- 7. The (weighted) GPA of each student

select sid, sum(grade*credits)/sum(credits) as weightedGpa
from exam join course on cid = courseid
group by sid; 

-- or, in order to compare the weighted and non-weighted GPAs:

select sid, sum(grade*credits)/sum(credits) as weightedGpa, avg(grade) as nonWgpa
from exam join course on cid = courseid
group by sid; 

-- and, in order to also include students with no exams:

select sid, sum(grade*credits)/sum(credits) as weightedGpa, avg(grade) as nonWgpa
from student natural left join exam natural left join course
group by sid; 



-- --------------------------------------------------------------------------------
-- 8a. Students who passed at least 2 exams [just the Id]

-- two ugly, inefficient, algebra-inspiered solutions are:

select distinct e1.sid
from exam e1 join exam e2 on e1.sid=e2.sid
where e1.cid <> e2.cid;

select distinct sid
from exam e
where sid in ( select sid
               from exam
			   where cid <> e.cid );
               
-- while the one that better embodies the spirit of SQL is:              

select sid
from exam
group by sid
having count(*) > 1;

-- the reason why this is **much** better than the previous ones is that it scales
-- gracefully with the threshold number... just think of expressing the 
-- same query asking the passed exams to be at least four, or ten...


-- --------------------------------------------------------------------------------
-- 8b. Students who passed at least 2 exams [also the Name]

select sid, Name
from exam natural join student
group by sid
having count(*) > 1;



-- --------------------------------------------------------------------------------
-- 9a. Students who passed less than 5 exams [just the Id]

select sid, count(*) as PassedExams
from exam
group by sid
having count(*) < 5;

-- suspance... this solution is incomplete...


-- --------------------------------------------------------------------------------
-- 9b. Students who passed less than 5 exams [also the Name]

select sid, count(*) as PassedExams, Name
from exam natural join student
group by sid
having count(*) < 5;

-- Hey, once more we almost forgot about those who did not pass any exam...

select sid, count( cid ) as PassedExams, Name
from exam natural right join student
group by sid
having count( cid ) < 5;

/* please note that I use count( cid ), that only counts non-null values, because
   count(*) would erroneously count 1 also for the null value corresponding to
   the tuple of the student with no exams */



-- --------------------------------------------------------------------------------
-- 10a / 10b. Students who passed exactly 4 exams [a. just the Id  b. also the Name]

select sid
from exam
group by sid
having count(*) = 4;

select sid, Name
from exam natural join student
group by sid
having count(*) = 4;



-- --------------------------------------------------------------------------------
-- 11. For each student, the number of passed exams (including those with 0 exams!)

select sid, count( cid ) as Passed, Name
from student natural left join exam
group by sid;

-- or

select sid, count(*) as Passed, Name
from student natural join exam
group by sid
  union
select sid, 0 as pippo, Name
from student
where sid not in ( select sid 
                   from exam );

-- or

select sid, ( select count(*)
              from exam
              where sid = S.sid ) as Passed, Name
from student S
group by sid;



-- --------------------------------------------------------------------------------
-- 12. Students with a GPA that is above 24.5

select sid, sum(grade*credits)/sum(credits) as weightedGpa, Name
from exam join course on cid = courseid natural join student
group by sid
having sum(grade*credits)/sum(credits) > 24.5; 



-- --------------------------------------------------------------------------------
-- 13. The “regular” students, i.e., those with a delta of maximum 3 points 
--     between their worst and best grade 

select sid, max(grade)-min(grade)
from exam
group by sid
having max(grade)-min(grade) <= 3; 

/* however, the degree of regularity depends on the number of exams... students with 
   one exam (like Saippua Kivikauppias) are necessarily regular!
   In order to better appreciate teh result, therefore, we can include more details: */

select sid, max(grade) as max, min(grade) as min, count(*) as num,
       max(grade)-min(grade) as delta, Name
from exam natural join student
group by sid
having max(grade)-min(grade) <= 30
order by delta asc, num desc, max asc; 



-- --------------------------------------------------------------------------------
-- 14. The (weighted) GPA of each student who passed at least 5 exams 
-- (statistically meaningful)

select sid, sum(grade*credits)/sum(credits) as weightedGpa, Name
from exam join course on cid = courseid natural join student
group by sid
having count(*) > 4; 



-- --------------------------------------------------------------------------------
-- 15.  The (weighted) GPA for each year of each student who passed at least 5 exams
--      More precisely: "who passed at least 5 exams overall", not "5 per year"

select sid, year, sum(grade*credits)/sum(credits) as weightedGpa, Name
from exam join course on cid = courseid natural join student
where sid in  ( select sid
                from exam 
                group by sid
                having count(*) >= 5 )
group by sid, year; 

-- or, passing a binding to the nested query :

select sid, year, sum(grade*credits)/sum(credits) as weightedGpa, Name
from exam join course on cid = courseid natural join student S
where 5 <= ( select count(*)
             from exam 
             where sid = S.sid)
group by sid, year; 

-- It is FUNDAMENTAL to realize that the following version is WRONG :

select sid, year, sum(grade*credits)/sum(credits) as weightedGpa, Name
from exam join course on cid = courseid natural join student
group by sid, year
having count(*) >= 5; 

-- as it answers to the other interpretation (GPA for each year of each student who 
-- passed at least 5 exams in the year). In the sample database we only have five
-- courses in year 2, and only one student who passed them all, while there are six
-- students who passed at least 5 exams overall



-- --------------------------------------------------------------------------------
-- 16. Students who never got more than 21

select *
from student
where sid not in ( select sid
                   from exam
                   where grade > 21 );

-- Note that Sean Ever is included even if he passed 0 exams.. is this correct?
-- Oh, how tricky natural languages are, and how reassuringly unambiguous the artificial ones...

-- or, if we only want to consider students with some exams:

select sid
from exam
group by sid
having max(grade) <= 21;



-- --------------------------------------------------------------------------------
-- 17. Id and name of the students who passed exams for a total amount of at least
--     20 credits and never got a grade below 28

-- following both the approaches of the previous query:

select sid, Name
from student S
where 20 <= ( select sum(credits)
              from exam join course on cid=courseid
              where sid = S.sid )
  and sid not in ( select sid
                   from exam
                   where grade < 28 );

-- if we observe that no student without exams can be included, we realize that the 
-- alternative version is better under all perspectives:

select sid, Name
from exam join course on cid=courseid natural join student
group by sid
having sum(credits) >= 20 and min(grade) >= 28;



-- --------------------------------------------------------------------------------
-- 18. Students who got the same grade in two or more exams

select sid, Name
from exam natural join student
group by sid
having count(distinct grade) < count(*);

-- or, if we want to show all the doubled grades, and how many times they got them:

select sid, Name, grade, count(*) as howmanytimes
from exam natural join student
group by sid, grade
having count(*) > 1
order by sid, howmanytimes desc;



-- --------------------------------------------------------------------------------
-- 19. Students who never got the same grade twice

-- we can build on the previous query considering that these guys are just the complement! 

select sid, Name 
from student 
where sid not in ( select sid
                   from exam natural join student
                   group by sid
                   having count(distinct grade) < count(*) );

-- or we can just change the predicate in the having clause. PLEASE NOTE that these
-- two versions are not equivalent, for the same usual reason...

select sid, Name
from exam natural join student
group by sid
having count(distinct grade) = count(*);


-- or we can complement w.r.t. the opposite condition, identifying the 
-- students with "double" grades

select sid, Name
from student
where sid not in ( select sid 
                   from exam
                   group by sid, grade
                   having count(*) > 1 );


-- --------------------------------------------------------------------------------
-- 20. Students who always got the very same grade in all their exams

select sid, Name
from exam natural join student
group by sid
having count(distinct grade) = 1;

-- or, more creatively:

select sid, Name
from exam natural join student
group by sid
having min(grade) = max(grade);

/* What if we want to also show the grade? The constraint on the unicivocity of the 
   values prevent us from adding "grade" to the target list, if the "ONLY_FULL_GROUP_BY"
   mode is enabled... even if the value for the selected groups is *actually* unique!! 
   The simplest solution to this syntactic restriction is to extract an aggregate value
   of the grade, which is always syntactically ok. max, min and avg are equally apt */

select sid, Name, max(grade) as TheOnlyGradeEver
from exam natural join student
group by sid
having count(distinct grade) = 1;



-- --------------------------------------------------------------------------------
-- 21. The name of the youngest student

select Name 
from student
where Birthdate = ( select max(Birthdate)
                    from student );



-- --------------------------------------------------------------------------------
-- 22. Students who got all possible different grades

select sid, Name
from exam natural join student
group by sid
having count(distinct grade) = ( select count(distinct grade) 
                                 from exam );

-- or, in a less intuitive (but equivalent) way:

select sid, Name
from student S
where not exists ( select *
                   from exam
                   where grade not in ( select grade 
                                        from exam
                                        where sid = S.sid ));

-- The sulutions above assume that all grades have been given at least once in "history".
-- A reasonable assumption, that makes the formulation independent of any a-priori assumption 
-- on the grading system (min max and variety of grades)



-- --------------------------------------------------------------------------------
-- 23. Students who never passed any exam

select Name 
from student
where sid not in ( select sid
                   from exam );

-- or, if you like outer joins better than nested queries...

select Name
from student s left join exam e on s.sid = e.sid
where e.sid is null;

-- "cid is null" would do as well, just like "date is null"... 


-- --------------------------------------------------------------------------------
-- 24. Students who never got an 18

select Name 
from student
where sid not in ( select sid
                   from exam 
                   where grade = 18 );


-- --------------------------------------------------------------------------------
-- 25. Code and Title of the courses with the minimum number of credits

select CourseId, Title, credits
from course
where credits = ( select min(credits)
                  from course );



-- --------------------------------------------------------------------------------
-- 26. Code and Title of the courses of the first year with minimum number of credits

select CourseId, Title, credits
from course
where year = 1 
  and credits = ( select min(credits)
                  from course
                  where year = 1 );



-- --------------------------------------------------------------------------------
-- 27. Code and Title of the courses with the minimum number of credits of each year

select CourseId, Title, year, credits
from course C
where credits = ( select min(credits)
                  from course
                  where year = C.year )
order by year;

-- - Or without passing of bindings

select CourseId, Title, year, credits
from course
where (year,credits) = ( select year, min(credits)
                         from course
                         group by year )
order by year;



-- --------------------------------------------------------------------------------
-- 28. Id and Name of the students who passed more exams from the second year than  
--     exams from the first year

-- 28a.
select sid, Name
from exam e natural join student join course on cid = courseid
where year = 2
group by sid
having count(*) > ( select count(*) 
                    from exam join course on cid = courseid
                    where year = 1
                      and sid = e.sid );

/* Would it be the same if we asked for exams of year 1 in the outer query and exams 
 of year 2 in the nested query (using the "<" comparison)?
 NO, because I would restrict the result to those students who have at least one exam
 from year 1! Instead, students who passed 0 exams in the year 1 (and have at least one 
 exam in year 2) SHOULD BE part of the result.*/

-- If we want to also include the number of exams from each year, the simplest way
-- is to define a view

create view passed_exams_per_year( si, ye, num ) as
  select sid, year, count(*) 
  from exam join course on cid = courseid
  group by sid, year;

-- 28b.
select sid, Name, y2.num as Ex_Y2, y1.num as ExY1
from student join passed_exams_per_year y1 on y1.si = sid
       join passed_exams_per_year y2 on y2.si = sid
where y1.ye = 1 and y2.ye = 2
  and y1.num < y2.num;

/* PLEASE NOTE that the queries above are NOT EQUIVALENT, and more precisely
   the second one (28b.) is (intentionally, "subtly"...) WRONG!! why??
 
 a HINT: the following one, instead, includes the counts and is OK. */
 
-- 28c.
select sid, Name, y2.num as Ex_Y2 
from student join passed_exams_per_year y2 on y2.si=sid
where y2.ye = 2 
  and y2.num > ( select count(*)
                 from exam join course on cid = courseid
                 where year = 1 and sid = y2.si );

/* Be careful: if 28c had been written using the passed_exams_per_year view in both the
   outer and the inner query, it would have also been wrong: the view does not include students
   with no exams in year 1, thus I would exclude cases where #exams in year 2 is
   trivially greater than #exams in year 1 (i.e., zero)*/

-- Another way to fix 28b. is to re-define the view as follows:

drop view if exists passed_exams_per_year;
create view passed_exams_per_year( si, ye, num ) as
  select sid, Ylist.y, ( select count( * )
                         from exam join course on cid=courseid
                         where sid=S.sid and year=Ylist.y ) as num
  from student S, ( select distinct year as y
                    from course ) as Ylist;

/* This version of the view starts from the cartesian product of all years and
   all students, and comoutes the counts including 0s whenever no exams were
   passed for that specific year */ 

/* There is no student in our sample database who passed no exams of the first year 
   but passed some exams from the second year... and still, of course, query 28b.
   is WRONG! Please always keep in mind that the correctness of a query or the 
   equivalence of two queries CANNOT be decided based on the results on some dataset */

/* Another quite "twisted" way is to left join the student table twice with the passed_exams_per_year view 
(one for year 1 and one for year 2) and to specify the cases where the tuple from the view P1
could have null year and null number of exams.*/

select * 
from student
    left join (select * from passed_exams_per_year where ye = 1) P1 on sid = P1.si
    left join (select * from passed_exams_per_year where ye = 2) P2 on sid = P2.si
where P2.ye = 2 
and ((P1.ye = 1 and P2.num>P1.num) or (P1.ye is null and P1.num is null));


-- --------------------------------------------------------------------------------
-- 29. The student(s) with best weighted GPA

-- It might have been useful to define since the beginning two views with the gpa 
-- of each course and the weighted gpa of each course...

drop view if exists gpa_courses;
create view gpa_courses( ci, gpa ) as
  ( select cid, avg(grade)
	from exam
	group by cid ); 

drop view if exists wgpa_students;
create view wgpa_students( si, wgpa ) as
  ( select sid, sum(grade*credits)/sum(credits)
	from exam join course on cid = courseid
	group by sid ); 



-- --------------------------------------------------------------------------------
-- 30. The course with the worst GPA

select *
from gpa_courses
where gpa = ( select min(gpa)
              from gpa_courses );

-- I am reusing the view just for the sake of simplicity - one could also write:

select cid, avg(grade)
from exam
group by cid
having avg(grade) <= ALL ( select avg(grade)
		                   from exam
	                       group by cid );

-- And of course, on order to better understand the result (that is made more readable):

select ci, gpa, Title, Professor
from gpa_courses join course on courseid=ci
where gpa = ( select min(gpa)
              from gpa_courses );



-- --------------------------------------------------------------------------------
-- 31. Students with a GPA that is at least 2 points above the overall college GPA

select sid, wgpa, Name, City 
from student join wgpa_students on sid=si
where wgpa >= 2 + ( select avg(wgpa)
                    from wgpa_students );



-- --------------------------------------------------------------------------------
-- 32. For each student, their best year in terms of GPA

create view gpaPerYear ( si, ye, wg ) as
  ( select sid, year, sum(grade*credits)/sum(credits)
	from exam join course on cid = courseid
	group by sid, year ); 

select sid, name, ye as BestYear, wg as w_gpa
from gpaPerYear G join student on sid=si
where wg >= ALL ( select wg 
                  from gpaPerYear
                  where si = G.si );



-- --------------------------------------------------------------------------------
-- 33. The most “regular” students, i.e., those with the minimum delta between 
--     their worst and best grade

select sid, Name, max(grade)-min(grade) as delta
from student natural join exam
group by sid
having delta >= ALL ( select max(grade)-min(grade)
                      from exam
                      group by sid );

/* note that once an expression is given a name (e.g., "delta" in this example),
   it is possible to use the alias instead of the expression throughout the query
   (e.g., in the having clause, instead of repeating "max(grade)-min(grade)" */



-- --------------------------------------------------------------------------------
-- 34. Students with a weighted GPA that is above the “average weighted GPA”
--     of all the students

select sid, name, wgpa
from student join wgpa_students on sid=si
where wgpa > ( select avg(wgpa)
               from wgpa_students )
order by wgpa desc ;

/* Here a VIEW is strictly necessary to answer the query (we refer to query 7), as 
   there is no other way to compute the average of another aggregate. Nesting the
   view in the from clause, as in the following proposed alternative, is nothing 
   but actually creating a view, but embedding it within the query and making it
   unusable by future queries. No need to say: the former is **much** better. */

select s.sid, name, wg
from student s join ( select sid, sum(grade*credits)/sum(credits) as wg
	                  from exam join course on cid = courseid
	                  group by sid  ) as g on s.sid=g.sid
where wg > ( select avg(wgpa)
             from ( select sum(grade*credits)/sum(credits) as wgpa
	                from exam join course on cid = courseid
	                group by sid ) as g ) 
order by wg desc ;



-- --------------------------------------------------------------------------------
-- 35. Students who got all their grades in strictly non-decreasing order over time
--      (i.e., never got a grade worse than a previous one)

select *
from student
where sid not in ( select e1.sid
                   from exam e1 join exam e2 on e1.sid=e2.sid
				   where e1.date  < e2.date 
                     and e1.grade > e2.grade );
                     
-- Please note that the previous query also extracts students with 0 and 1 exams.
--   A simple join with exam fixes the issue of the students with no exams:

select distinct S.*
from student S natural join exam 
where sid not in ( select e1.sid
                   from exam e1 join exam e2 on e1.sid=e2.sid
				   where e1.date  < e2.date 
                     and e1.grade > e2.grade );

-- One may also want to discard students with just 1 exam:

select S.*, count(*)
from student S natural join exam 
where sid not in ( select e1.sid
                   from exam e1 join exam e2 on e1.sid=e2.sid
				   where e1.date  < e2.date 
                     and e1.grade > e2.grade )
group by sid
having count(*) > 1;