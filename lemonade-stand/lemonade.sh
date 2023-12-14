#!/bin/bash
# Declare PSQL
PSQL="psql -X --username=postgres --dbname=lemonade --tuples-only -c"


echo -e "\n~~~ Welcome to my Lemonade Stand ~~~"

INSERT_INVENTORY(){
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
MENU(){
# get num of rows
MAX_ROWS=$($PSQL "select count(lemons) from product")
if [[ ! $MAX_ROWS -gt 1 ]]
then
    INSERT_INVENTORY
    MENU

else

if [[ $1 ]]
then echo -e "\n$1"
fi
echo -e "\nMain Menu\n"
echo -e "1)Purchase lemons\n2)view our sales\n3)exit"
read OPTION

case $OPTION in 
1) PURCHASE ;;
2) VIEW_OUR_SALES ;;
3) EXIT ;;
esac

fi
}

PURCHASE(){
echo -e "Welcome to Purchase"
# What is your name?
sleep 1
                echo -e "\nWhat is your name? (first name)"
                read CUSTOMER_NAME
                # if customer name includes anything except letters
                if [[ ! $CUSTOMER_NAME =~ ^[a-zA-Z]+$ ]]
                then
                # Enter a valid name with letters
                MENU "Enter a valid name with letters."
                else
                        INSERT_CUSTOEMR_NAME=$($PSQL "insert into customers(name) values('$CUSTOMER_NAME')")
                fi
                # Choose available lemons to purchase
                echo -e "\nHi, $CUSTOMER_NAME\nPick your lemons."
                    sleep 2
                AVAILABLE_LEMONS=$($PSQL "select * from product")
                # echo $($AVAILABLE_LEMONS)
                echo $AVAILABLE_LEMONS | sed -E 's/\|//g' | sed -E 's/t//g' | sed -E 's/   ([a-zA-Z]+)/\1\n/g' | sed -E "s/^ //g"
                read OPTION
                # if option is invalid
                if [[ ! $OPTION =~ ^[0-9]{1,2}$ || $OPTION > 40 ]]
                then
                    echo -e "\n This is not a valid selection"
                else
                    LEMON_SELECTED=$($PSQL "select lemons from product where product_id=$OPTION")
                    echo -e "\n$CUSTOMER_NAME selected$LEMON_SELECTED lemon-batch"
                fi

}

VIEW_OUR_SALES(){
echo "View our sales"
}


EXIT(){
    echo "Thank you for visiting the shop!"
}


MENU