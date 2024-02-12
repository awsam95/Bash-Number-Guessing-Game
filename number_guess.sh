#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only --no-align -c"
SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))
echo -e "\nEnter your username:\n"
read USERNAME

RETURND_USER=$($PSQL "SELECT user_name FROM users WHERE user_name='$USERNAME'")

if [[ -z $RETURND_USER ]]
then
  # IF FIRST TIME
  INSERT_USER=$($PSQL "INSERT INTO users(user_name) VALUES ('$USERNAME')")
  echo "Welcome, $USERNAME! It looks like this is your first time here."

else
  # IF PLAYED BEFORE
  GAMES_PLAYED=$($PSQL"SELECT COUNT(*) FROM games INNER JOIN USEING(user_id) WHERE user_name='$USERNAME'")
  BEST_GAME=$($PSQL"SELECT MIN(gusses) FROM games INNER JOIN USEING(user_id) WHERE user_name='$USERNAME'")

  echo "Welcome back, $USERNAME! You have played $PLAYED_GAMES games, and your best game took $GAMES_PLAYED guesses."

fi

# START PLAYING
echo -e "\nGuess the secret number between 1 and 1000:"
read GUSSE

# IF GUSSE NOT NUMBER
if [[ ! $GUSSE =~ ^[0-9]+$ ]]
then
  echo "That is not an integer, guess again:"

else
  # IF GUSSE GRATER THEN NUMBER
  if [[ $GUSSE -gt $SECRET_NUMBER ]]
  then 
    echo "It's higher than that, guess again:"

  # IF GUSSE LESS THEN NUMBER
  elif [[ $GUSSE -lt $SECRET_NUMBER ]]
  then
    echo "It's lower than that, guess again:"

  else
  # THE CORRECT GUSSE
  echo "You guessed it in <number_of_guesses> tries. The secret number was $SECRET_NUMBER. Nice job!"
  
  fi
fi

