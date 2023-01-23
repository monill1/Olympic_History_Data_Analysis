SELECT * FROM olympics_history

-- 1. How many olympics games have been played?
SELECT count(distinct(games)) FROM olympics_history;

-- 2. List down all Olympics games held so far.
SELECT DISTINCT(year) as YEAR, season, city
FROM olympics_history
ORDER BY YEAR;

-- 3. Mention the total no of nations who participated in each olympics game?

WITH all_countries as
  (SELECT oh.games, nr.region
  FROM olympics_history oh
  JOIN olympics_history_noc_regions nr ON nr.noc = oh.noc
  group by games, nr.region)
SELECT games, count(region) as total_countries
FROM all_countries
group by games
order by games;

-- 4. Which year saw the highest and lowest no of countries participating in olympics?

with all_countries as
	  (select games, nr.region
	  from olympics_history oh
	  join olympics_history_noc_regions nr ON nr.noc=oh.noc
	  group by games, nr.region),
  tot_countries as
	  (select games, count(1) as total_countries
	  from all_countries
	  group by games)
select distinct
concat(first_value(games) over(order by total_countries)
, ' - '
, first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
concat(first_value(games) over(order by total_countries desc)
, ' - '
, first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
from tot_countries
order by 1;

