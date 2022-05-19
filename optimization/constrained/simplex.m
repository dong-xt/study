%min f(x,y)=(x-7)*(x-7)+(y-3)*(y-3)	
%s.t.	g1(x,y)=x*x+y*y-10<=0				
%       g2(x,y)=x+y-4<=0
%		g3(x,y)=-y<=0
function [x,y]=simplex() %复合形法

a=[0;0];b=[6;2];A=1;flag=1;x1=[0;0];x2=[0;0];x3=[0;0];
while(1)
    if(flag==1)
        x11=unifrnd(a(1),b(1),1,1);x12=unifrnd(a(2),b(2),1,1); %随机生成第一个点
        while(x11^2+x12^2-10>0 || x11+x12-4>0 || x12<0)
            x11=unifrnd(a(1),b(1),1,1);x12=unifrnd(a(2),b(2),1,1);
        end
        x1=[x11;x12];xc=x1;
        rd1=rand(2,1);rd2=rand(2,1);x2=a+rd1.*(b-a);x3=a+rd2.*(b-a); %随机生成另外两个点构成单纯形
        while(x2(1)^2+x2(2)^2-10>0 || x2(1)+x2(2)-4>0 || x2(2)<0) %对不满足约束的点修订
            x2=xc+0.5*(x2-xc);
        end
        xc=(x1+x2)/2;
        while(x3(1)^2+x3(2)^2-10>0 || x3(1)+x3(2)-4>0 || x3(2)<0)
            x3=xc+0.5*(x3-xc);
        end
        y1=(x1(1)-7)^2+(x1(2)-3)^2;y2=(x2(1)-7)^2+(x2(2)-3)^2;y3=(x3(1)-7)^2+(x3(2)-3)^2;flag=2;
    end
    if(flag==2)
        yl=min([y1,y2,y3]);yh=max([y1,y2,y3]);%排序出最优点 最差点 次差点
        if(yl==y1&&yh==y2)
            xl=x1;xh=x2;xg=x3;yg=y3;
        elseif(yl==y1&&yh==y3)
            xl=x1;xh=x3;xg=x2;yg=y2;
        elseif(yl==y2&&yh==y1)
            xl=x2;xh=x1;xg=x3;yg=y3;
        elseif(yl==y2&&yh==y3)
            xl=x2;xh=x3;xg=x1;yg=y1;
        elseif(yl==y3&&yh==y1)
            xl=x3;xh=x1;xg=x2;yg=y2;
        elseif(yl==y3&&yh==y2)
            xl=x3;xh=x2;xg=x1;yg=y1;
        end
        if(sqrt(((yg-yl)^2+(yh-yl)^2)/2)<=0.001) %判断是否收敛
            break;
        end
        flag=3;
    end
    if(flag==3)
        xc=(xl+xg)/2; %求中心点
        if(xc(1)^2+xc(2)^2-10>0 || xc(1)+xc(2)-4>0 || xc(2)<0) %中心点不满足约束 
            a=xl;b=xc;flag=1;
        else
            xr=xc+A*(xc-xh); %反射
            while(1)
                if(xr(1)^2+xr(2)^2-10>0 || xr(1)+xr(2)-4>0 || xr(2)<0) %调整反射点满足约束及函数值减小
                    A=0.7*A;xr=xc+A*(xc-xh);
                else
                    yr=(xr(1)-7)^2+(xr(2)-3)^2;
                    if(yr<yh)
                        xh=xr;yh=yr;x1=xl;y1=yl;x2=xg;y2=yg;x3=xh;y3=yh;flag=2;break;
                    else
                        A=0.7*A;xr=xc+A*(xc-xh);
                    end                         
                end           
            end
        end
    end
end
x=xl;y=yl;