#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only --no-align -c"

echo $(( $RANDOM % 1000 + 1 ))

echo -e "\nEnter your username:\n"
read USERNAME

RETURND_USER=$($PSQL "SELECT user_name FROM users WHERE user_name='$USERNAME'")

if [[ -z $RETURND_USER ]]
then
  # IF FIRST TIME
  echo "Welcome, $USERNAME! It looks like this is your first time here."

else
  # IF PLAYED BEFORE
  PLAYED_GAMES=$($PSQL"SELECT COUNT(*) FROM games INNER JOIN USEING(user_id) WHERE user_name='$USERNAME'")
  BEST_GAME=$($PSQL"SELECT MIN(gusses) FROM games INNER JOIN USEING(user_id) WHERE user_name='$USERNAME'")

  echo "Welcome back, $USERNAME! You have played $PLAYED_GAMES games, and your best game took $BEST_GAME guesses."

fi

echo -e "\nGuess the secret number between 1 and 1000:"
read GUSSE