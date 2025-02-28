#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams, games")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
  
   # insert teams
   TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")

   if [[ -z $TEAM_WINNER_ID ]]
   then
    INSERT_WINNER_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")

    if [[ $INSERT_WINNER_TEAM == "INSERT 0 1" ]]
    then
      echo Inserted team, $WINNER
      TEAM_WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    fi
   fi

   TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")

   if [[ -z $TEAM_OPPONENT_ID ]]
   then
    INSERT_OPPONENT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")

    if [[ $INSERT_OPPONENT_TEAM == "INSERT 0 1" ]]
    then
      echo Inserted team, $OPPONENT
      TEAM_OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    fi
   fi

   # insert games 
   INSERT_GAMES=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $TEAM_WINNER_ID, $TEAM_OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
   if [[ $INSERT_GAMES == "INSERT 0 1" ]]
   then
    echo Inssert succesful, $INSERT_GAMES : $YEAR : $ROUND : $TEAM_WINNER_ID : $TEAM_OPPONENT_ID : $WINNER_GOALS : $OPPONENET_GOALS
   fi
  fi
done