#!/usr/bin/env bash


while true
do
  echo "Are you a man?"
  read IS_MAN
  if [ "$IS_MAN" == "y" ] || [ "$IS_MAN" == "n" ]
  then 
    break; 
  fi
done

if [ $IS_MAN == "y" ]
then 
  echo "Enter breast measurment"
else 
  echo "Enter triceps measurment"
fi
read MEASURE_1
echo "Enter abdominal measurment"
read MEASURE_2
echo "Enter leg measurment"
read MEASURE_3
echo "Enter your age"
read AGE


SUM=$(bc <<<"scale=6;$MEASURE_1 + $MEASURE_2 + $MEASURE_3")
DENSITY=$(bc <<<"scale=6;1.1093800 - 0.0008267 * $SUM + 0.0000016 * $SUM * $SUM - 0.0002574 * $AGE")
FAT1=$(bc <<<"scale=2;457 / $DENSITY - 414.2")
FAT2=$(bc <<<"scale=2;495 / $DENSITY - 450")
BODY_FAT=$(bc <<<"scale=2;($FAT1 + $FAT2) /2")

echo "Your body fat is $BODY_FAT"
