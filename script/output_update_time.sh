#!/bin/bash
#-------------------------------------------------------
# 作成日時と更新時間から経過時間一覧にするにスクリプト
#-------------------------------------------------------
# [想定結果]
#　セクションコード[対象セクションの例文数]：経過時間/入力した例文数(経過時間/入力した例文数)
#
#　入力例)全9題の例文があるsection1、400秒で8の例文を入力した
#  結  果)
#
#  sec1[9]:50(400/8)

# 例文数
SEC1_Q_NUM=9
SEC2_Q_NUM=12
SEC3_Q_NUM=14
SEC4_Q_NUM=10
SEC5_Q_NUM=17
SEC6_Q_NUM=13
SEC7_Q_NUM=16
SEC8_Q_NUM=9
SEC9_Q_NUM=13
SEC10_Q_NUM=12

CWD=$(pwd)
BEFORE_SECTION="none"
BEFORE_COUNT="none"
ROW=""
BEFORE_DIFF_TIME=""
TIME_COUNT=""

#古いログファイルを削除
sudo rm ../log_script/update-time-*.txt
SAVE_DATE=`date +%Y%m%d`

Q_NUM=99

for file_path in ../log/*.txt; do
  # basenameコマンドでPATHを削除する。
  FILENAME="$(basename ${file_path})"
  SECTION=`echo $FILENAME | cut -d '_' -f 1`
  
  # 更新時間-作成時間
  
  # -----------------------------------------#
  # 更新時間をファイルに入力するパターンに対応
  #   例:sec4_0820_1413-1432_13.txt
  # -----------------------------------------#
  FILE_NAME_TIME=`echo $FILENAME | cut -d '_' -f 3`
  if [ "`echo $FILE_NAME_TIME | grep '-'`" ]; then
    let UP_HOUR=$((`echo $FILE_NAME_TIME | cut -d '-' -f 2 | cut -b 1-2 `))
    let UP_MIN=$((`echo $FILE_NAME_TIME | cut -d '-' -f 2 | cut -b 3-4 `))

    let INS_HOUR=$((`echo $FILE_NAME_TIME | cut -b 1-2 `))
    let INS_MIN=$((`echo $FILE_NAME_TIME | cut -b 3-4 `))

  else
    let UP_HOUR=$((`date +%H -r $file_path`))
    let UP_MIN=$((`date +%M -r $file_path`))

    let INS_HOUR=$((`echo $FILE_NAME_TIME | cut -d '_' -f 1 | cut -b 1-2 `))
    let INS_MIN=$((`echo $FILE_NAME_TIME | cut -d '_' -f 1 | cut -b 3-4 `))
fi

  UP_TIME=$(($UP_HOUR * 60 + $UP_MIN))
  INS_TIME=$(($INS_HOUR * 60 + $INS_MIN))


    DIFF_TIME=$(($UP_TIME-$INS_TIME))
  # DIFF_TIME = [UP_TIME:1:00] -[INS_TIME:23:00] = -22
  if [ $DIFF_TIME -lt 0 ]; then
    DIFF_TIME=$(($DIFF_TIME + (24 * 60)))
  fi

  ROW_COUNT=0
  while read line
  do
    line_c=`echo ${line:0:1}`
    if [ "$line_c" != "#" ] && [ "$line_c" != "<" ]; then
      ((ROW_COUNT++))
    fi
  done < ${file_path}

  if [ $BEFORE_SECTION = "none" ]; then
    BEFORE_SECTION=$SECTION
    BEFORE_COUNT=$ROW_COUNT
    BEFORE_DIFF_TIME=$DIFF_TIME
    TIME_COUNT=$(($DIFF_TIME/$ROW_COUNT))"("$DIFF_TIME/$ROW_COUNT")"

    elif [ $BEFORE_SECTION = $SECTION ]; then
      BEFORE_COUNT+=,$ROW_COUNT
      BEFORE_DIFF_TIME+=,$DIFF_TIME
      TIME_COUNT+=,$(($DIFF_TIME/$ROW_COUNT))"("$DIFF_TIME/$ROW_COUNT")"

    
    else
      if [ $BEFORE_SECTION = "sec1" ];then Q_NUM=$SEC1_Q_NUM;fi
      if [ $BEFORE_SECTION = "sec2" ];then Q_NUM=$SEC2_Q_NUM;fi
      if [ $BEFORE_SECTION = "sec3" ];then Q_NUM=$SEC3_Q_NUM;fi
      if [ $BEFORE_SECTION = "sec4" ];then Q_NUM=$SEC4_Q_NUM;fi
      if [ $BEFORE_SECTION = "sec5" ];then Q_NUM=$SEC5_Q_NUM;fi
      if [ $BEFORE_SECTION = "sec6" ];then Q_NUM=$SEC6_Q_NUM;fi
      if [ $BEFORE_SECTION = "sec7" ];then Q_NUM=$SEC7_Q_NUM;fi
      if [ $BEFORE_SECTION = "sec8" ];then Q_NUM=$SEC8_Q_NUM;fi
      if [ $BEFORE_SECTION = "sec9" ];then Q_NUM=$SEC9_Q_NUM;fi
      if [ $BEFORE_SECTION = "sec10" ];then Q_NUM=$SEC10_Q_NUM;fi

      ROW+=`echo $'\n'"${BEFORE_SECTION}[${Q_NUM}]:${TIME_COUNT}"`

      BEFORE_SECTION=$SECTION
      BEFORE_COUNT=$ROW_COUNT
      BEFORE_DIFF_TIME=$DIFF_TIME
      TIME_COUNT=$(($DIFF_TIME/$ROW_COUNT))"("$DIFF_TIME/$ROW_COUNT")" 
   fi
done

if [ $BEFORE_SECTION = "sec1" ];then Q_NUM=$SEC1_Q_NUM;fi
if [ $BEFORE_SECTION = "sec2" ];then Q_NUM=$SEC2_Q_NUM;fi
if [ $BEFORE_SECTION = "sec3" ];then Q_NUM=$SEC3_Q_NUM;fi
if [ $BEFORE_SECTION = "sec4" ];then Q_NUM=$SEC4_Q_NUM;fi
if [ $BEFORE_SECTION = "sec5" ];then Q_NUM=$SEC5_Q_NUM;fi
if [ $BEFORE_SECTION = "sec6" ];then Q_NUM=$SEC6_Q_NUM;fi
if [ $BEFORE_SECTION = "sec7" ];then Q_NUM=$SEC7_Q_NUM;fi
if [ $BEFORE_SECTION = "sec8" ];then Q_NUM=$SEC8_Q_NUM;fi
if [ $BEFORE_SECTION = "sec9" ];then Q_NUM=$SEC9_Q_NUM;fi
if [ $BEFORE_SECTION = "sec10" ];then Q_NUM=$SEC10_Q_NUM;fi

ROW+=`echo $'\n'"${BEFORE_SECTION}[${Q_NUM}]:${TIME_COUNT}"`
echo "---------------------------------------------------------"$'\n'"update_time_list"$'\n'"  secXX:[question_line_count]:diff_min/input_line_count"$'\n'"---------------------------------------------------------$ROW"
echo ----------------------------------------------------------$'\n'update_time_list$'\n'  secXX:[question_line_count]:diff_min/input_line_count$'\n'----------------------------------------------------------"$ROW" > ../log_script/update-time-$SAVE_DATE.txt
