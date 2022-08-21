#!/bin/bash
#-------------------------------------------------------
# テキストファイルに保存した例文数を取得するスクリプト
#-------------------------------------------------------
#（前提条件）
#　・例文は単一のテキストファイルに保存される。
#　・一つのテキストファイルには複数の例文が記述される。
#　・一つの例文は一行で、文中に改行が入ることはない
#　・<fromJapanese></fromJapanese>は暗記した例文に含めない。

#　・テキストファイルは、セクションコード_日付_時間_単語ミス数.txtの形式で保存される。
#　・セクションコード毎に例文数は決まっている。

#（出力したい結果）
#　・セクションコード[例文数]：入力された例文数
#　例：sec1[9]:8,9,7
#      sec2[12]:5,9,10

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
COUNT="none"
ROW=""

#古いログファイルを削除
sudo rm output/row-count-*.txt
SAVE_DATE=`date +%Y%m%d`

Q_NUM=99

for file_path in ../log/*.txt; do
  # basenameコマンドでPATHを削除する。
  FILENAME="$(basename ${file_path})"
  SECTION=`echo $FILENAME | cut -d '_' -f 1`

  ROW_COUNT=0
  while read line
  do
    line_c=`echo ${line:0:1}`

    if [ $line_c == '#' -o $line_c == "<" -o ${#line} == 1 ]; then
      continue
    else
      ((ROW_COUNT=${ROW_COUNT}+1))
    fi
  done < ${file_path}

  if [ $BEFORE_SECTION = "none" ]; then
    BEFORE_SECTION=$SECTION
    COUNT=$ROW_COUNT

    elif [ $BEFORE_SECTION = $SECTION ]; then
      COUNT+=,$ROW_COUNT
    
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

      ROW+=`echo $'\n'"${BEFORE_SECTION}[${Q_NUM}]:${COUNT}"`

      BEFORE_SECTION=$SECTION
      COUNT=$ROW_COUNT 
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

ROW+=`echo $'\n'"${BEFORE_SECTION}[${Q_NUM}]:${COUNT}"$'\n'"_"`
echo "-------------------"$'\n'"SENTENCES COUNT LIST"$'\n'"-------------------$ROW"
echo -----------------------$'\n'SENTENCES COUNT LIST$'\n'-----------------------"$ROW" > output/row-count-$SAVE_DATE.txt

