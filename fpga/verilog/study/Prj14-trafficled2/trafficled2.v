module trafficled2(
    clk    ,
    rst_n  ,

    led_east    ,
    led_south   ,
    led_west    ,
    led_north
    );

    parameter      TIME_1S =  50000000;

    input               clk     ;
    input               rst_n   ;

    output[2:0]        led_east     ;
    output[2:0]        led_south    ;
    output[2:0]        led_west     ;
    output[2:0]        led_north    ;

    reg [2:0]        led_east     ;
    reg [2:0]        led_south    ;
    wire[2:0]        led_west     ;
    wire[2:0]        led_north    ;

    reg   [25:0]        cnt     ;
	 reg   [4:0]         cnt_1s;

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

    assign time_1s = cnt == TIME_1S-1;

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_1s <= 0;
        end
        else if(time_1s) begin
            if(cnt_1s == 30-1)
                cnt_1s <= 0;
            else
                cnt_1s <= cnt_1s + 1;
        end
    end	 
	 

    ////////////////////////////////////////////////////
    //east control rst green
	 
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            led_east <= 3'b110;
        end
        else if(time_1s && cnt_1s == 10-1) begin
            led_east <= 3'b101;
        end
        else if(time_1s && cnt_1s == 15-1) begin
            led_east <= 3'b011;
        end
        else if(time_1s && cnt_1s == 30-1) begin
            led_east <= 3'b110;
        end
    end

    ////////////////////////////////////////////////////
    //south control rst red
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            led_south <= 3'b011;
        end
        else if(time_1s && cnt_1s == 15-1) begin
            led_south <= 3'b110;
        end
        else if(time_1s && cnt_1s == 25-1) begin
            led_south <= 3'b101;
        end
        else if(time_1s && cnt_1s == 30-1) begin
            led_south <= 3'b011;
        end
    end

    ////////////////////////////////////////////////////
    //west control rst green 
		assign led_west = led_east;
	 
    ////////////////////////////////////////////////////  
	 //north control rst red
		assign led_north = led_south;

    endmodule

