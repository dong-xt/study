//计数器 实现自加1
module cnt_module(
    clk    ,
    rst_n  ,
    //�����ź�,����dout
    out
);

//��������
parameter      DATA_W =  4;

//�����źŶ���
input               clk    ;
input               rst_n  ;

//�����źŶ���
output[DATA_W-1:0]  out   ;

//�����ź�reg����
reg   [DATA_W-1:0]  out   ;

//�м��źŶ���
reg   [DATA_W-1:0]  out_temp;

//�����߼�д��
always@(*)begin
    out_temp = out + 1'b1;
end

//ʱ���߼�д��
always@(posedge clk or negedge rst_n)begin
if(rst_n==1'b0)begin
    out <= 0;
end
else begin
    out <= out_temp;
end
end

endmodule

