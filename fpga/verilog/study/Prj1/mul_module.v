module mul_module(
    mul_a,
    mul_b,
    clk  ,
    rst_n,
    mul_result
    );

    parameter  A_W = 4;
    parameter  B_W = 3;
    parameter  C_W = A_W + B_W;

    input[A_W-1:0]  mul_a;
    input[B_W-1:0]  mul_b;
    input       clk;
    input       rst_n;

    output[C_W-1:0] mul_result;
    reg   [C_W-1:0] mul_result;
    reg   [C_W-1:0] mul_result_tmp;

    always  @(*)begin
        mul_result_tmp = mul_a * mul_b;
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            mul_result <= 0;
        end
        else begin
            mul_result <= mul_result_tmp;
        end
    end


endmodule
