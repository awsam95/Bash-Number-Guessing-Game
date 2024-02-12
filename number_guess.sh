#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only --no-align -c"
SECRET_NUMBER=$(( RANDOM % 1000 + 1 ))

echo -e "\nEnter your username:\n"
read USERNAME

RETURNED_USER=$($PSQL "SELECT user_name FROM users WHERE user_name='$USERNAME'")

if [[ -z $RETURNED_USER ]]; then
  # IF FIRST TIME
  INSERT_USER=$($PSQL "INSERT INTO users(user_name) VALUES ('$USERNAME')")
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here.\n"
else
  # IF PLAYED BEFORE
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games INNER JOIN users USING(user_id) WHERE user_name='$USERNAME'")
  BEST_GAME=$($PSQL "SELECT MIN(gusses) FROM games INNER JOIN users USING(user_id) WHERE user_name='$USERNAME'")

  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses.\n"
fi

# GET USER ID
USER_ID=$($PSQL "SELECT user_id FROM users WHERE user_name='$USERNAME'")

# START PLAYING
echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS

# IF GUESS NOT A NUMBER
if ! [[ $GUESS =~ ^[0-9]+$ ]]; then
  echo "That is not an integer, guess again:"
  read GUESS
else
  # NUMBER OF TRIES 
  TRIES=1
  while [ ! $GUESS -eq $SECRET_NUMBER ]; do
    ((TRIES++))

    # IF GUESS IS LESS THAN NUMBER
    if [[ $GUESS -lt $SECRET_NUMBER ]]; then 
      echo "It's higher than that, guess again:"
    # IF GUESS IS GREATER THAN NUMBER
    else
      echo "It's lower than that, guess again:"
    fi

    read GUESS
  done
fi

# THE CORRECT GUESS
INSERT_GAME=$($PSQL "INSERT INTO games (user_id, gusses) VALUES ($USER_ID, $TRIES)")
echo "You guessed it in $TRIES tries. The secret number was $SECRET_NUMBER. Nice job!"
