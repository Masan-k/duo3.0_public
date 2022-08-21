#!/bin/bash
# ----------------------------------j
# 正誤表から問題を出題するスクリプト
# ----------------------------------j
# [input file]
#   the inhavitants >> the inhabitants
#   potencial >> potential

# [input pram]
#   1.ng_file_name
#   2.anser word
echo "-------------"$'\n'"NG WORD LIST"$'\n'"-------------"
echo `ls ../log_ng`
echo $'\n'"-------------"$'\n'"PLEASE ENTRY"$'\n'"-------------"
while true
do
  read -p "NG LIST >> " ENTRY
  if [ -f ../log_ng/$ENTRY ]; then
    IMPORT_FILE="../log_ng/${ENTRY}"
    echo "import_file->"$IMPORT_FILE
    break
  else
    echo "NOT FOUND!"
  fi
done

echo -------$'\n'Running....$'\n'-------
OK_COUNT=0
NG_COUNT=0
OUTPUT=""

while read -u 9 line #-u 9:read operate error 
do
  line_c=`echo ${line:0:1}`
  if [ $line_c = '#' -o $line_c = '<' ]; then
    continue
  fi
   
  NG_WORD=`echo ${line} | cut -d '>' -f 1 | tr '[:upper:]' '[:lower:]'`
  OK_WORD=`echo ${line} | cut -d '>' -f 3 | tr '[:upper:]' '[:lower:]'`
  OK_WORD=`echo $OK_WORD` #trim
  read -p "${NG_WORD}>>" ANSWER_WORD
  ANSWER_WORD=`echo $ANSWER_WORD | tr '[:upper:]' '[:lower:]'`

  if [ "$OK_WORD" = "$ANSWER_WORD" ]; then
    echo "OK!!" $'\n'
    OUTPUT+=$'\n'"${line} >> OK"
    ((OK_COUNT++))
  else 
    echo "NG>>"$OK_WORD $'\n'
    OUTPUT+=$'\n'"${line} >> NG:${ANSWER_WORD}"
    ((NG_COUNT++))
  fi
done 9< $IMPORT_FILE 
echo "--------"$'\n'"CLEAR!!"$'\n'"---------"-
echo "OK:${OK_COUNT} NG:${NG_COUNT}"

SAVE_NAME_IMP=`echo ${ENTRY} | cut -d '.' -f 1` 
SAVE_NAME_DATE=`date +%Y%m%d-%H%M%S`
SAVE_NAME="${SAVE_NAME_IMP}_${SAVE_NAME_DATE}.txt"
echo "$OUTPUT" > ng-check-history/${SAVE_NAME}
