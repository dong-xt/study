//��ͨ�ƿ�����

module traffic(clk,en,lampa,lampb,acount,bcount);

input clk;
input en;

output [3:0] lampa;
output [3:0] lampb;

output [3:0] acount;
output [3:0] bcount;

reg [10:0] numa;
reg [10:0] numb;
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
reg       tempb;

reg [2:0] counta;
reg [2:0] countb;
//��numa �� numb���źŴ��ݸ�����������(����������ʾ��ͨ�Ƽ�ʱ����)
assign acount=numa;
assign bcount=numb;
//�ź�enΪ��λʱ  �Ը�����ͨ�Ƶļ���ֵ���г�ʼ��
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
//��en��Ч�������� �ж�tempa��ֵ Ϊ1 ����ʾ���ڱ仯״̬ Ϊ������ʾ�ڱ仯״̬ �ڱ仯״̬ �ж�counta ���ĸ�״̬ ������յ��ͨ����
always  @(posedge clk)begin
    if(en)begin
        if(!tempa)begin
            tempa<=1;
            case(counta)
                0:begin
                    numa<=agreen;
                    lampa<=4'b0010;
                    counta<=1;
                end
                1: begin				//״̬1
					numa<=ayellow;	//�Ƶ���
					lampa<=4'b0100;			//����0100
					counta<=2;		//������һ��״̬
                end
				2: begin				//״̬2
					numa<=aleft;		//��ת�̵���
					lampa<=4'b0001;			//����0001
					counta<=3;		//������һ��״̬
				end
				3: begin				//״̬3
					numa<=ayellow;	//�Ƶ���
					lampa<=4'b0100;		//����0100
					counta<=4;		//������һ��״̬
				end
				4: begin			//״̬4
					numa<=ared;		//������
					lampa<=4'b1000;	//����1000
					counta<=0;		//������һ��״̬��״̬0��
				end
				default:			//Ĭ��״̬
					lampa<=4'b1000;	//�����������1000
			endcase
		end
		else begin 					//ÿһ��״̬�ĵ���ʱ
			if(numa>1)				//�жϵ���ʱδ����ʱ�ֱ��Ըߵ�λ���еݼ�
				if(numa[3:0]==0) begin
					numa[3:0]<=4'b1001;
					numa[7:4]<=numa[7:4]-1;
				end
				else
					numa[3:0]<=numa[3:0]-1;
			if (numa==2)
				tempa<=0;		//����ʱ���������ص�״̬�仯�жϣ���������һ��״̬
		end
	end
	else begin
		lampa<=4'b1000;		//ʹ����Чʱ��������
		counta<=0;			//���ط���A��״̬0(�̵�״̬)
		tempa<=0;				//����״̬�仯�ж�
	end
end
	
		//����B�������ֵƵ�ģ�飬ģ�������������뷽��A����������һ�£����ﲻ���ظ�ע�ͣ�
		always @(posedge clk) begin 
			if (en) begin
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
				else begin //����ʱ
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
				lampb<=4'b1000;
				tempb<=0;
				countb<=0;
			end
		end
endmodule
