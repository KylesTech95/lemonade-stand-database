#!/bin/bash
# Declare PSQL
PSQL="psql -X --username=postgres --dbname=lemonade --tuples-only -c"

#if you want to insert your own daa:
#uncomment the next line to clear the database values & reset all sequences to 1.
# echo $($PSQL "alter sequence product_product_id_seq restart with 1;alter sequence transaction_transaction_id_seq restart with 1; alter sequence customers_customer_id_seq restart with 1;truncate product,transaction,customers;")
#run the script "./lemonade.sh"
#insert your own data (original data is cleared)
#comment the line that was uncommented to save data

echo -e "\n~~~ Welcome to my Lemonade Stand ~~~\n"
#_______________________________________________________________________________________________________________________________________________________________________________________________________

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
        fi
        # If a variable is present after the functionCall, state it
        if [[ $1 ]]
        then 
            echo -e "\n$1"
            sleep 2
        # if not, give the general greeting for MENU
        else
            echo -e "\nMain Menu\n"
        fi

    echo -e "\n1)Purchase lemons\n2)view our sales\n3)exit"
    read OPTION

        case $OPTION in
        1) PURCHASE ;;
        2) VIEW_OUR_SALES ;;
        3) EXIT ;;
        esac
    
}

#_______________________________________________________________________________________________________________________
PURCHASE(){
 echo -e "\n~~~ Welcome to Purchase~~~\n"

    # get available lemons
    AVAILABLE_LEMONS=$($PSQL "SELECT product_id, lemons FROM product WHERE available = true ORDER BY product_id")
    # if no bikes available
    if [[ -z $AVAILABLE_LEMONS ]]
        then
        MENU "\nSorry, we don't have any lemons available right now."
        else 
        # What is your name?
        sleep 2
        echo -e "\nWhat is your name? (first name)"
        read CUSTOMER_NAME
            # if customer name includes anything except letters
            if [[ ! $CUSTOMER_NAME =~ ^[a-zA-Z]+$ ]]
                then
                # Enter a valid name with letters
                echo -e "\nEnter a valid name with letters."
                sleep 2
                read CUSTOMER_NAME
                # if customer name is invalid again, send to menu
                    if [[ ! $CUSTOMER_NAME =~ ^[a-zA-Z]+$ ]]
                    then
                        MENU "\nSorry but we cannot enter an invalid name."
                    else
                        echo -e "\nHello $CUSTOMER_NAME"
                    fi
                else
                    echo -e "\nHello $CUSTOMER_NAME"
            fi
            # sleep for 2 seconds
            sleep 2
            echo -e "\nSelect from available lemons inventory"
            #select from available lemons
            AVAILABLE_LEMONS=$($PSQL "SELECT product_id, lemons from product WHERE available = true ORDER BY product_id")
            sleep 2
            echo "$AVAILABLE_LEMONS" | while read PRODUCT_ID BAR LEMONS
                do
                    echo "$PRODUCT_ID. $LEMONS lemons"
                done
            # ask for lemon to purchase
            echo -e "\nWhich one would you like to purchase? (Choose by the number)"
            #user chooses a lemon from the list of available lemons
            read LEMON_TO_BUY
            # if input is not a number
            if [[ ! $LEMON_TO_BUY =~ ^[0-9]+$ ]]
                then
                # send to main menu
                MENU "\nThat is not a valid number."
                else 
                # get lemon availability
                AVAILABLE_LEMONS=$($PSQL "select available from product where product_id = $LEMON_TO_BUY and available = true")
                # if not available
                    if [[ -z $AVAILABLE_LEMONS ]]
                        then 
                        # send to main menu
                        MENU "\nThat lemon-batch is not available."
                        else
                        # give first_lemon a name
                        FIRST_LEMON=$($PSQL "select lemons from product where product_id=$LEMON_TO_BUY")
                        UPDATE_LEMONS=$($PSQL "update product set available=false where product_id=$LEMON_TO_BUY")
                        # modify input
                        F_LEMON=$(echo "$FIRST_LEMON" | sed -E 's/^\s+//')
                        echo -e "\n$CUSTOMER_NAME selected $F_LEMON lemons"
                        sleep 2
                    fi
            fi
    fi

    #Does the user want to purchase one more lemon?
    echo -e "\nWant to purchase 1 more lemon? [y/n] or [Y/N]"
    read OPTION
    if [[ ! $OPTION =~ ^[y|n|Y|N]$ ]]
        then
            MENU "\noops! Wrong option. Welcome to menu"
        else
            # user selects NO
            if [[ $OPTION =~ ^[n|N]$ ]]
            then
                INSERT_CUSTOMER=$($PSQL "insert into customers(name,first_lemon) values('$CUSTOMER_NAME','$F_LEMON')" )
                CUSTOMER_ID=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME' and first_lemon='$F_LEMON'")
                PRODUCT_ID=$($PSQL "select product_id from product where product_id='$LEMON_TO_BUY'")
                if [[ $INSERT_CUSTOMER == "INSERT 0 1" ]]
                then
                    echo -e "\n$CUSTOMER_NAME chose $F_LEMON - Quantity: 1"
                    ENTER_TRANSACTION '3.50' $CUSTOMER_ID $PRODUCT_ID 1

                fi


            # user selects YES
            else
            # option to purchase 1 more lemon
            # get available lemons
            AVAILABLE_LEMONS=$($PSQL "SELECT product_id, lemons FROM product WHERE available = true ORDER BY product_id")
            # if no bikes available
            if [[ -z $AVAILABLE_LEMONS ]]
                then
                INSERT_CUSTOMER=$($PSQL "insert into customers(name,first_lemon) values('$CUSTOMER_NAME','$F_LEMON')" )
                CUSTOMER_ID=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME' and first_lemon='$F_LEMON'")
                    
                
                echo -e "\nSorry, we don't have any lemons available right now."
                if [[ $INSERT_CUSTOMER == "INSERT 0 1" ]]
                    then
                        echo -e "\n$CUSTOMER_NAME chose $F_LEMON - Quantity: 1"
                        ENTER_TRANSACTION '3.50' $CUSTOMER_ID $PRODUCT_ID 1
                    fi
                sleep 2
                MENU
                else 
                    # sleep for 2 seconds
                    sleep 2
                    echo -e "\nSelect from available lemons inventory"
                    #select from available lemons
                    AVAILABLE_LEMONS=$($PSQL "SELECT product_id, lemons from product WHERE available = true ORDER BY product_id")
                    sleep 2
                    echo "$AVAILABLE_LEMONS" | while read PRODUCT_ID BAR LEMONS
                        do
                            echo "$PRODUCT_ID. $LEMONS lemons"
                        done
                    # ask for lemon to purchase
                    echo -e "\nWhich one would you like to purchase? (Choose by the number)"
                    #user chooses a lemon from the list of available lemons
                    read LEMON_TO_BUY2
                    # if input is not a number
                if [[ ! $LEMON_TO_BUY2 =~ ^[0-9]+$ ]]
                    then
                    # send to main menu
                    MENU "\nThat is not a valid number."
                    else 
                    # get lemon availability
                    AVAILABLE_LEMONS=$($PSQL "select available from product where product_id = $LEMON_TO_BUY2 and available = true")
                    # if not available
                    if [[ -z $AVAILABLE_LEMONS ]]
                        then 
                        # send to main menu
                        MENU "\nThat lemon-batch is not available."
                        else
                        # give second_lemon a name
                        SECOND_LEMON=$($PSQL "select lemons from product where product_id=$LEMON_TO_BUY2")
                        UPDATE_LEMONS=$($PSQL "update product set available=false where product_id=$LEMON_TO_BUY2")
                        # modify input
                        S_LEMON=$(echo "$SECOND_LEMON" | sed -E 's/^\s+//')
                        INSERT_CUSTOMER=$($PSQL "insert into customers(name,first_lemon,second_lemon) values('$CUSTOMER_NAME','$F_LEMON','$S_LEMON')" )
                        CUSTOMER_ID=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME' and second_lemon='$S_LEMON' and first_lemon='$F_LEMON'")
                        PRODUCT_ID=$($PSQL "select product_id from product where product_id='$LEMON_TO_BUY2'")
                            if [[ $INSERT_CUSTOMER == "INSERT 0 1" ]]
                            then
                                echo -e "\n$CUSTOMER_NAME chose $S_LEMON - Quantity: 2"
                                ENTER_TRANSACTION '7.00' $CUSTOMER_ID $PRODUCT_ID 2 $CUSTOMER_NAME
                            fi
                    fi
                fi
            fi
        fi         
    fi

    







}
# '7.00' $CUSTOMER_ID $PRODUCT_ID 2 CUSTOMER_NAME
ENTER_TRANSACTION(){
    PRICE=$1
    CUSTOMER_ID=$2
    PRODUCT_ID=$3
    QUANTITY=$4
    # Your price is this
    echo -e "\nYou MUST pay me $PRICE. (format: 1.20 or 4 or \$15.25)"
    sleep 1
    read CUSTOMER_PAYMENT

    if [[ ! $CUSTOMER_PAYMENT  =~ ^[0-9]([0-9])?(\.)?([0-9]{1,2})?$ ]]
        then
        echo -e "\n$CUSTOMER_PAYMENT is not correct format. Try again"
        ENTER_TRANSACTION $PRICE
        else
        BOOL=$(echo "$CUSTOMER_PAYMENT < $PRICE" | bc -l)
        # if the customer_pay is insufficnent
            if [[ $BOOL == 1 ]]
            then
                #delete customer
                DELETE_CUSTOMER=$($PSQL "delete from customers where customer_id=$CUSTOMER_ID")
                echo "$DELETE_CUSTOMER"
                MENU "\nInsufficient Funds."
                else
                MENU "\n$CUSTOMER_NAME payed $CUSTOMER_PAYMENT."

            fi
        fi
}
VIEW_OUR_SALES(){
    echo -e "\nView our sales"
}
EXIT(){
    echo "Thank you for visiting the shop!"
    sleep 2
}

MENU