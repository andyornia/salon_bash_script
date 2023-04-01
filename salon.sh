#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -tc"

function MAIN_MENU {
  # echo "Enter a service id"
  $PSQL "select * from services;" | while read serviceid bar servicename
  do
    if [[ $serviceid ]]
    then
      echo "$serviceid) $servicename"
    fi
  done

}

function CHOOSE_MENU {
  read SERVICE_ID_SELECTED
  MENU_EXISTS=$($PSQL "select service_id from services where service_id=$SERVICE_ID_SELECTED;")
  if [[ -z $MENU_EXISTS ]]
  then
    MAIN_MENU
    CHOOSE_MENU
  else
    echo menu item exists, $MENU_EXISTS
  fi
}

MAIN_MENU
CHOOSE_MENU

echo "enter phone number"
read CUSTOMER_PHONE
CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")
if [[ -z $CUSTOMER_ID ]]
then
  echo "enter name"
  read CUSTOMER_NAME
  CUSTOMER_INSERT=$($PSQL "insert into customers (phone, name) values ('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
fi

CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE';")

echo "enter service time"
read SERVICE_TIME
SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED;")
CUSTOMER_NAME=$($PSQL "select name from customers where customer_id=$CUSTOMER_ID;")
APPOINTMENT_INSERT=$($PSQL "insert into appointments (customer_id, service_id, time) values ($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")


echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME." | sed 's/  / /g'