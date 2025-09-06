-- MySQL-specific commands (remove the next 4 lines for use on other systems)
  drop database if exists FAFD;
  create database FAFD;
  use FAFD;
  set global sql_mode="ONLY_FULL_GROUP_BY";


--   Database Definition for the 
--     F.A.F.D. Master Track
--  (Futuristic Activities in Fancy Disciplines) 

-- DDL Commands (standard)

CREATE TABLE Course (
  CourseId integer PRIMARY KEY,
  Title varchar(80),
  Credits integer NOT NULL DEFAULT '5',
  Year integer DEFAULT 0,
  Professor varchar(30)
);

CREATE TABLE Student (
  Sid integer PRIMARY KEY,
  Name varchar(40),
  Birthdate date,
  City varchar(30),
  Sex char DEFAULT 'm' check( Sex = 'm' or Sex = 'f' )
);

CREATE TABLE Exam (
  Sid integer references Student(SId),
  Cid integer references Course(CourseId),
  Date date NOT NULL,
  Grade integer NOT NULL DEFAULT 18 check( Grade >= 18 and Grade <= 30 ),
  PRIMARY KEY (Sid,Cid)
);


INSERT INTO Course VALUES 
 (1,'Quick Prototyping of Clay Vases ',5,1,'Hurry Potter'),
 (2,'Exaustive Analytical Analysis',10,1,'Annie Dee Tail'),
 (3,'Fast Synthesis of Terse Summaries',10,1,'Don Wastewords'),
 (4,'Reproduction of Extinct Creatures',5,2,'Dany Stormborn'),
 (5,'Applications of Lemonade in Psychiatry',10,2,'Lucy Van Pelt'),
 (6,'Ultrasharp Laser Trichotomy',10,2,'Hairry Bald'),
 (7,'Botanical Nomenclature',2,3,'Umberto Eco'),
 (8,'Optoelectonics in the Copper Age',5,2,'Emmet ''Doc.'' Brown'),
 (9,'Ubiquitous Cathartic Palingenesis',8,3,'Ashly Grey Phoenix'),
 (10,'Symmetry and Palindromes in Phisiology and Flamenco',12,1,'Revilo Oliver & Sara Baras'),
 (11,'Islands or Peninsulas? An Eternal Dilemma',5,2,'Therry May'),
 (12,'Nepotism and Intimidation in Foreign and Internal Affairs',10,3,'Donald Bernasconi'),
 (13,'Blanket-wrapping of large Pumpkins',5,3,'Linus Van Pelt');

INSERT INTO Student VALUES 
 (101,'Sirius Laddie','1992-10-10','Godric''s Hollow','m'),
 (102,'Sean Ever','1989-10-10','Inverness','m'),
 (103,'Dan De Moul','1989-10-01','Johannesburg','m'),
 (104,'Ewan Samore','1992-11-10','Elgin','m'),
 (105,'Nodso Good','1992-09-10','Valletta','m'),
 (106,'Guapo Guarapo','1992-10-10','Pinar del Rio','m'),
 (107,'Viola Violino','1991-10-10','Cremona','f'),
 (108,'Polly Pocket','1990-10-10','Mildendo','f'),
 (109,'Beatriz Delgado','1988-10-10','Lisboa','f'),
 (110,'Elly Phant','1987-10-10','San Diego','f'),
 (111,'Saippua Kivikauppias','2001-10-02','Tampere','f'),
 (112,'Aldeg Reidsigott','1994-03-03','Hamburg','m');

INSERT INTO Exam VALUES   (101, 1,'2011-04-23',18),
 (101, 2,'2008-01-21',22),(101, 3,'2010-03-23',30),
 (101, 4,'2009-04-23',23),(101, 7,'2007-04-23',28),
 (101,10,'2005-04-20',29),(101,12,'2009-01-28',25),
 (103, 1,'2010-04-03',30),(103, 3,'2011-04-02',30),
 (103, 4,'2007-04-23',30),(103, 5,'2009-09-23',30),
 (103, 8,'2011-07-01',30),(103, 9,'2009-04-23',30),
 (103,12,'2009-01-28',30),(104, 2,'2009-04-23',30),
 (104, 3,'2008-12-25',20),(104, 4,'2006-04-23',20),
 (104, 5,'2009-09-23',30),(105, 1,'2009-03-31',18),
 (105, 2,'2009-04-03',19),(105, 4,'2009-04-23',21),
 (105, 6,'2011-08-23',20),(106, 1,'2008-02-23',30),
 (106, 3,'2008-12-25',21),(106, 4,'2009-03-31',26),
 (106, 8,'2011-07-01',24),(106, 9,'2006-04-23',27),
 (107, 2,'2009-05-23',21),(107, 5,'2009-09-23',28),
 (107, 9,'2006-04-23',26),(107,11,'2005-04-23',27),
 (107,12,'2009-01-28',19),(108, 1,'2009-06-23',26),
 (108, 2,'2009-05-23',23),(108, 3,'2008-12-25',24),
 (108, 4,'2009-05-23',24),(108, 6,'2011-01-01',24),
 (108, 8,'2011-07-01',19),(108, 9,'2009-07-11',18),
 (108,10,'2009-04-28',18),(108,13,'2009-04-03',18),
 (109, 2,'2010-04-19',23),(109, 6,'2009-08-06',25),
 (109,11,'2009-09-11',24),(109,13,'2009-01-28',18),
 (110, 2,'2009-05-23',20),(110,13,'2009-04-03',18),
 (111,10,'2009-04-03',18),(112, 1,'2009-04-03',18),
 (112, 2,'2009-04-03',19),(112, 3,'2008-12-25',20),
 (112, 4,'2009-03-31',21),(112, 5,'2007-04-23',22),
 (112, 6,'2009-04-23',23),(112, 7,'2009-03-31',24),
 (112, 8,'2011-07-01',25),(112, 9,'2009-03-31',26),
 (112,10,'2009-03-31',27),(112,11,'2009-03-31',28),
 (112,12,'2009-01-28',29),(112,13,'2009-04-03',30);
