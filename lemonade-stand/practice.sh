#!/bin/bash
echo -e "\n~~~ Welcome to the testing environment ~~~\n"

# Declare PSQL
PSQL="psql -X --username=postgres --dbname=lemonade --tuples-only -c"

# Uncomment truncate next line to refresh database values
echo $($PSQL "truncate product,transaction,customers")
# TEST - ask for name
echo -e "\nWhat is your name?"
# TEST - read name from input
read CUSTOMER_NAME
# if customer name is not a valid input
if [[ ! $CUSTOMER_NAME =~ ^[a-zA-Z]+$ ]]
then
# ask for valid name
echo "Please enter a valid name"
else
# select customer name from customers table
TEST_CUSTOMER=$($PSQL "select name from customers")
INSERT_CUSTOMER_NAME=$($PSQL "insert into customers(name) values('$CUSTOMER_NAME')")
# If the name looks like the string below, change it
if [[ $INSERT_CUSTOMER_NAME = 'INSERT 0 1' ]]
then
# Desired output (if name is inserted)
    echo "$CUSTOMER_NAME inserted into customers"
fi

fi