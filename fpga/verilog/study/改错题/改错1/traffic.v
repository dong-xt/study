//交通灯控制器

module traffic(clk,en,lampa,lampb,acount,bcount);

input clk;
input en;

output [3:0] lampa;
output [3:0] lampb;

output [3:0] acount;
output [3:0] bcount;

reg [10:0]numa;
reg [10:0]numb;
reg [7:0] ared;
reg [7:0] ayellow;
reg [7:0] agreen;
reg [7:0] aleft;
reg [7:0] bred;
reg [7:0] byellow;
reg [7:0] bgreen;
reg [7:0] bleft;
reg [3:0] lampa;
reg [3:0] lampb;
reg       tempa;

reg [2:0] counta;
wire [2:0] countb;
//将numa 和 numb的信号传递给数码管输出(即数码管显示交通灯计时情况)
assign acount=numa;
assign bcount=numb;
//信号en为低位时  对各个交通灯的计数值进行初始化
always  @(en)begin
    if(!en)begin
        ared<=8'd55;
        ayellow<=8'd5;
        agreen<=8'd40;
        aleft<=8'd15;
        bred<=8'd65;
        byellow<=8'd5;
        bleft<=8'd15;
        bgreen<=8'd30;
    end
end
//在en有效的情况下 判断tempa的值 为1 则表示不在变化状态 为零则表示在变化状态 在变化状态 判断counta 的四个状态 决定哪盏交通灯亮
always  @(posedge clk)begin
    if(en)begin
        if(!tempa)begin
            tempa<=1;
            case(counta)
                0:begin
                    numa=agreen;
                    lampa<=4'b0010;
                    counta<=1;
                end
                1: begin				//状态1
					numa=ayellow;	//黄灯亮
					lampa<=4'b0100;			//输出0100
					counta<=2;		//进入下一个状态
                end
				2: begin				//状态2
					numa=aleft;		//左转绿灯亮
					lampa<=4'b0001;			//输出0001
					counta<=3;		//进入下一个状态
				end
				3: begin				//状态3
					numa=ayellow;	//黄灯亮
					lampa<=4'b0100;		//输出0100
					counta<=4;		//进入下一个状态
				end
				4: begin			//状态4
					numa=ared;		//红灯亮
					lampa<=4'b1000;	//输出1000
					counta<=0;		//进入下一个状态（状态0）
				end
				default:			//默认状态
					lampa<=4'b1000;	//红灯亮，输出1000
                end
			endcase
		end
		else begin 					//每一个状态的倒计时
			if(numa>1)				//判断倒计时未归零时分别对高地位进行递减
				if(numa[3:0]==0) begin
					numa[3:0]=4'b1001;
					numa[7:4]<=numa[7:4]-1;
				end
				else
					numa[3:0]=numa[3:0]-1;
			if (numa==2)
				tempa<=0;		//倒计时结束，返回灯状态变化判断，将进入下一个状态
		end
	end
	else begin
		lampa<=4'b1000;		//使能无效时，红灯亮
		counta<=0;			//返回方向A的状态0(绿灯状态)
		tempa<=0;				//进入状态变化判断
	end
end
    end
   	else begin
		lampa<=4'b1000;		//使能无效时，红灯亮
		counta<=0;			//返回方向A的状态0(绿灯状态)
		tempa<=0;				//进入状态变化判断
	end
end
	
		//控制B方向四种灯的模块，模块的语言描述与方向A的描述基本一致，这里不再重复注释，
		always @(posedge CLK) begin 
			if (EN) begin
				if(!tempb) begin
					tempb<=1;
					case (countb) 
						0: begin
							numb<=bred;
							lampb<=8;
							countb<=1;
						end
						1: begin
							numb<=bgreen;
							lampb<=2;
							countb<=2;
						end
						2: begin
							numb<=byellow;
							lampb<=4;
							countb<=3;
						end
						3: begin
							numb<=bleft;
							lampb<=1;
							countb<=4;
						end
						4: begin
							numb<=byellow;
							lampb<=4;
							countb<=0;
						end
						default:
							lampb<=8;
					endcase
				end
				else begin //倒计时
					if(numb>1)
						if(!numb[3:0]) begin
							numb[3:0]<=9;
							numb[7:4]<=numb[7:4]-1;
						end
					else
						numb[3:0]<=numb[3:0]-1;
					if(numb==2)
						tempb<=0;
				end
			end
			else begin
				LAMPB<=4'b1000;
				tempb<=0;
				countb<=0;
			end
		end
endmodule
