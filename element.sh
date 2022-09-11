#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

ELEMENT(){

  if [[ ! $1 ]]
  then
    echo "Please provide an element as an argument."
  else

    if [[ $1 =~ ^[0-9]+$ ]]
    then
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$1")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$1")
      TYPE=$($PSQL "SELECT types.type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$1")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$1")
      MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$1")
      BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$1")
      echo "The element with atomic number $1 is$NAME ($(echo $SYMBOL | sed -r 's/^ *//g')). It's a$TYPE, with a mass of $(echo $ATOMIC_MASS | sed -r 's/^ *//g') amu.$NAME has a melting point of $(echo $MELTING_POINT | sed -r 's/^ *//g') celsius and a boiling point of $(echo $BOILING_POINT | sed -r 's/^ *//g') celsius."
    elif [[ $1 =~ [a-z]? ]]
    then
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$1' OR name='$1'")
      
      if [[ -z $ATOMIC_NUMBER ]]
      then
        echo "I could not find that element in the database."
      else
        NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
        SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
        TYPE=$($PSQL "SELECT types.type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
        ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number=$ATOMIC_NUMBER")
        echo "The element with atomic number $(echo $ATOMIC_NUMBER | sed -r 's/^ *//g') is$NAME ($(echo $SYMBOL | sed -r 's/^ *//g')). It's a$TYPE, with a mass of $(echo $ATOMIC_MASS | sed -r 's/^ *//g') amu.$NAME has a melting point of $(echo $MELTING_POINT | sed -r 's/^ *//g') celsius and a boiling point of $(echo $BOILING_POINT | sed -r 's/^ *//g') celsius."
      fi
    fi
  fi
}

ELEMENT $1