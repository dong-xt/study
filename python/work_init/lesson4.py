# encoding=utf-8

print "条件语句"
a = 1
if a != 0:
    print "a不等于0"
else:
    print "a等于0"
a += 1

if 0 <= a <= 5:
    print "k1"
elif a > 5 and a <= 10:
    print "1"
else:
    print "404"

print "循环语句"
# 寻找30-50间的质数
i = 30
while 30 <= i <= 50:
    j = 2
    while j < i:
        if i % j == 0:
            break           # break continue的不同 pass
        j += 1
    else:
        print i, "是质数"
    i += 1

num = 0
for c in 'ubefoabfdawfonenfian':
    if c == 'a':
        num += 1
print "有", num, "个a"

for m in range(30, 51):      # 左闭右开
    for n in range(2, m):
        if m % n == 0:
            break
    else:
        print m, "是质数"
