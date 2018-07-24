-- https://community.modeanalytics.com/sql/tutorial/sql-inner-join/
-- Write a query that displays player names, school names and conferences for schools in the 
--  "FBS (Division I-A Teams)" division.
select p.player_name, p.school_name, t.conference
from benn.college_football_players p
join benn.college_football_teams t on   p.school_name = t.school_name
where t.division = 'FBS (Division I-A Teams)'