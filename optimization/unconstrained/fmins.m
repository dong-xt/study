function [x,y,t] = fmins(n1,m1,no,x0,a0,e) %多维搜索函数

t=0;
if(n1==1) %梯度法
    x2=x0; x1=x2-e;
    while(norm(x2-x1)>=e)
        x1=x2; d=-g(no,x1); 
        x2=fmin(m1,no,x1,d,a0,e);t=t+1;
    end
    x=x2;y=f(no,x2,1,0);
elseif(n1==2) %阻尼牛顿法
    x2=x0; x1=x2-e;
    while(norm(x2-x1)>=e)
        x1=x2; df = g(no,x1); df2 = g2(no,x1); df2v = inv(df2); d=-df2v * df;
        x2=fmin(m1,no,x1,d,a0,e);t=t+1;
    end
    x=x2;y=f(no,x2,1,0);
elseif(n1==3) %共轭梯度法
    x2=x0;gb=g(no,x2);d2=-gb;k=0;
    while(norm(gb)>=e)
        x1=x2; ga=gb;d1=d2;x2=fmin(m1,no,x1,d2,a0,e); 
        if(k==2)
            k=0; gb=g(no,x2);d2=-gb;
        else
            gb=g(no,x2);
            b=(norm(gb)^2)/(norm(ga)^2);
            d2=-ga+b*d1;
            k=k+1;
        end
        t=t+1;
    end
    x=x2;y=f(no,x2,1,0);
elseif(n1==4) %鲍威尔法
    flag=1;
    x00=x0;d01=[1;0];d02=[0;1];
    while(flag==1)
       x01=fmin(m1,no,x00,d01,a0,e);
       delta1=f(no,x00,d01,a0)-f(no,x01,d01,a0);
       x02=fmin(m1,no,x01,d02,a0,e);
       delta2=f(no,x01,d02,a0)-f(no,x02,d02,a0);
       d03=x02-x00;x03=2*x02-x00;
       F0=f(no,x00,d03,a0);F2=f(no,x02,d03,a0);F3=f(no,x03,d03,a0);deltam=max(delta1,delta2);
       if(F3<F0 && (F0-2*F2+F3)*(F0-F2-deltam)<0.5*deltam*(F0-F3)^2)
           x10=fmin(m1,no,x02,d03,a0,e);
       else
           if(F2<F3)
               x10=x02;
           else
               x10=x03;
           end
       end
       if(norm(x10-x00)<=e)
           flag=0;x=x10;y=f(no,x10,1,0);
       else
           x00=x10;
       end
       t=t+1;
    end
elseif(n1==5) %变尺度法-BFGS
    x2=x0;x1=x2-e;G2=g(no,x0);H=[1,0;0,1];k=0;
    while(norm(x2-x1)>=e)
        G1=G2;d=-H*G2;x1=x2;x2=fmin(m1,no,x1,d,a0,e);
        if(k==2)
            k=0;G2=g(no,x2);H=[1,0;0,1];
        else
            G2=g(no,x2);yk=G2-G1;sk=x2-x1;
            E=((1+yk.'*H*yk/(sk.'*yk))*(sk*sk.')-H*yk*sk.'-sk*yk.'*H)/(sk.'*yk);
            H=H+E;k=k+1;
        end
        t=t+1;
    end
    x=x2;y=f(no,x2,1,0);
elseif(n1==6) %单纯形法
    x1=x0;x2=x1+[1;0];x3=x1+[0;1];
    y1=f(no,x1,1,0);y2=f(no,x2,1,0);y3=f(no,x3,1,0);flag=0;
    xl=x0;xg=x0-e;
    while(norm(xl-xg)>=e) 
        yl=min([y1,y2,y3]);yh=max([y1,y2,y3]);
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
        xn2=(xl+xg)/2;xn3=xn2+(xn2-xh);yn2=f(no,xn2,1,0);yn3=f(no,xn3,1,0);
        if(yn3<yl)
            xn4=xn2+2*(xn3-xn2);yn4=f(no,xn4,1,0);
            if(yn4<yl)
                xh=xn4;yh=yn4;
            else
                xh=xn3;yh=yn3;
            end
        elseif(yn3>yl && yn3<yg)
            xh=xn3;yh=yn3;
        elseif(yn3>yg)
            if(yn3<yh)
                xn5=xn2+0.5*(xn3-xn2);yn5=f(no,xn5,1,0);
            else
                xn5=xn2+0.5*(xh-xn2);yn5=f(no,xn5,1,0);
            end
            if(yn5<yh)
                xh=xn5;yh=yn5;
            else
                x1=xl+0.5*(x1-xl);x2=xl+0.5*(x2-xl);x3=xl+0.5*(x3-xl);
                y1=f(no,x1,1,0);y2=f(no,x2,1,0);y3=f(no,x3,1,0);flag=1;
            end
        end
        if(flag==1)
            flag=0;
        else
            x1=xl;x2=xh;x3=xg;y1=yl;y2=yh;y3=yg;
        end
        t=t+1;
    end
    x=xl;y=f(no,x,1,0);
end
