function y=g(no,x) %求梯度
if(no==1)
    y=[2*x(1)-2*x(2)-4; 4*x(2)-2*x(1)];
elseif(no==2)
    y=[4*x(1)^3-4*x(1)*x(2)-2*x(2)+2*x(1)+4.5; -2*x(1)^2-2*x(1)+4*x(2)-4];
elseif(no==3)
    y=0;
end
