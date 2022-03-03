function [des,times] = fmin(method,obj,init,degree)

step = 1; %设定步长
[a,b] = range(obj,init,step); %确定搜索范围

if(method == 1) %黄金分割法
    i = 0.618; t = 0;
    a1 = b - i * (b - a); y1 = func(obj,a1);
    a2 = a + i * (b - a); y2 = func(obj,a2);
    while(b - a > degree) %判断是否达到精度
        t = t + 1; %计迭代次数
        if(y1 > y2)
            a = a1;
            a1 = a2; y1 = y2;
            a2 = a + i * (b - a); y2 = func(obj,a2);
        else
            b = a2;
            a2 = a1; y2 = y1;
            a1 = b - i * (b - a); y1 = func(obj,a1);
        end
    end
    des = 0.5 * (a + b); times = t;
elseif(method == 2) %平分法
    des = 0;
end