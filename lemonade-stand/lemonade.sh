#!/bin/bash
# Declare PSQL
PSQL="psql -X --username=postgres --dbname=lemonade --tuples-only -c"

# Uncomment truncate next line to refresh database values
# echo $($PSQL "truncate product,transaction,customers")

echo -e "\n~~~ Welcome to my Lemonade Stand ~~~"

MENU(){
if [[ $1 ]]
then echo -e "\n$1"
fi
echo -e "Main Menu\n"
echo -e "1)Purchase lemons\n2)view our sales\n3)exit"
read OPTION

case $OPTION in 
1) PURCHASE ;;
2) VIEW_OUR_SALES ;;
3) EXIT ;;
esac

}
PURCHASE(){
echo -e "Welcome to Purchase"
}
VIEW_OUR_SALES(){
echo -e "View our sales"
}
EXIT(){
    sleep 1
    MENU
}


MENU