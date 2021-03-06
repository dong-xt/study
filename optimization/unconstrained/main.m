tic;
for i=1:1:100
[x111,y111,t111]=fmins(1,1,1,[1;1],1,0.1); %梯度法-黄金分割法-函数1-初始点[1,1]-初始步长1-精度0.1
[x121,y121,t121]=fmins(1,2,1,[1;1],1,0.1); %梯度法-成功失败法-函数1-初始点[1,1]-初始步长1-精度0.1
[x131,y131,t131]=fmins(1,3,1,[1;1],1,0.1); %梯度法-三点二次插值法-函数1-初始点[1,1]-初始步长1-精度0.1

[x112,y112,t112]=fmins(1,1,2,[-2.5;4.25],1,0.01); %梯度法-黄金分割法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x122,y122,t122]=fmins(1,2,2,[-2.5;4.25],1,0.01); %梯度法-成功失败法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x132,y132,t132]=fmins(1,3,2,[-2.5;4.25],1,0.01); %梯度法-三点二次插值法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01

[x113,y113,t113]=fmins(1,1,3,[3;1],1,0.1); %梯度法-黄金分割法-函数1-初始点[1,1]-初始步长1-精度0.1
[x123,y123,t123]=fmins(1,2,3,[3;1],1,0.1); %梯度法-成功失败法-函数1-初始点[1,1]-初始步长1-精度0.1
[x133,y133,t133]=fmins(1,3,3,[3;1],1,0.1); %梯度法-三点二次插值法-函数1-初始点[1,1]-初始步长1-精度0.1
end
toc;
tic;
for i=1:1:100
[x211,y211,t211]=fmins(2,1,1,[1;1],1,0.1); %阻尼牛顿法-黄金分割法-函数1-初始点[1,1]-初始步长1-精度0.1
[x221,y221,t221]=fmins(2,2,1,[1;1],1,0.1); %阻尼牛顿法-成功失败法-函数1-初始点[1,1]-初始步长1-精度0.1
[x231,y231,t231]=fmins(2,3,1,[1;1],1,0.1); %阻尼牛顿法-三点二次插值法-函数1-初始点[1,1]-初始步长1-精度0.1

[x212,y212,t212]=fmins(2,1,2,[-2.5;4.25],1,0.01); %阻尼牛顿法-黄金分割法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x222,y222,t222]=fmins(2,2,2,[-2.5;4.25],1,0.01); %阻尼牛顿法-成功失败法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x232,y232,t232]=fmins(2,3,2,[-2.5;4.25],1,0.01); %阻尼牛顿法-三点二次插值法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01

[x213,y213,t213]=fmins(2,1,3,[3;1],1,0.1); %阻尼牛顿法-黄金分割法-函数3-初始点[1,1]-初始步长1-精度0.1
[x223,y223,t223]=fmins(2,2,3,[3;1],1,0.1); %阻尼牛顿法-成功失败法-函数3-初始点[1,1]-初始步长1-精度0.1
[x233,y233,t233]=fmins(2,3,3,[3;1],1,0.1); %阻尼牛顿法-三点二次插值法-函数3-初始点[1,1]-初始步长1-精度0.1
end
toc;
tic;
for i=1:1:100
[x311,y311,t311]=fmins(3,1,1,[1;1],1,0.1); %共轭梯度法-黄金分割法-函数1-初始点[1,1]-初始步长1-精度0.1
[x321,y321,t321]=fmins(3,2,1,[1;1],1,0.1); %共轭梯度法-成功失败法-函数1-初始点[1,1]-初始步长1-精度0.1
[x331,y331,t331]=fmins(3,3,1,[1;1],1,0.1); %共轭梯度法-三点二次插值法-函数1-初始点[1,1]-初始步长1-精度0.1

[x312,y312,t312]=fmins(3,1,2,[-2.5;4.25],1,0.01); %共轭梯度法-黄金分割法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x322,y322,t322]=fmins(3,2,2,[-2.5;4.25],1,0.01); %共轭梯度法-成功失败法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x332,y332,t332]=fmins(3,3,2,[-2.5;4.25],1,0.01); %共轭梯度法-三点二次插值法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01

[x313,y313,t313]=fmins(3,1,3,[3;1],1,0.1); %共轭梯度法-黄金分割法-函数3-初始点[1,1]-初始步长1-精度0.1
[x323,y323,t323]=fmins(3,2,3,[3;1],1,0.1); %共轭梯度法-成功失败法-函数3-初始点[1,1]-初始步长1-精度0.1
[x333,y333,t333]=fmins(3,3,3,[3;1],1,0.1); %共轭梯度法-三点二次插值法-函数3-初始点[1,1]-初始步长1-精度0.1
end
toc;
tic;
for i=1:1:100
[x411,y411,t411]=fmins(4,1,1,[1;1],1,0.1); %鲍威尔法-黄金分割法-函数1-初始点[1,1]-初始步长1-精度0.1
[x421,y421,t421]=fmins(4,2,1,[1;1],1,0.1); %鲍威尔法-成功失败法-函数1-初始点[1,1]-初始步长1-精度0.1
[x431,y431,t431]=fmins(4,3,1,[1;1],1,0.1); %鲍威尔法-三点二次插值法-函数1-初始点[1,1]-初始步长1-精度0.1

[x412,y412,t412]=fmins(4,1,2,[-2.5;4.25],1,0.01); %鲍威尔法-黄金分割法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x422,y422,t422]=fmins(4,2,2,[-2.5;4.25],1,0.01); %鲍威尔法-成功失败法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x432,y432,t432]=fmins(4,3,2,[-2.5;4.25],1,0.01); %鲍威尔法-三点二次插值法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01

[x413,y413,t413]=fmins(4,1,3,[3;1],1,0.1); %鲍威尔法-黄金分割法-函数3-初始点[1,1]-初始步长1-精度0.1
[x423,y423,t423]=fmins(4,2,3,[3;1],1,0.1); %鲍威尔法-成功失败法-函数3-初始点[1,1]-初始步长1-精度0.1
[x433,y433,t433]=fmins(4,3,3,[3;1],1,0.1); %鲍威尔法-三点二次插值法-函数3-初始点[1,1]-初始步长1-精度0.1
end
toc; 
tic;
for i=1:1:100
[x511,y511,t511]=fmins(5,1,1,[1;1],1,0.1); %变尺度法-黄金分割法-函数1-初始点[1,1]-初始步长1-精度0.1
[x521,y521,t521]=fmins(5,2,1,[1;1],1,0.1); %变尺度法-成功失败法-函数1-初始点[1,1]-初始步长1-精度0.1
[x531,y531,t531]=fmins(5,3,1,[1;1],1,0.1); %变尺度法-三点二次插值法-函数1-初始点[1,1]-初始步长1-精度0.1

[x512,y512,t512]=fmins(5,1,2,[-2.5;4.25],1,0.01); %变尺度法-黄金分割法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x522,y522,t522]=fmins(5,2,2,[-2.5;4.25],1,0.01); %变尺度法-成功失败法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x532,y532,t532]=fmins(5,3,2,[-2.5;4.25],1,0.01); %变尺度法-三点二次插值法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01

[x513,y513,t513]=fmins(5,1,3,[3;1],1,0.1); %变尺度法-黄金分割法-函数3-初始点[1,1]-初始步长1-精度0.1
[x523,y523,t523]=fmins(5,2,3,[3;1],1,0.1); %变尺度法-成功失败法-函数3-初始点[1,1]-初始步长1-精度0.1
[x533,y533,t533]=fmins(5,3,3,[3;1],1,0.1); %变尺度法-三点二次插值法-函数3-初始点[1,1]-初始步长1-精度0.1
end
toc;
tic;
for i=1:1:100
[x611,y611,t611]=fmins(6,1,1,[1;1],1,0.1); %单纯形法-黄金分割法-函数1-初始点[1,1]-初始步长1-精度0.1
[x621,y621,t621]=fmins(6,2,1,[1;1],1,0.1); %单纯形法-成功失败法-函数1-初始点[1,1]-初始步长1-精度0.1
[x631,y631,t631]=fmins(6,3,1,[1;1],1,0.1); %单纯形法-三点二次插值法-函数1-初始点[1,1]-初始步长1-精度0.1

[x612,y612,t612]=fmins(6,1,2,[-2.5;4.25],1,0.01); %单纯形法-黄金分割法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x622,y622,t622]=fmins(6,2,2,[-2.5;4.25],1,0.01); %单纯形法-成功失败法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01
[x632,y632,t632]=fmins(6,3,2,[-2.5;4.25],1,0.01); %单纯形法-三点二次插值法-函数2-初始点[-2.5,4.25]-初始步长1-精度0.01

[x613,y613,t613]=fmins(6,1,3,[3;1],1,0.1); %单纯形法-黄金分割法-函数1-初始点[1,1]-初始步长1-精度0.1
[x623,y623,t623]=fmins(6,2,3,[3;1],1,0.1); %单纯形法-成功失败法-函数1-初始点[1,1]-初始步长1-精度0.1
[x633,y633,t633]=fmins(6,3,3,[3;1],1,0.1); %单纯形法-三点二次插值法-函数1-初始点[1,1]-初始步长1-精度0.1
end
toc;