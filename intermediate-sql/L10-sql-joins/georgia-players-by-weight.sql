-- https://community.modeanalytics.com/sql/tutorial/sql-joins/
-- Write a query that selects the school name, player name, position, and weight for every player in Georgia, 
--  ordered by weight (heaviest to lightest). 
-- Be sure to make an alias for the table, and to reference all column names in relation to the alias.
select p.school_name, p.player_name, p.position, p.weight
from benn.college_football_players p
where state = 'GA'
order by p.weight desc