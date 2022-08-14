#!/bin/bash

CWD=$(pwd)
BEFORE_SECTION="none"
SECTION_CNT=0
WRITE_DATE="none"

#古いログファイルを削除
sudo rm view*.txt
SAVE_DATE=`date +%Y-%m-%d`

for file_path in ${CWD}/log/*.txt; do
    # basenameコマンドでPATHを削除する。
    FILENAME="$(basename ${file_path})"
    SECTION=`echo $FILENAME | cut -d '_' -f 1`
    INS_DATE=`echo $FILENAME | cut -d '_' -f 2`

if [ $BEFORE_SECTION = "none" ]; then
      ((SECTION_CNT++))
      BEFORE_SECTION=$SECTION
      WRITE_DATE=$INS_DATE

    elif [ $BEFORE_SECTION = $SECTION ]; then
      ((SECTION_CNT++))
      WRITE_DATE=$WRITE_DATE,$INS_DATE
    
    else
      echo "${BEFORE_SECTION}-${SECTION_CNT}-${WRITE_DATE}" >> view-$SAVE_DATE.txt
      SECTION_CNT=1
      BEFORE_SECTION=$SECTION
      WRITE_DATE=$INS_DATE
    
    fi
done
echo "${BEFORE_SECTION}-${SECTION_CNT}-${WRITE_DATE}" >> view-$SAVE_DATE.txt

