#!/bin/bash
# Declare PSQL
PSQL="psql -X --username=postgres --dbname=lemonade --tuples-only -c"


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

# insert lemons
# Obtain contents from csv file, replace all instances of \r carriage
cat product.csv | sed -e 's/\r$//g' | while IFS="," read LEMONS
do
    GET_ROWS=$($PSQL "select count(product_id) from product")
if [[ $LEMONS != 'lemons' && $GET_ROWS -lt 40 ]]
then
    INSERT_LEMONS=$($PSQL "insert into product(lemons) values('$LEMONS')")
    # if [[ $INSERT_LEMONS == "INSERT 0 1" ]]
    # then
    #     echo Inserted into lemons, $LEMONS
    # fi
 fi   
done
}


VIEW_OUR_SALES(){
echo "View our sales"
}


EXIT(){
    echo "Thank you for visiting the shop!"
}


MENU