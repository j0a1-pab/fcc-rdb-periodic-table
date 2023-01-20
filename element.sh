#! /bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --no-align --tuples-only -c"

if [[ $1 ]]
then
  # if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    # query database for element by number
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number = $1")
    
    if [[ -z $ELEMENT_RESULT ]]
    then
      echo -e "I could not find that element in the database."
    else
      echo $ELEMENT_RESULT | while IFS="|" read ID NUMBER SYMBOL NAME MASS MP BP TYPE
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
      done
    fi

  # if argument is a string that starts with a capital letter
  elif [[ $1 =~ ^[A-Z]?[a-z]+?$ ]]
  then
    # query database for element by symbol or name
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE (symbol = '$1' OR name = '$1')")

    if [[ -z $ELEMENT_RESULT ]]
    then
      echo -e "I could not find that element in the database."
    else
      echo $ELEMENT_RESULT | while IFS="|" read ID NUMBER SYMBOL NAME MASS MP BP TYPE
      do
        echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
      done
    fi

  else 
    echo -e "I could not find that element in the database."
  fi

else 
  echo Please provide an element as an argument.
fi

