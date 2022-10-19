# encoding=utf-8
print ("hello world")
print ("中文打印")

s = ["hello", " ", "python"]
print s  # python 2.x
print (s)  # python 3.x

# 多条语句可写在同一行 但不建议
print ('a'); print ('b');

# 不换行输出
x = 'lo'
y = 've'
print x, y
print x,
print y,

word = 'word'
sentence = "this is a sentence."
paragraph = """this is a looooooooooo
oooooong paragraph"""
print word
print sentence
print paragraph

# 单行注释
'''
多行注释
三个双引号也可
'''

# 从键盘输入
key = raw_input("按下 enter 键退出，其他任意键显示...\n")  # 获取从键盘输入的内容 回车键结束
print key

# if else 语句        tab     shift+tab
b1 = False
if b1:
    print ('a')
    print ('b')
else:
    print ('c')
    print ('d')

b2 = 0
if b2 == 0:
    print 'sw0'
elif b2 == 1:
    print 'sw1'
else:
    print 'sw_oth'


