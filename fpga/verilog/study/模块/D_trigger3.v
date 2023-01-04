module D_trigger3(
        clk    ,
        rst_n  ,
        din		,

        dout
);


parameter      DATA_W =         8;

input     			    clk    ;
input					    rst_n  ;
input[DATA_W-1:0]     din    ;


output[DATA_W-1:0]  dout   ;

reg   [DATA_W-1:0]  dout   ;

reg   [DATA_W-1:0]  dtemp1   ;
reg   [DATA_W-1:0]  dtemp2   ;

always@(posedge clk or negedge rst_n)begin
if(rst_n==1'b0)begin
    dtemp1 <= 0;
end
else begin
    dtemp1 <= din;
end
end

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dtemp2 <= 0;
    end
    else begin
        dtemp2 <= dtemp1;
    end
end

always  @(posedge clk or negedge rst_n)begin
    if(rst_n==1'b0)begin
        dout <= 0;
    end
    else begin
        dout <= dtemp2;
    end
end


endmodule

