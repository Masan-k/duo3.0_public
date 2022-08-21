# ----------------------------------j
# 正誤表から問題を出題するスクリプト
# ----------------------------------j
# [input file]
#   the inhavitants >> the inhabitants
#   potencial >> potential

# [input pram]
#   1.ng_file_name
#   2.anser word

import os
import os.path
import datetime

print("-------------")
print("NG WORD LIST")
print("-------------")
ngLists = os.listdir("../log_ng")
print(ngLists)
entry=""

while(True):
  print("NG_LIST >> " , end="")
  entry=input()
  for ngList in ngLists:
    if ngList == entry:
      print("import_file -> " + entry)
      break #exit(if)
    
  else:
    print("NOT FOUND!!")
    continue

  break

print("------------")
print("Running...")
print("------------")

okCount=0
ngCount=0
output=""
result=""
with open('../log_ng/' + entry) as f:
  for line in f:
    if line[:1] == '#' or line[:1] == '<':
      continue

    print(line.split(">>")[0] + " >> ", end = "")
    answerWord = input().lower().strip()
    correctWord = line.split(">>")[1].lower().strip()

    if correctWord == answerWord:
      print("OK!!\n")
      output += "\n" + line.strip() + " >> OK"
      okCount += 1 

    else:
      print("ng>>" + correctWord + "\n")
      output += "\n" + line.strip() + " >> NG:" + answerWord
      ngCount += 1

print("----------")
print("CLEAR!!")
print("----------")
result="OK:" + str(okCount) + " NG:" + str(ngCount)
print(result)

saveFileName = os.path.splitext(entry)[0]
saveDate = '{0:%Y%m%d-%H%M%S}'.format(datetime.datetime.now())
saveName = saveFileName + "_" + saveDate + "_python.txt"
open("ng-check-history/" + saveName,'w').write(result + "\n" + output)
