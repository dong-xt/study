module mul2port(
    //ģ�����ж˿�
    din_a    ,
    din_b    ,
    din_c    ,
    din_d    ,
    sel_a    ,
    sel_b    ,
    clk      ,
    rst_n    ,
    result_a ,
    result_b
);

    //�����˿�
    input[2:0]  din_a;
    input[1:0]  din_b;
    input[3:0]  din_c;
    input[3:0]  din_d;
    input       sel_a;
    input       sel_b;
    input       clk  ;
    input       rst_n;
    
    //�����˿�
    output[6:0] result_a;
    output[5:0] result_b;
    
    //���ݶ��� �����ź����趨��
    //always�����ڱ�ģ���� reg
    reg [6:0] result_a;
    reg [5:0] result_b;
    //always�����ڱ�ģ���� reg
    reg [3:0] sel_dout;
    reg       sel;
    //�����õ���ģ������ wire
    wire [6:0] result_a_tmp;
    wire [5:0] result_b_tmp;

    //������a
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            result_a <= 0;
        end
        else begin 
            result_a <= result_a_tmp;
        end
    end

    //������b
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            result_b <= 0;
        end
        else begin
            result_b <= result_b_tmp;
        end
    end

    //�˷���1
    mul_module#(.A_W(3),.B_W(4)) mul_4_3(
        .mul_a      (din_a   ),
        .mul_b      (sel_dout),
        .clk        (clk     ),
        .rst_n      (rst_n   ),
        .mul_result (result_a_tmp)
    );

    //�˷���2
    mul_module#(.A_W(2),.B_W(4)) mul_4_2(
        .mul_a      (din_b   ),
        .mul_b      (sel_dout),
        .clk        (clk     ),
        .rst_n      (rst_n   ),
        .mul_result (result_b_tmp)
    );
    
    //ѡ�������źŴ�����
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            sel <= 1'b0;
        end
        else begin
            sel <= sel_a & sel_b;
        end
    end	 
	 
    //����ѡ����
    always  @(*)begin
        if(sel == 0)
            sel_dout = din_c;
        else
            sel_dout = din_d;
    end

endmodule
