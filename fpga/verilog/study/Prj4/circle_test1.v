module circle_test1(
    clk    ,
    rst_n  ,
    enable ,
    datain ,

    F
    );

    //输入信号定义
    input               clk    ;
    input               rst_n  ;
    input               enable ;
    input               datain ;

    output  F   ;
    reg     F   ;

    reg                 signal1;
    reg                 D0;
    reg                 D1;
    reg                 D2;
    reg                 D2_tmp;
    reg                 D3;                

    //组合逻辑写法
    always@(*)begin
        D0 = enable & datain;
    end

    always  @(*)begin
        D2_tmp = ~D2;
    end

    always  @(*)begin
        F = D1 & D2_tmp & D3;
    end

    //时序逻辑写法
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            D1 <= 0;
        end
        else begin
            D1 <= D0;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            D2 <= 0;
        end
        else begin
            D2 <= D1;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            D3 <= 0;
        end
        else begin
            D3 <= D2;
        end
    end


    endmodule

