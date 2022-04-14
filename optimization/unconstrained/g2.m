function y=g2(no,x) %求hession矩阵
if(no==1)
    y=[2,-2;-2,4];
elseif(no==2)
    y=[12*x(1)^2-4*x(2)+2, -4*x(1)-2; -4*x(1)-2, 4];
elseif(no==3)
    y=[12*(x(1)-2)^2+2,-4;-4,8];
end
