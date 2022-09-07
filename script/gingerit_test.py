from gingerit.gingerit import GingerIt

text = "We must respect tho will of th individual. Take it easy. I can assure you that everything will turn out fine. Let go of your negative outlook on life. Always maintain a positive attitude. You should be fair to everyone regardless of national origin, gender or creed. Equality is guaranteed by the constitution. He leaned against the pillar and gazed at the Statue of Liberty. A woman passed by me giving off a subtle scent of perfume. 'Natto' smells awful but tastes terrific. I'm soaked with sweat. Stand back! You stink. Take a shower!"

parser = GingerIt()

print(parser.parse(text)['corrections'])

for item in parser.parse(text)['corrections']:
  print("# rowX col:" + str(item['start']) + " definition:" + str(item['definition']))
  print(item['text'] + " >> " + item['correct'])

# 間違え数（alart数)
print(len(parser.parse(text)['corrections']))

# 結果イメージ
# 検討事項１:一行実行するたびにエラーチェックするか？
# → 一行ずつはしない。全部解いてからエラーチェックする。
#(表示すると全部解く気がしなくなる)
#検討事項２：エラーをファイル出力するか？
#ファイル出力する。後から見返してもいいし、必要があればNGチェックフォルダに移動すればいい。
#
