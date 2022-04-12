%求搜索区间的函数
function [a,b,m,hf] = range(no,x0,d,h0)

h = h0;
a1 = 0; y1 = f(no,x0,d,a1);
a2 = a1 + h; y2 = f(no,x0,d,a2);
if(y1 < y2)
    h = -h; %后退
    a3 = a1; a1 = a2; a2 = a3; %互换a1-a2 y1-y2
    y3 = y1; y1 = y2; y2 = y3;
end
a3 = a2 + h; y3 = f(no,x0,d,a3);
while(y2 > y3)  %寻找高低高
    h = h * 2;
    a1 = a2; y1 = y2; a2 = a3; y2 = y3;
    a3 = a2 + h; y3 = f(no,x0,d,a3);
end
if(a3<a1)
    a=a1;y=y3;a1=a3;y1=y3;a3=a;y3=y;
end
a = min(a1,a3);
b = max(a3,a1);
m = a2;
hf = h;