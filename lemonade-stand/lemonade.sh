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
# get contents from csv file | replace /r(carriage returns) with emptylines
cat product.csv | sed -e 's/\r//g' | while IFS="," read LEMONS
do
# select lemons from product
    GET_ROWS=$($PSQL "select count(lemons) from product")
    # if selection is not equal to "lemons" && number of rows is less than 40
        if [[ $LEMONS != 'lemons' && $GET_ROWS -lt 40 ]]
        then
        #insert lemons
            INSERT_LEMONS=$($PSQL "insert into product(lemons) values('$LEMONS')")
            # if variable equals string, reformat echoed string.
                if [[ $INSERT_LEMONS == "INSERT 0 1" ]]
                then
                    echo "$LEMONS inserted into inventory"
                fi
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