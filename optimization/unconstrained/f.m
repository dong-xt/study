function y=f(no,x0,d,a) %按方向求函数值
x=x0+a*d;
if(no==1)
    y=x(1)^2 + 2*x(2)^2 - 2*x(1)*x(2) - 4*x(1);
elseif(no==2)
    y=x(1)^4 - 2*x(1)^2*x(2) - 2*x(1)*x(2) + x(1)^2 + 2*x(2)^2 + 4.5*x(1) - 4*x(2) + 4;
elseif(no==3)
    y=0;
end