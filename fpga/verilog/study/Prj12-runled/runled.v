module runled(
    clk    ,
    rst_n  ,

    led
    );

    parameter      TIME_1S =  50000000;

    input               clk     ;
    input               rst_n   ;

    output[11:0]        led     ;

    reg   [11:0]        led     ;
    reg   [25:0]        cnt     ;

    wire                time_1s ;
	 //count 1 second
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt <= 0;
        end
        else begin
            if(time_1s)
                cnt <= 0;
            else
                cnt <= cnt + 1;
        end
    end
    //1s count end  and   led changes   
    assign time_1s = cnt == TIME_1S-1;   
		
	 
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            led <= 12'h1;
        end
        else if(time_1s) begin
            led <= {led[10:0],led[11]};
        end
        else begin
            led <= led;
        end
    end

    endmodule

