# Insert Lemons into product table
PSQL="psql -X --username=postgres --dbname=lemonade --tuples-only -c"
# Uncomment truncate next line to refresh database values
echo $($PSQL "truncate product,transaction,customers")

cat product.csv | while IFS="," read LEMON_TYPE
do
    if [[ $LEMON_TYPE != "lemons" ]]
    then
    LEMON_ID=$($PSQL "select product_id from product where lemons = '$LEMON_TYPE'")
    if [[ -z $LEMON_ID ]]
    then
    INSERT_LEMON_TYPE=$($PSQL "insert into product(lemons) values('$LEMON_TYPE')")
    if [[ $INSERT_LEMON_TYPE == "INSERT 0 1" ]]
      then
        echo Inserted into majors, $LEMON_TYPE
      fi
    fi
    fi
    done