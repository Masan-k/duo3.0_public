# -----------------------------------------------
# セクション毎に覚えた例文を入力させるスクリプト
# -----------------------------------------------

# [output]
# secX_mmdd_hhmm1-hhmm2_alertCount.txt
#  secX :セクション
#  mmdd :月日
#  hhmm1:開始時分
#  hhmm2:終了時分

from gingerit.gingerit import GingerIt

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

import os
import os.path
import datetime

qCount = 0
while(True):
  print("Please select section number >> " , end="")
  entry=input()

  if entry.isdigit() == False:
    print("数値を入力してください")
    continue   
  elif int(entry) >= 1 and int(entry) <= 10:
    #para = 'True' if True else 'False' 

    if entry == "1": qCount = SEC1_Q_NUM 
    elif entry == "2": qCount = SEC2_Q_NUM 
    elif entry == "3": qCount = SEC3_Q_NUM 
    elif entry == "4": qCount = SEC4_Q_NUM 
    elif entry == "5": qCount = SEC5_Q_NUM 
    elif entry == "6": qCount = SEC6_Q_NUM 
    elif entry == "7": qCount = SEC7_Q_NUM 
    elif entry == "8": qCount = SEC8_Q_NUM 
    elif entry == "9": qCount = SEC9_Q_NUM 
    elif entry == "10": qCount = SEC10_Q_NUM
    break #exit(if)

  else:
    print("1~10を入力してください")
    continue
  break

startTime = '{0:%H%M}'.format(datetime.datetime.now())
entryCount = 0 
sentence = ""
sentences = {}
ngText = ""
ngTextCount = 0
while(True):
  if entryCount != 0: 
    sentences[entryCount] = sentence

  entryCount += 1 
  if entryCount > qCount: break

  print(str(entryCount) + "/" + str(qCount) + " >> ", end="")
  sentence=input()
  
  # word check
  parser = GingerIt()
  corrections = parser.parse(sentence)['corrections']
  for item in corrections:
    ngText += "# row:" + str(entryCount) + " col:" + str(item['start']) + "\n"
    ngText += item['text'] + " >> " + item['correct'] + "\n"
    ngTextCount += 1

outputSentence = ""
for value in sentences.values():
  outputSentence += value + "\n"

print("COMPLATE!!")
print("NG_WORD!!")
print(ngText)

saveDate = '{0:%m%d}'.format(datetime.datetime.now())
endTime = '{0:%H%M}'.format(datetime.datetime.now())
saveFileName ="sec" + str(entry) + "_" + saveDate + "_" + startTime + "-" + endTime + "_" + str(ngTextCount) + ".txt" 

open("../log/" + saveFileName,'w').write(outputSentence)
open("log/" + saveFileName + "_NgText.txt",'w').write(ngText)


