# encoding=utf-8

i1 = 10     # 整数
f1 = 10.0   # 浮点
s1 = "dxt"  # 字符串
print i1
print f1
print s1

a1 = b1 = c1 = 1
a2, b2, c2 = 1, 2, "dxt"
print a1, b1, c1
print a2, b2, c2

# 数据类型
# 数字
i2 = 1
del i2

# 字符串
s2 = "iloveyou"      # 0 1 2 3 4 5 6 7
print s2
print s2[3]
print s2[1:5]    # 左闭右开
print s2[1:]
print s2 * 2
print s2 + "too"

# 列表：数据集合
l1 = ['u', 100.1, 3000, "times", 'love']
l2 = ['I', 1314]
print l1[1]
print l1[2:4]
print l1[3:]
print l1 * 2
print l1 + l2
print l2[0], l1[4], l1[0], l1[2:4]

# 元组:类似于列表 read only
t1 = (5, "hundred", 'm')
# 可用操作基本同列表
# not support： t1[0] = 3
#     support:  l1[2] = 5000

# 字典: key-value
d1 = {}
d1["one"] = 1
d1[2] = "two"
d1["hm"] = "student of HNU, 24 years old"
d2 = {"name": "dxt", "id": 5960, 99: "hm"}
print d1["one"]
print d1[2]
print d1
print d2.keys()
print d2.values()





