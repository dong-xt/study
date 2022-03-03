function [a,b] = range(obj,init,step)

h = step;
a1 = init; y1 = func(obj,a1);
a2 = init + h; y2 = func(obj,a2);
if(y1 < y2)
    h = -h; %后退
    a3 = a1; a1 = a2; a2 = a1; %互换a1-a2 y1-y2
    y3 = y1; y1 = y2; y2 = y1;
end
a3 = a2 + h; y3 = func(obj,a3); 
while(y2 > y3)  %寻找高低高
    h = h * 2;
    a1 = a2; y1 = y2; a2 = a3; y2 = y3;
    a3 = a2 + h; y3 = func(obj,a3);
end
a = min(a1,a3);
b = max(a3,a1);
