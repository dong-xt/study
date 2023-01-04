module ctrltimer(
    clk    ,
    rst_n  ,
    key    ,
    key_r1 ,
    segment,
    seg_sel    
    );

    parameter      TIME_1S   =  50000000 ;
    parameter      TIME_20US =  1000     ;
    parameter      TIME_20MS =  1000000  ;
    
    //segment 0---9
    parameter      DATA0   = 8'B01000000;
    parameter      DATA1   = 8'B01111001;
    parameter      DATA2   = 8'B00100100;
    parameter      DATA3   = 8'B00110000;
    parameter      DATA4   = 8'B00011001;
    parameter      DATA5   = 8'B00010010;
    parameter      DATA6   = 8'B00000010;
    parameter      DATA7   = 8'B01111000;
    parameter      DATA8   = 8'B00000000;
    parameter      DATA9   = 8'B00010000;

    input               clk    ;
    input               rst_n  ;
    input               key    ;
    output              key_r1 ;
    output[7:0]         segment ;
    output[7:0]         seg_sel ;


    wire                key_r1  ;    
    reg   [7:0]         segment ;
    reg   [7:0]         seg_sel ;
	 
	 
	 reg   [3:0]		   cnt_miao_ge ;
	 reg   [3:0]			cnt_miao_shi;
	 reg   [3:0]			cnt_fen_ge  ;
	 reg   [3:0]			cnt_fen_shi ;
	 reg   [3:0]			cnt_shi_ge  ;
	 reg   [3:0]			cnt_shi_shi ;
	 
	 reg   [9:0]			count_20us  ;
	 reg   [19:0]			count_20ms	;
	 reg   [25:0]			count_1s 	;
	 
	 reg   [3:0]			sel			;
	 reg   [3:0]			sel_ff0		;
	 reg   [3:0]			sel_result	;
	 
	 reg 						pause			 ;
	 wire						flag_20ms	 ;
	 reg						flag_20ms_ff0;
	 reg						key_en		 ;
	 

    /*********************************timer**********************/
    //miao/////////////////////
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cnt_miao_ge <= 0;
        end
        else if(count_1s == TIME_1S - 1) begin
            if(cnt_miao_ge == 9)
                cnt_miao_ge <= 0;
            else
                cnt_miao_ge <= cnt_miao_ge + 1;
        end
    end
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cnt_miao_shi <= 0;
        end
        else if(cnt_miao_ge == 9 && count_1s == TIME_1S - 1) begin
            if(cnt_miao_shi == 5)
                cnt_miao_shi <= 0;
            else
                cnt_miao_shi <= cnt_miao_shi + 1;
        end
    end
    //fen/////////////////////
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cnt_fen_ge <= 0;
        end
        else if(cnt_miao_shi == 5 && cnt_miao_ge == 9 && count_1s == TIME_1S - 1) begin
            if(cnt_fen_ge == 9)
                cnt_fen_ge <= 0;
            else
                cnt_fen_ge <= cnt_fen_ge + 1;
        end
    end
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cnt_fen_shi <= 0;
        end
        else if(cnt_fen_ge == 9 && cnt_miao_shi == 5 && cnt_miao_ge == 9 && count_1s == TIME_1S - 1) begin
            if(cnt_fen_shi == 5)
                cnt_fen_shi <= 0;
            else
                cnt_fen_shi <= cnt_fen_shi + 1;
        end
    end
    //shi///////////////////////
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cnt_shi_ge <= 0;
        end
        else if(cnt_fen_shi == 5 &&cnt_fen_ge == 9 && cnt_miao_shi == 5 && cnt_miao_ge == 9 && count_1s == TIME_1S - 1) begin
            if((cnt_shi_shi == 0||cnt_shi_shi == 1) && cnt_shi_ge == 9)
                cnt_shi_ge <= 0;
            else
                if(cnt_shi_shi == 2 && cnt_shi_ge == 3)
                    cnt_shi_ge <= 0;
                else
                    cnt_shi_ge <= cnt_shi_ge + 1;
        end
    end
    always@(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            cnt_shi_shi <= 0;
        end
        else if(cnt_shi_shi == 2 && cnt_shi_ge == 3 && cnt_fen_shi == 5 &&cnt_fen_ge == 9 && cnt_miao_shi == 5 && cnt_miao_ge == 9 && count_1s == TIME_1S - 1) begin
            cnt_shi_shi <= 0;
        end
        else if( cnt_fen_shi == 5 &&cnt_fen_ge == 9 && cnt_miao_shi == 5 && cnt_miao_ge == 9 && count_1s == TIME_1S - 1) begin
            cnt_shi_shi <= cnt_shi_shi + 1;
        end
    end

    /************************refresh************************************/
	 //frequence 20us
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            count_20us <= 0;
        end
        else begin
            if(count_20us == TIME_20US-1)
                count_20us <= 0;
            else
                count_20us <= count_20us + 1;
        end
    end
	 //refresh cnt
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            sel <= 0;
        end
        else if(count_20us == TIME_20US-1)begin
            if(sel == 5)
                sel <= 0;
            else
                sel <= sel + 1;
        end
    end
	 //jilu shuzhi
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            sel_result <= 0;
        end
        else if(sel == 0) begin
            sel_result <= cnt_shi_shi;
        end
        else if(sel == 1) begin
            sel_result <= cnt_shi_ge;
        end
        else if(sel == 2) begin
            sel_result <= cnt_fen_shi;
        end
        else if(sel == 3) begin
            sel_result <= cnt_fen_ge;
        end
        else if(sel == 4) begin
            sel_result <= cnt_miao_shi;
        end
        else if(sel == 5) begin
            sel_result <= cnt_miao_ge;
        end        
    end
	 //choose segment    shixuduiqi
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            sel_ff0 <= 0;
        end
        else begin
            sel_ff0 <= sel;
        end
    end
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            seg_sel <= 8'hfe;
        end
        else begin
            seg_sel <= ~(8'b1 << sel_ff0);
        end
    end
	 //decode
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            segment <= DATA0;
        end
        else begin
            case(sel_result)
                0: segment <= DATA0;
                1: segment <= DATA1;
                2: segment <= DATA2;
                3: segment <= DATA3;
                4: segment <= DATA4;
                5: segment <= DATA5;
                6: segment <= DATA6;
                7: segment <= DATA7;
                8: segment <= DATA8;
                9: segment <= DATA9;
                default:segment <= 8'hff;
				endcase
        end
    end

    /**************control***********************/
	 //control cnt//////////////
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            count_1s <= 0;
        end
        else if(pause==0) begin
            if(count_1s == TIME_1S - 1)
                count_1s <= 0;
            else
                count_1s <= count_1s + 1;
        end
    end    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            pause <= 0;
        end
        else if(key_en) begin
            pause <= ~pause; 
        end
    end
    //clear tick/////////////////
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            count_20ms <= 0;
        end
        else if(key == 1) begin
            count_20ms <= 0;
        end
        else begin
            if(count_20ms == TIME_20MS - 1)
                count_20ms <= count_20ms;
            else
                count_20ms <= count_20ms + 1;
        end
    end        
    assign flag_20ms = (count_20ms >= TIME_20MS - 1);
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            flag_20ms_ff0 <= 1'b0;
        end
        else begin
            flag_20ms_ff0 <= flag_20ms;
        end
    end
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            key_en <= 1'b0;
        end
        else if(flag_20ms == 1'b1 && flag_20ms_ff0 == 1'b0) begin
            key_en <= 1'b1;
        end
        else begin
            key_en <= 1'b0;
        end
    end
	//juzhen anjian  S1
    assign key_r1 = 0;

    endmodule

