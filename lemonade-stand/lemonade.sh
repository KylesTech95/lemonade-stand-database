#!/bin/bash
# Declare PSQL
PSQL="psql -X --username=postgres --dbname=lemonade --tuples-only -c"

#if you want to insert your own daa:
#uncomment the next line to clear the database values & reset all sequences to 1.
echo $($PSQL "alter sequence product_product_id_seq restart with 1;alter sequence transaction_transaction_id_seq restart with 1; alter sequence customers_customer_id_seq restart with 1;truncate product,transaction,customers;")
#run the script "./lemonade.sh"
#insert your own data (original data is cleared)
#comment the line that was uncommented to save data

echo -e "\n~~~ Welcome to my Lemonade Stand ~~~\n"
#_______________________________________________________________________________________________________________________
# Get sales info:
#$CUSTOMER_NAME $CUSTOMER_PAYMENT $PRICE $QUANTITY $CUSTOMER_ID $PRODUCT_ID
# GET_SALES_INFORMATION(){
# #total sales
# TOTAL_SALES=$($PSQL "select sum(payment_received::double precision) from transaction")
# echo "$TOTAL_SALES" | sed -E 's/(\.[0-9]{1})/\10/'
# }
# GET_SALES_INFORMATION
#_______________________________________________________________________________________________________________________

#_______________________________________________________________________________________________________________________
#start transaction
# $CUSTOMER_NAME $CUSTOMER_PAYMENT $PRICE $QUANTITY $CUSTOMER_ID $PRODUCT_ID
START_TRANSACTION(){
   echo -e "\n~~~ Welcome to transaction ~~~\n"
   INSERT_INTO_TRANSACTION=$($PSQL "insert into transaction(payment_received,price,product_id,customer_id,quantity_bought) values('$2','$3',$6,$5,$4)")
       TRANSACTION_ID=$($PSQL "select transaction_id from transaction where customer_id=$5")

    if [[ $INSERT_INTO_TRANSACTION = 'INSERT 0 1' ]]
    then
    # Desired output (if name is inserted)

        echo "$CUSTOMER_NAME inserted into transaction table. Transaction#: TRA$TRANSACTION_ID" | sed -E 's/(\s+)?([0-9]+)(\s+)?/-\2/'
        MENU
    fi
    # Get sales info: 
    # $CUSTOMER_NAME $CUSTOMER_PAYMENT $PRICE $QUANTITY $CUSTOMER_ID $PRODUCT_ID
}
#_______________________________________________________________________________________________________________________

# step-1:insert inventory
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
#_______________________________________________________________________________________________________________________
# step-2:main menu
MENU(){
# get num of rows
MAX_ROWS=$($PSQL "select count(lemons) from product")
# if count(lemons) is not greater than 1, insert inventory.
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

#_______________________________________________________________________________________________________________________
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
    if [[ $INSERT_CUSTOEMR_NAME == "INSERT 0 1" ]]
    then
        echo "$CUSTOMER_NAME inserted into customers"
    fi 
fi

# Choose available lemons to purchase
echo -e "\nHi, $CUSTOMER_NAME\nPick your lemons."
#retrieve customer_id from name
CUSTOMER_ID=$($PSQL "select customer_id from customers")
sleep 1
AVAILABLE_LEMONS=$($PSQL "select * from product where available=true")
echo $AVAILABLE_LEMONS | sed -E 's/\|//g' | sed -E 's/t//g' | sed -E 's/   ([a-zA-Z]+)/\1\n/g' | sed -E 's/^\s+//g'
read PRODUCT_ID

# if PRODUCT_ID is invalid
if [[ ! $PRODUCT_ID =~ ^[0-9]{1,2}$ || $PRODUCT_ID -gt 40 ]]
then
echo -e "\n This is not a valid selection."
sleep 1
MENU
else
# selected lemon is valid
LEMON_SELECTED=$($PSQL "select lemons from product where product_id=$PRODUCT_ID")
# echo what the customer purchased
echo -e "\n$CUSTOMER_NAME selected$LEMON_SELECTED lemon-batch"

INSERT_LEMON_1=$($PSQL "update customers set first_lemon='$LEMON_SELECTED' where customer_id=$CUSTOMER_ID")
INSERT_CL1=$($PSQL "update product set customer_lemons_id=$CUSTOMER_ID where product_id=$PRODUCT_ID")
            if [[ $INSERT_LEMON_1 = 'INSERT 0 1' ]]
            then
            # Desired output (if lemon is inserted)
                echo -e "$CUSTOMER_ID)$CUSTOMER_NAME - $LEMON_SELECTED."
            fi
# set lemon to false by product_id
UPDATE_AVAILABLE=$($PSQL "update product set available=false where product_id=$PRODUCT_ID")
sleep 1
echo -e "\nWould you like more? [y/n]"
read ANSWER
    
fi

}

#$CUSTOMER_NAME $CUSTOMER_PAYMENT $PRICE $QUANTITY $CUSTOMER_ID $PRODUCT_ID
VIEW_OUR_SALES(){
echo -e "\nView our sales"
}


EXIT(){
echo "Thank you for visiting the shop!"
}


MENU