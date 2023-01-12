CREATE TABLE addresses(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL
);


CREATE TABLE categories(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(10) NOT NULL
);


CREATE TABLE employees(
id INT PRIMARY KEY AUTO_INCREMENT,
first_name	 VARCHAR(30) NOT NULL,
last_name	 VARCHAR(30) NOT NULL,
age INT NOT NULL, 
salary DECIMAL(10,2) NOT NULL,
job_title VARCHAR(20) NOT NULL,
happiness_level CHAR(1) NOT NULL , # TO CHECK IT!!!
#Can be ‘L’- Low, ‘N’ - Normal or ‘H’- High	NULL is NOT permitted.
);


CREATE TABLE teams(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(40) NOT NULL,
office_id	INT NOT NULL,
leader_id	INT UNIQUE NOT NULL,
CONSTRAINT fk_teams_offices
FOREIGN KEY(`office_id`) REFERENCES offices(`id`),
CONSTRAINT fk_teams_leader
FOREIGN KEY (`leader_id`) REFERENCES employees(`id`)
);


CREATE TABLE offices(
id INT PRIMARY KEY AUTO_INCREMENT,
workspace_capacity	INT NOT NULL,
website	VARCHAR(50) NOT NULL,
address_id INT NOT NULL,
CONSTRAINT fk_offices_addresses
FOREIGN KEY (`address_id`) REFERENCES addresses(`id`)
);



CREATE TABLE games(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(50) NOT NULL UNIQUE,
description TEXT NOT NULL,
rating FLOAT DEFAULT  5.5 NOT NULL,
budget DECIMAL(10,2) NOT NULL,
release_date DATE ,
team_id INT NOT NULL,
CONSTRAINT fk_games_teams
FOREIGN KEY (`team_id`) REFERENCES teams(`id`)
);


CREATE TABLE games_categories(
game_id	INT NOT NULL,
category_id INT NOT NULL,
CONSTRAINT pk
PRIMARY KEY (game_id, category_id),
CONSTRAINT fk_games_categories_games
FOREIGN KEY (`game_id`) REFERENCES games(`id`),
CONSTRAINT fk_games_categories_categories
FOREIGN KEY (`category_id`) REFERENCES categories(`id`)
);

################################################################
The bosses urgently want to announce 9 new games and because there is no time, the developers decide not to waste time thinking about details but to announce something as soon as possible.
You will have to insert records of data into the games table, based on the teams table. 
For all teams with id between 1 and 9 (both inclusive), insert data in the games table with the following values:
•	name:
o	 the name of the team but reversed
o	 all letters must be lower case
o	 omit the starting character of the team's name
	 Example: Team name – Thiel -> leih
•	rating – set it to be equal to the team's id
•	budget – set it to be equal to the leader's id multiplied by 1000
•	team_id – set it to be equal to the team's id

INSERT INTO games (name,rating,budget,team_id)

Select
	LEFT((LOWER(REVERSE(t.name)))),CHAR_LENGTH(t.name)-1),
	t.id,
	leader_id*1000,
	t.id
FROM teams AS t
WHERE t.id BETWEEN 1 AND 9;

###########################################################
After a good work in recent months, management has decided to raise the salaries of all young team leaders.
Update all young employees (only team leaders) with age under 40(exclusive) and increase their salary with 1000. 
Skip the employees with salary over 5000(inclusive). Their salaries are already high.

UPDATE employees AS emp
	SET emp.salary=emp.salary+1000
WHERE emp.age<40 And
	emp.id=teams.leader_id And     #To check it!!!!!
	emp.salary<5000;

###################################
	After a lot of manipulations on our base, now we must clean up.
Delete all games from table games, which do not have a category and release date. 


Delete g
From games AS g
left join games_categories as gc on g.id=gc.game_id 
where g.release_date IS NULL AND  gc.game_id is null

####################################

Select 
 first_name,
	last_name,
	age,
	salary	,
	happiness_level
from employees
order by salary,id

##########################
Select
	t.name As team_name,
	adr.name As address_name,
	Char_length(adr.name) As count_of_characters
From teams As t  left join offices as off on t.office_id=off.id
left join addresses As adr on off.address_id=adr.id
where off.website is not null
order by t.name,adr.name
#############################3

Select
g.name ,
g.release_date,
CONCAT(Left(g.description ,10),'...')  AS summary,
 (CASE
            WHEN MONTH(g.`release_date`) between 1 and 3 THEN 'Q1'
WHEN MONTH(g.`release_date`) between 4 and 6 THEN 'Q2'
WHEN MONTH(g.`release_date`) between 7 and 9 THEN 'Q3'
WHEN MONTH(g.`release_date`) between 10 and 12 THEN 'Q4'
        END) AS ` quarter`,
t.name AS team_name
FROM games as g
Left Join teams as t On g.team_id=t.id
Where
(Month(g.release_date))%2=0 #може MOD(x,y)
And
g.name LIKE '%2'
AND
YEAR(g.release_date)=2022
ORDER BY quarter;
###################################
DELIMITER $$
CREATE FUNCTION udf_game_info_by_name1 (game_name VARCHAR (20))
RETURNS text deterministic

BEGIN
    DECLARE info text;
      SET info := (  
	SELECT#The "game_name" is developed by a "team_name" in an office with an address "address_text"
    Concat("The ",g.name," is developed by a ",t.name," in an office with an address ",adr.name)
        
	from games as g left join teams as t on g.team_id=t.id
left join offices as off on t.office_id=off.id
left join addresses as adr on off.address_id=adr.id
	WHERE g.name=game_name);

return info;
END
$$ 




	

