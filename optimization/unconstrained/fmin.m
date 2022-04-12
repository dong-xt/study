%一维搜索方法函数
function [x,y] = fmin(m1,no,x0,d,a0,e)

step = a0; %设定步长
flag = 1; %迭代标志
[a,b,m,hf] = range(no,x0,d,step); %确定搜索范围

if(m1 == 1) %黄金分割法
    i = 0.618; 
    a1 = b - i * (b - a); y1 = f(no,x0,d,a1);
    a2 = a + i * (b - a); y2 = f(no,x0,d,a2);
    while(flag == 1) %判断是否迭代
        if(y1 >= y2)
            a = a1;
            a1 = a2; y1 = y2;
            a2 = a + i * (b - a); y2 = f(no,x0,d,a2);
        else
            b = a2;
            a2 = a1; y2 = y1;
            a1 = b - i * (b - a); y1 = f(no,x0,d,a1);
        end
        if(abs(a - b) <= e)
            desx = (a + b) / 2; flag = 0;
        end
    end
elseif(m1 == 2) %成功失败法
    fail = 0; h = step; xint = (a+b)/2; %选择搜索区间的中间位置作为初始值
    while(flag == 1)
        x1 = xint + h; y0 = f(no,x0,d,xint); y1 = f(no,x0,d,x1);
        if(y1 < y0) %成功
            if(fail == 0) 
                h = 2 * h; xint = x1;
            else
                xint = x1;
            end
        else %失败
            fail = 1;
            if(abs(h) < e)
                desx = xint; flag = 0;
            else
                h = -h / 4; xint = x1;
            end
        end
    end
elseif(m1 == 3) %三点二次插值法
    a1 = a; a2 = m; a3 = b; y1 = f(no,x0,d,a1); y2 = f(no,x0,d,a2); y3 = f(no,x0,d,a3);
    cnt = 0;apf = 0;
    while(flag == 1)
        c1 = (y3 - y1)/(a3 - a1); c2 = ((y2 - y1)/(a2 - a1) - c1) / (a2 - a3);
        if(c1==0 && c2==0)
            desx = a2; break;
        end
        ap = (a1 + a3 - c1/c2)/2; yp = f(no,x0,d,ap); 
        if(abs(apf-ap)<e)
            cnt = cnt + 1;
        else
            cnt = 0;
        end
        if(cnt > 5)
            desx=ap; break;
        end
        if(abs((y2-yp)/y2) < e)
            if(y2 < yp)
                desx = a2;
            else
                desx = ap;
            end
            flag = 0;
        else
            if((ap - a2) * hf > 0)
                if(y2 >= yp)
                    a1 = a2; y1 = y2; a2 = ap; y2 = yp;
                else
                    a3 = ap; y3 = yp;
                end
            else
                if(y2 >= yp)
                    a3 = a2; y3 = y2; a2 = ap; y2 = yp;
                else
                    a1 = ap; y1 = yp;
                end
            end
            apf=ap;
        end
    end
end
x = x0 + d * desx; y = f(no,x0,d,desx);

