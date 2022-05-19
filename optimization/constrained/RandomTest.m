%min f(x,y)=(x-7)*(x-7)+(y-3)*(y-3)	
%s.t.	g1(x,y)=x*x+y*y-10<=0				
%       g2(x,y)=x+y-4<=0
%		g3(x,y)=-y<=0
function [x,y]=RandomTest() %随机试验法

N=1000;%随机点个数
rs=zeros(N,3);
x10=unifrnd(0,6,N,1);
x20=unifrnd(0,2,N,1);
limit1=[0,6];limit2=[0,2];
while(1)
for i=1:1:N    %筛选符合要求的点
    while(x10(i)^2+x20(i)^2-10>0 || x10(i)+x20(i)-4>0 || x20(i)<0)
        x10(i)=unifrnd(limit1(1),limit1(2),1,1);
        x20(i)=unifrnd(limit2(1),limit2(2),1,1);
    end
    rs(i,1)=x10(i);rs(i,2)=x20(i);
    rs(i,3)=(x10(i)-7)^2+(x20(i)-3)^2;
end
rs=sortrows(rs,3); %根据函数值排序
xm=mean(rs(1:10,:),1);d1=std(rs(1:10,1));d2=std(rs(1:10,2));%计算平均值和标准差
if(d1<0.001 && d2<0.001) %判断是否收敛 若是不收敛选择新的边界
    break;
else
    limit1=[xm(1)-3*d1,xm(1)+3*d1];
    limit2=[xm(2)-3*d2,xm(2)+3*d2];
    x10=unifrnd(xm(1)-3*d1,xm(1)+3*d1,N,1);
    x20=unifrnd(xm(2)-3*d2,xm(2)+3*d2,N,1);
end
end
x=[rs(1,1),rs(1,2)];
y=rs(1,3);



