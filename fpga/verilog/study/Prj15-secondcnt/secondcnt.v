module secondcnt(
    clk    ,
    rst_n  ,

    segment,
    seg_sel
    );

    parameter      TIME_1S =  50000000  ;
    
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

    input               clk     ;
    input               rst_n   ;

    output[7:0]         segment ;
    output[7:0]         seg_sel ;

    reg   [7:0]         segment ;
    wire  [7:0]         seg_sel ;

    reg   [25:0]        cnt     ;
    reg   [3:0 ]        cnt_1s  ;

    //count 1s
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt <= 0;
        end
        else begin
            if(cnt == TIME_1S-1)
                cnt <= 0;
            else
                cnt <= cnt + 1;
        end
    end
		
    //count 10s
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt_1s <= 0;
        end
        else if(cnt == TIME_1S-1)begin
            if(cnt_1s == 10-1)
                cnt_1s <= 0;
            else
                cnt_1s <= cnt_1s + 1;
        end
    end    
    
    //choose segment
    assign seg_sel = 8'hfe;
    //give data
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            segment <= DATA0;
        end
        else begin
            case(cnt_1s)
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



    endmodule

