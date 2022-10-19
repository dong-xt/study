# encoding=utf-8

print "基本运算"
a = 10
b = 3
c = 0
c = a + b
c = a - b
c = a * b
c = a / b
print c
c = a % b
print c
c = a ** b
print c
c = a // b
print c
a = 10.0
c = a / b
print c
c = a // b
print c

print "比较运算"
if a == b:
    print "a等于b"
print (a == b)
# == !=  >  <  >=  <=

print "赋值运算"
c += a      # 等价于 c = c + a
# +  -  *  /  %  **  //
a = 2
c = 3
c **= a     # c = c ** a
print c

print "位运算"
a = 10      # 0b1010
b = 7       # 0b0111
c = a & b
c = a | b
c = ~a      # 1b0101  dec:-11
print c
c = a ^ b
c = a << 1
c = b >> 1

print "逻辑运算"
a = 10
b = 20
# 0为false 非0为ture
print (a and b)     # 如果a为false 返回false 否则返回b的值  &&
print (a or b)      # 如果a为true 返回a的值 否则返回b的值    ||
print (not a)       # a为ture则返回false 否则返回true       !

print "成员运算"
l1 = [1, 2, 3, 4, 5]
print (3 in l1)
print (5 not in l1)
print (9 in l1)
