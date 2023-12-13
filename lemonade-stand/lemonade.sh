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
# display available lemons
AVAILABLE_LEMONS=$($PSQL "select product_id from product where available = true order by product_id")
# if not lemons available
if [[ -z $AVAILABLE_LEMONS ]]
then 
    MENU "Apologies, but we are sold out. Come again tomorrow"
else
# display available lemons
    echo -e "\nHere are the available lemons, grouped by type"
    echo "$AVAILABLE_LEMONS" | while read PRODUCT_ID BAR LEMONS
do
    echo "$PRODUCT_ID) $LEMONS LEMONS."
done
echo -e "\nWhich type would you like to buy?"
read LEMON_ID_TO_BUY


fi
}
VIEW_OUR_SALES(){
echo -e "View our sales"
}
EXIT(){
    sleep 1
    MENU
}


MENU