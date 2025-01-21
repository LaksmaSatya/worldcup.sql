#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOAL OPP_GOAL
do 
  #insert unique team into table
  if [[ $YEAR != "year" ]]
  then
    #add team from winner colomn first
    INSERT_TEAM_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
    if [[ $INSERT_TEAM_WINNER_RESULT == "INSERT 0 1" ]]
    then 
      echo Inserted into teams table, $WINNER
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOAL OPP_GOAL
do 
  if [[ $YEAR != "year" ]]
  then
    INSERT_TEAM_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
    if [[ $INSERT_TEAM_OPPPONENT_RESULT == "INSERT 0 1" ]]
    then 
      echo Inserted into teams table, $OPPONENT
    fi
  fi
done

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WIN_GOAL OPP_GOAL
do
  if [[ $YEAR != "year" ]]
  then
    #insert data into games table
    #get winner_id
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
    #insert data
    INSERT_DATA_GAMES_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$WINNER_ID,$OPPONENT_ID,$WIN_GOAL,$OPP_GOAL)")
  fi
done 
