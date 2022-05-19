%min f(x,y)=(x-7)*(x-7)+(y-3)*(y-3)	
%s.t.	g1(x,y)=x*x+y*y-10<=0				
%       g2(x,y)=x+y-4<=0
%		g3(x,y)=-y<=0
function [x,y]=RandomDir()  %随机方向法

N=1000;
x0=[0;0];a0=1;flag=0;fmin=inf;
while(1)
dir=unifrnd(-1,1,2,N);%生成随机方向
for i=1:1:N    %寻找下降最快方向
    dir(:,i)=dir(:,i)/norm(dir(:,i));
    x1=x0+a0*dir(:,i);f0=(x0(1)-7)^2+(x0(2)-3)^2;f1=(x1(1)-7)^2+(x1(2)-3)^2;
    if(x1(1)^2+x1(2)^2-10<=0 && x1(1)+x1(2)-4<=0 && x1(2)>=0)
        if(f1<f0 && f1 < fmin)
            xmin=x1;fmin=f1;flag=1;
        end
    end
end
if(flag==0) %如果没找到下降方向 缩小步长
    a0=0.67*a0;
else
    d=xmin-x0;x0=xmin;f0=fmin;
    while(1) %从最速下降方向开始找到该方向最小值
        a0=1.33*a0;x1=x0+a0*d;f1=(x1(1)-7)^2+(x1(2)-3)^2;
        if(f1<f0 && x1(1)^2+x1(2)^2-10<=0 && x1(1)+x1(2)-4<=0 && x1(2)>=0)
            x0=x1;f0=f1;
        else
            flag=0;fmin=inf;break;
        end
    end
end
if(abs(f1-f0)<=0.001 && norm(x1-x0)<=0.001) %判断是否收敛
    break;
end
end
x=x0;y=f0;