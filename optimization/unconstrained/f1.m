function y=f1(no,x0,d,a) %求一阶方向导数
x=x0+a*d;
if(no==1)
    y= (2*x(1)-2*x(2)-4)*d(1) + (4*x(2)-2*x(1))*d(2);
elseif(no==2)
    y= (4*x(1)^3-4*x(1)*x(2)-2*x(2)+2*x(1)+4.5)*d(1) + (-2*x(1)^2-2*x(1)+4*x(2)-4)*d(2);
elseif(no==3)
    y=(4*(x(1)-2)^3+2*(x(1)-2*x(2)))*d(1) + (-4*(x(1)-2*x(2)))*d(2);
end