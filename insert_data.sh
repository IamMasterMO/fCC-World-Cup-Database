#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
$PSQL "TRUNCATE teams, games, temp RESTART IDENTITY;"
$PSQL "\copy temp(year, round, winner, opponent, winner_goals, opponent_goals) FROM '/home/codeally/project/games.csv' WITH CSV HEADER; "
$PSQL "INSERT INTO teams(name) SELECT DISTINCT winner FROM temp UNION SELECT DISTINCT opponent FROM temp;"
$PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) SELECT temp.year, temp.round, teams1.team_id, teams2.team_id, temp.winner_goals, temp.opponent_goals FROM temp JOIN teams AS teams1 ON temp.winner = teams1.name JOIN teams AS teams2 ON temp.opponent = teams2.name;"
