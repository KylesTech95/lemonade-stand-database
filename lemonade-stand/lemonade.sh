#!/bin/bash
# Declare PSQL
PSQL="psql -X --username=postgres --dbname=lemonade --tuples-only -c"
# echo $($PSQL "alter sequence product_product_id_seq restart with 1;alter sequence transaction_transaction_id_seq restart with 1; alter sequence customers_customer_id_seq restart with 1;truncate product,transaction,customers;")
echo -e "\n~~~ Welcome to my Lemonade Stand ~~~\n"
# customer_payment price quantity product_id customer_name
START_TRANSACTION(){
    if [[  $1 > $2 ]]
    then
        DIFFERENCE=$(awk "BEGIN { printf(\"%.2f\", $1 - $2) }")
        echo -e "\n$5, your change is \$$DIFFERENCE" | sed -E 's/(\.[0-9]{1})$/\10/'
    else
        DIFFERENCE=$(awk "BEGIN { printf(\"%.2f\", $2 - $1) }")
        echo -e "\n$5, you owe \$$DIFFERENCE" | sed -E 's/(\.[0-9]{1})$/\10/'
    fi
echo $DIFFERENCE
    #extract customer_id
    CUSTOMER_ID=$($PSQL "select customer_id from customers")
    echo -e "\n~~~ Start transaction ~~~\n"
    sleep 1
    echo -e "\nOriginal price: $2"
    # if the CUSTOMER_PAYMENT only has 1 digit after deci, add a zero at the end.
    echo -e "Customer paid \$$1" | sed -E 's/(\.[0-9]{1})$/\10/'
    TRANSACTION=$($PSQL "insert into transaction(price,payment_received,product_id,customer_id,quantity_bought) values('$2','$1',$4,$CUSTOMER_ID,$3)")
    echo $TRANSACTION
}

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
    if [[ $INSERT_CUSTOEMR_NAME == "INSERT 0 1" ]]
    then
        echo "$CUSTOMER_NAME inserted into customers"
    fi 
fi
# Choose available lemons to purchase
echo -e "\nHi, $CUSTOMER_NAME\nPick your lemons."
sleep 2
AVAILABLE_LEMONS=$($PSQL "select * from product where available=true")
# echo $($AVAILABLE_LEMONS)
echo $AVAILABLE_LEMONS | sed -E 's/\|//g' | sed -E 's/t//g' | sed -E 's/   ([a-zA-Z]+)/\1\n/g' | sed -E "s/^ //g"
read PRODUCT_ID
# if PRODUCT_ID is invalid
if [[ ! $PRODUCT_ID =~ ^[0-9]{1,2}$ || $PRODUCT_ID > 40 ]]
then
echo -e "\n This is not a valid selection. Try again."
sleep 1
read PRODUCT_ID
else
# select a valid lemon
LEMON_SELECTED=$($PSQL "select lemons from product where product_id=$PRODUCT_ID")
echo -e "\n$CUSTOMER_NAME selected$LEMON_SELECTED lemon-batch"
# set lemon to false by product_id
UPDATE_AVAILABLE=$($PSQL "update product set available=false where product_id=$PRODUCT_ID")
sleep 1
echo -e "\nWould you like more? [y/n]"
read ANSWER
    if [[ $ANSWER -ne 'y' || $ANSWER -ne 'n' ]]
    then
        MENU "\nIt is a simple question..."
    else
        if [[ $ANSWER = 'n' ]]
        then
            QUANTITY=1
            #state price
            echo -e "\nThis will come out to \$3.50"
            echo -e "\nEnter payment (ex: 3.50 or 5.35 or 4.00)"
            read CUSTOMER_PAYMENT
            if [[ ! $CUSTOMER_PAYMENT =~ ^[0-9]{1,2}\.[0-9]{1,2}$ ]]
            then
                echo -e "\nPlease enter with the specified format. (ex: 3.50 or 5.35 or 4.00)"
                read CUSTOMER_PAYMENT
                echo -e "\n$CUSTOMER_NAME paid \$$CUSTOMER_PAYMENT"
                START_TRANSACTION $CUSTOMER_PAYMENT 3.50 $QUANTITY $PRODUCT_ID $CUSTOMER_NAME
            else
                echo -e "\n$CUSTOMER_NAME paid \$$CUSTOMER_PAYMENT"
                
                START_TRANSACTION $CUSTOMER_PAYMENT 3.50 $QUANTITY $PRODUCT_ID $CUSTOMER_NAME
            fi
    #_______________________________________________________________________________________________________________________
        else
            #Instantiate a new selection of product by availability
            AVAILABLE_LEMONS2=$($PSQL "select * from product where available=true")
            # select a valid lemon
            echo -e "\nPick another set of lemons\n"
            sleep 1
            echo $AVAILABLE_LEMONS2 | sed -E 's/\|//g' | sed -E 's/t//g' | sed -E 's/   ([a-zA-Z]+)/\1\n/g' | sed -E "s/^ //g"
            read PRODUCT_ID2
        # if PRODUCT_ID is invalid
        if [[ ! $PRODUCT_ID2 =~ ^[0-9]{1,2}$ || $PRODUCT_ID2 > 40 ]]
        then
            echo -e "\n This is not a valid selection"
        else
        # select a valid lemon
            QUANTITY=2
            LEMON_SELECTED=$($PSQL "select lemons from product where product_id=$PRODUCT_ID2 and available=true")
            echo -e "\n$CUSTOMER_NAME selected$LEMON_SELECTED lemon-batch"
        # set lemon to false by product_id2
            UPDATE_AVAILABLE=$($PSQL "update product set available=false where product_id=$PRODUCT_ID2")
            fi
            #state price
            # TOTAL_PRICE
            echo -e "\nThis will come out to \$7.00"
            echo -e "\nEnter payment (ex: 3.50 or 5.35 or 4.00)"
            read CUSTOMER_PAYMENT
            if [[ ! $CUSTOMER_PAYMENT =~ ^[0-9]{1,2}\.[0-9]{1,2}$ ]]
            then
                echo "\nPlease enter with the specified format."
                read CUSTOMER_PAYMENT
                echo -e "\n$CUSTOMER_NAME paid \$$CUSTOMER_PAYMENT"
                START_TRANSACTION $CUSTOMER_PAYMENT 7.00 $QUANTITY $PRODUCT_ID2 $CUSTOMER_NAME
            else
                echo -e "\n$CUSTOMER_NAME paid \$$CUSTOMER_PAYMENT"

                START_TRANSACTION $CUSTOMER_PAYMENT 7.00 $QUANTITY $PRODUCT_ID2 $CUSTOMER_NAME
                
            fi
        fi
    fi

fi

}

VIEW_OUR_SALES(){
echo "View our sales"
}


EXIT(){
    echo "Thank you for visiting the shop!"
}


MENU