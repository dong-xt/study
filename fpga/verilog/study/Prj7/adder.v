module adder(

    add_num1,
    add_num2,

    sum_out
);


parameter      ADD_W =         8;


input[ADD_W-1:0]    add_num1  ;
input[ADD_W-1:0]    add_num2  ;

output[ADD_W-1:0]  sum_out   ;
reg   [ADD_W-1:0]  sum_out   ;

always@(*)begin
    sum_out = add_num1 + add_num2;
end

endmodule

