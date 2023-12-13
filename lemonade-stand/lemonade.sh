#!/bin/bash
echo -e "\n~~~ Welcome to my Lemonade Stand ~~~\n"
# Declare PSQL
PSQL="psql -X --username=postgres --dbname=lemonade --tuples-only -c"

# Uncomment truncate next line to refresh database values
# echo $($PSQL "truncate product,transaction,customers")





MENU(){
echo -e "\nMain Menu\n?"
echo -e "\n1)Purchase lemons\n2)view our sales\n3)exit"
}
PURCHASE(){
echo -e "\nWelcome to Purchase"
}
VIEW_OUR_SALES(){
echo -e "\nView our sales"
}