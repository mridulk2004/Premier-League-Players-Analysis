-- PREMIER LEAGUE 2024-25 PLAYERS ANALYSIS
----------------------------------------------------------------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS players;
CREATE TABLE players (
Name VARCHAR(300) PRIMARY KEY,
Weight_in_kg INT,
Height_in_cm INT,
Age INT,
Citizenship VARCHAR(300),
Team VARCHAR(300),
Jersey INT,
Position VARCHAR(250),
Total_Play_Time_in_min INT, 
Average_Play_Time_in_min FLOAT,
Appearances INT,
subIns INT,
foulsCommitted INT,
foulsSuffered INT,
ownGoals INT,
offsides INT,
yellowCards INT,
redCards INT,
goalAssists INT,
shotsOnTarget INT,
totalShots INT,
totalGoals INT,
goalsConceded INT,
shotsFaced INT,
saves INT
);


----------------------------------------------------------------------------------------------------------------------------------------------------------
-- DATA ANALYSIS
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q1.Identify the top 10 goal scorers and analyze their goal efficiency (goals per shot on target).

SELECT 
name,
totalgoals,
shotsontarget,
CASE
WHEN shotsontarget=0 THEN 0
ELSE ROUND(totalgoals::numeric/shotsontarget,3) 
END as goal_efficiency
FROM players
ORDER BY totalgoals DESC
LIMIT 10;


-- HERE WE CAN SEE THAT DESPITE MOHAMED SALAH BEING THE TOP GOAL SCORER OF PREM, CHRIS WOODS HAS THE MOST goal_efficiency IN THE LEAGUE.

----------------------------------------------------------------------------------------------------------------------------------------------------------

--Q2.Analyze which teams have the highest average player age and investigate if it correlates with performance metrics.

SELECT
team,
ROUND(AVG(age),0) AS average_age,
SUM(totalgoals) AS total_goals_scored_by_team,
SUM(goalsconceded) AS total_goals_conceded_by_team,
ROUND(SUM(totalgoals)::numeric/SUM(goalsconceded),2) AS performance
FROM players
GROUP BY team
ORDER BY average_age DESC, performance DESC;

--Newcastle United has the highest average player age of 27 and their performance is fairly well
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q3.Determine the players with the most appearances and study their average play time and impact on the team.

SELECT 
name,
team,
position,
appearances,
totalgoals,
goalsconceded,
saves
FROM players
ORDER BY appearances DESC
LIMIT 15;

-- MOHAMMAD SALAH IS AMONG THE 15 PLAYERS WHO APPEARED IN 37 MATCHES OUT OF 38 MATCGES THIS SEASON WITH HIM BEING THE TOP SCORER
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q4.Find the players committing the most fouls and analyze if they have higher red or yellow card counts.

SELECT
name,
team,
position,
foulscommitTed,
yellowcards,
redcards
FROM players
ORDER BY 4 DESC
LIMIT 15;

-- LIAM DELAP HAS COMMITED THE MOST FOULS (70) WITH 11 YELLOWS AND 0 REDS
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q5.Compare assists provided by midfielders versus forwards across different teams.

SELECT 
team,
position,
SUM(goalassists) AS total_assists
FROM players
WHERE position IN ('Midfielder','Forward')
GROUP BY team, position
ORDER BY team, position;

----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q6.Analyze goalkeepers’ save percentages and identify the best performing goalkeepers.

SELECT 
name,
team,
saves,
appearances,
shotsfaced,
CASE 
WHEN shotsfaced = 0 THEN 0
ELSE ROUND((saves::numeric / shotsfaced) * 100, 2)
END AS save_percentage
FROM players
WHERE 
position = 'Goalkeeper'
AND
appearances > 20
ORDER BY save_percentage DESC
LIMIT 10;

-- MARK FLEKKEN DID THE MOST SAVES BUT ALISSON BECKER HAS MORE SAVE % 
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q7.Identify players with the highest number of offsides and assess their shooting accuracy.

SELECT 
name,
team,
position,
offsides,
totalshots,
shotsontarget,
CASE 
WHEN totalshots = 0 THEN 0
ELSE ROUND((shotsontarget::numeric / totalshots) * 100, 2)
END AS shooting_accuracy
FROM players
ORDER BY offsides DESC;

-- EBERECHI EZE HAS THE HIGHEST NUMBER OF OFFSIDE WITH SHOOTING ACCURACY OF 24.49%
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q8.Explore correlation between player height/weight and number of goals/conceded goals.

SELECT 
width_bucket(height_in_cm, 160, 200,4) AS height_bucket,
ROUND(AVG(totalgoals),2) AS goals_scored,
ROUND(AVG(goalsconceded),2) AS goals_conceded,
ROUND(AVG(weight_in_kg),2) AS weight
FROM players
GROUP BY height_bucket
ORDER BY height_bucket;


----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q8.Find forwards with the best ratio of shots on target to total shots.

SELECT 
name,
team,
position,
shotsontarget,
totalshots,
CASE
WHEN totalshots = 0 THEN 0
ELSE ROUND(shotsontarget::numeric/totalshots,3)
END AS shotsontarget_ratio
FROM players
WHERE 
position = 'Forward'
AND
totalshots > 25
ORDER BY shotsontarget_ratio DESC;

-- STRAND LARSEN HAS THE BEST RATIO
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q9.Analyze substitution patterns: which players have the most sub-ins and how that affects their performance.


SELECT
name,
team,
position,
appearances,
average_play_time_in_min,
subins,
totalgoals,
goalassists,
goalsconceded
FROM players
ORDER BY subins DESC;

-- JACK TAYLOR WAS MOST SUBBED IN PLAYER AND CONCEDED 21 TIMES OUT OF 27
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q10.Identify young players (under 23) with highest average play time and assess their potential impact.

SELECT 
name,
team,
age,
position,
appearances,
 average_play_time_in_min,
totalgoals,
goalassists,
goalsconceded
FROM players
WHERE age < 23
ORDER BY average_play_time_in_min DESC;

-- BART VERBRUGGEN, 22 HAS THE HIGHEST PLAYTIME PLAYING AS STARTING GOALIE FOR BRIGHTON
----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Q11.Analyze players contributing in both scoring and assisting to find best all-round attackers.

SELECT
name,
team,
position,
totalgoals,
goalassists,
totalgoals + goalassists AS total_ga
FROM players
ORDER BY total_ga DESC
LIMIT 15;

-- MOAHAMMAD SALAH WAS THE BEST ALL AROUND ATTACKER WITH THE HIGHEST G+A
----------------------------------------------------------------------------------------------------------------------------------------------------------

--Q12.Calculate total minutes played by each team’s starting XI and evaluate squad rotation strategies.

SELECT 
team,
SUM(total_play_time_in_min) AS total_minutes_played,
COUNT(*) FILTER (WHERE subins = 0) AS assumed_starters
FROM players
GROUP BY team
ORDER BY total_minutes_played DESC;

----------------------------------------------END------------------------------------------------------------------------------------------------------------

