//计数器自加1
module cnt_module(
    clk    ,
    rst_n  ,
    out
);


parameter      DATA_W =  4;


input               clk    ;
input               rst_n  ;

output[DATA_W-1:0]  out   ;


reg   [DATA_W-1:0]  out   ;


reg   [DATA_W-1:0]  out_temp;


always@(*)begin
    out_temp = out + 1'b1;
end


always@(posedge clk or negedge rst_n)begin
if(rst_n==1'b0)begin
    out <= 0;
end
else begin
    out <= out_temp;
end
end

endmodule

