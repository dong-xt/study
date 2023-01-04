module trafficled(
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

    reg[2:0]        led_east     ;
    reg[2:0]        led_south    ;
    reg[2:0]        led_west     ;
    reg[2:0]        led_north    ;

    reg   [25:0]        cnt     ;
    reg   [3:0]         cnt_south;
    reg   [3:0]         cnt_west;
    reg   [3:0]         cnt_north;

    wire                time_1s ;
    wire                end_cnt_east;
    wire                add_cnt_south;
    wire                end_cnt_south;
    wire                add_cnt_west;
    wire                end_cnt_west;
    wire                add_cnt_north;
    wire                end_cnt_north;

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

    assign end_cnt_east = time_1s;	

    //south count
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_south <= 0;
        end
        else if(add_cnt_south)begin
            if(end_cnt_south)
                cnt_south <= 0;
            else
                cnt_south <= cnt_south + 1;
        end
    end

    assign add_cnt_south = time_1s;       
    assign end_cnt_south = add_cnt_south && cnt_south== 2-1 ;   

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_west <= 0;
        end
        else if(add_cnt_west)begin
            if(end_cnt_west)
                cnt_west <= 0;
            else
                cnt_west <= cnt_west + 1;
        end
    end

    assign add_cnt_west = time_1s;       
    assign end_cnt_west = add_cnt_west && cnt_west== 3-1 ;       

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_north <= 0;
        end
        else if(add_cnt_north)begin
            if(end_cnt_north)
                cnt_north <= 0;
            else
                cnt_north <= cnt_north + 1;
        end
    end

    assign add_cnt_north = time_1s;       
    assign end_cnt_north = add_cnt_north && cnt_north== 4-1 ;   

	//east led
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            led_east <= 3'b110;
        end
        else if(end_cnt_east) begin
            led_east <= {led_east[1:0],led_east[2]};
        end
        else begin
            led_east <= led_east;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            led_south <= 3'b110;
        end
        else if(end_cnt_south) begin
            led_south <= {led_south[1:0],led_south[2]};
        end
        else begin
            led_south <= led_south;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            led_west <= 3'b110;
        end
        else if(end_cnt_west) begin
            led_west <= {led_west[1:0],led_west[2]};
        end
        else begin
            led_west <= led_west;
        end
    end

    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            led_north <= 3'b110;
        end
        else if(end_cnt_north) begin
            led_north <= {led_north[1:0],led_north[2]};
        end
        else begin
            led_north <= led_north;
        end
    end

    endmodule

