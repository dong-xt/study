module circle_test2(
        clk    ,
        rst_n  ,

        in0    ,
        in1    ,
        in2    ,

        out0   ,
        out1
);

parameter      DATA_W =  8;

input               clk    ;
input               rst_n  ;

input[DATA_W-1:0]   in0    ;
input[DATA_W-1:0]   in1    ;
input[DATA_W-1:0]   in2    ;

output[DATA_W-1:0]  out0   ;
output[DATA_W-1:0]  out1   ;

reg   [DATA_W-1:0]  out0   ;
reg   [DATA_W-1:0]  out1   ;


wire  [DATA_W-1:0]  sum0w   ;
wire  [DATA_W-1:0]  sum1w   ;

wire   [DATA_W-1:0]  out0_tmp   ;
wire   [DATA_W-1:0]  out1_tmp   ;

adder#(.ADD_W(DATA_W)) adder0(
    
    .add_num1(in0),
    .add_num2(in1),

    .sum_out(sum0w)
);

adder#(.ADD_W(DATA_W)) adder1(
    
    .add_num1(in1),
    .add_num2(in2),

    .sum_out(sum1w)
);

D_trigger3#(.DATA_W(DATA_W)) Dtri3_0(
        .clk(clk)       ,
        .rst_n(rst_n)   ,
        .din(sum0w)	   ,

        .dout(out0_tmp)
);

D_trigger3#(.DATA_W(DATA_W)) Dtri3_1(
        .clk(clk)       ,
        .rst_n(rst_n)   ,
        .din(sum1w)	   ,

        .dout(out1_tmp)
);

always@(*)begin
    out0 = out0_tmp;
end

always@(*)begin
    out1 = out1_tmp;
end


endmodule

