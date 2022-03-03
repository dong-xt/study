function y = func(obj,x)

if(obj == 1)
    y = x^4 - 4*(x^3) - 6*(x^2) - 16*x + 4; 
    %y = x*x*x*x - 4*x*x*x - 6*x*x - 16*x + 4;
elseif(obj == 2)
    y = x^2 + exp(-x);
elseif(obj == 3)
    y = x^4 - x^2 - 2^x + 5;
end