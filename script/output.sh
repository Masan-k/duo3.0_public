#!/bin/bash

CWD=$(pwd)
BEFORE_SECTION="none"
SECTION_CNT=0
WRITE_DATE="none"
WRITE_ALERT="none"

ROW_DATE=""
ROW_ALERT=""

#古いログファイルを削除
sudo rm ../log_view/alert*.txt
sudo rm ../log_view/create-date*.txt
SAVE_DATE=`date +%Y%m%d`

for file_path in ../log/*.txt; do
    # basenameコマンドでPATHを削除する。
    FILENAME="$(basename ${file_path})"
    SECTION=`echo $FILENAME | cut -d '_' -f 1`
    INS_DATE=`echo $FILENAME | cut -d '_' -f 2`
    ALERT_EXT=`echo $FILENAME | cut -d '_' -f 4`
    ALERT=`echo ${ALERT_EXT%.txt}`

if [ $BEFORE_SECTION = "none" ]; then
      ((SECTION_CNT++))
      BEFORE_SECTION=$SECTION
      WRITE_DATE=$INS_DATE
      WRITE_ALERT=$ALERT

    elif [ $BEFORE_SECTION = $SECTION ]; then
      ((SECTION_CNT++))
      WRITE_DATE+=,$INS_DATE
      WRITE_ALERT+=,$ALERT
    
    else
      ROW_DATE+=`echo $'\n'"${BEFORE_SECTION},${SECTION_CNT},${WRITE_DATE}"`
      ROW_ALERT+=`echo $'\n'"${BEFORE_SECTION},${WRITE_ALERT}"`

      SECTION_CNT=1
      BEFORE_SECTION=$SECTION
      WRITE_DATE=$INS_DATE
      WRITE_ALERT=$ALERT
    
    fi
done
ROW_DATE+=`echo $'\n'"${BEFORE_SECTION},${SECTION_CNT},${WRITE_DATE}"`
ROW_ALERT+=`echo $'\n'"${BEFORE_SECTION},${WRITE_ALERT}"`

echo ------------$'\n'CREATE_DATE LIST$'\n'------------"$ROW_DATE" > ../log_view/create-date-$SAVE_DATE.txt
echo ------------$'\n'ALERT LIST$'\n'------------"$ROW_ALERT" > ../log_view/alert-$SAVE_DATE.txt

