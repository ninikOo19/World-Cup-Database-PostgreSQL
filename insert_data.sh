#! /bin/bash
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE games,teams")

names_array=()
unique_names=()
while IFS="," read -r _ _ winner opponent _; do
  names_array+=("$winner")
  names_array+=("$opponent")
done < <(tail -n +2 games.csv)  # Skip the first line

for name in "${names_array[@]}"; do
  if ! [[ " ${unique_names[@]} " =~ " $name " ]];
  then  
    unique_names+=("$name")
  fi
done
# for name in "${unique_names[@]}"; do  # Loop to print each name
#   echo "$name"
# done
for name in "${unique_names[@]}";
do
  INSERT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$name')")
done



tail -n +2 games.csv | while IFS="," read year round win opp wingo oppgo
do
  winner_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$win'")
  opponent_id=$($PSQL "SELECT team_id FROM teams WHERE name = '$opp'")
  
  RESULT=$($PSQL"INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ('$year', '$round', '$winner_id', '$opponent_id', '$wingo', '$oppgo')")

done



