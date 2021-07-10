#!/bin/bash

SCREEN_STATE=$(echo $(caget BL:INJ:FPC2_01:CH01RB) | cut -d ' ' -f 2)
CAMERA_STATE=$(echo $(caget BL:DCC:CamSelector1) | cut -d ' ' -f 2)
COUNT_DATA_NUM=0
DATA_SAVE_PATH="/home/test_data"

cd $DATA_SAVE_PATH

read -p "EXPECTED_DATA_NUMBERS: " EXPECTED_DATA_NUMBERS
read -p "PROCESS_TIME: " PROCESS_TIME
read -p "CAMERA_NUMBER: " CAMERA_NUMBER

SCREEN_NUMBER=$CAMERA_NUMBER

caput BL:DCC:CamSelector$CAMERA_NUMBER 1
sleep 10

START_TIME=$(date +%s)

caput BL:INJ:FPC2_01:CH0"$SCREEN_NUMBER"SET 1

if [ $SCREEN_STATE == 1 ] && [ $CAMERA_STATE == 1 ]; then
   while [ $COUNT_IMG_NUM -lt $EXPECTED_DATA_NUMBERS ]; do 
      caget -t BL:DCC:image1:ArrayData > $(date +%Y%m%d)_cam"$CAMERA_NUMBER"_$COUNT_IMG_NUM.raw 
      let COUNT_IMG_NUM+=1
      END_TIME=$(date +%s)
      echo "$(date +%Y%m%d)_$COUNT_IMG_NUM.raw data is gotten. $(( $END_TIME - $START_TIME )) second"
      if [ $(( $END_TIME - $START_TIME )) == $PROCESS_TIME  ]; then
         caput BL:INJ:FPC2_01:CH0"$SCREEN_NUMBER"SET 0
         exit
      fi
   done
   caput BL:INJ:FPC2_01:CH0"$SCREEN_NUMBER"SET 0
fi


