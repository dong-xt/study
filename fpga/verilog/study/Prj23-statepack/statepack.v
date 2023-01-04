module statepack(
    clk    ,
    rst_n  ,
    din    ,

    state_c,
    dout   ,
    dout_vld,
    dout_sop,
    dout_eop
    );

    parameter      HEAD =         3'b000;
    parameter      TYPE =         3'b001;
    parameter      LEN =          3'b010;
    parameter      DATA =         3'b011;
    parameter      FCS =          3'b100;
    parameter      CTRL_PKT_LEN = 64    ;

    input               clk    ;
    input               rst_n  ;
    input[7:0]          din    ;

    output[2:0]         state_c;
    output[7:0]         dout   ;
    output              dout_vld;
    output              dout_sop;
    output              dout_eop;

    reg[2:0]         state_c;
    reg[2:0]         state_n;
    reg[3:0]         head_cnt;
    reg              head_flag;
    reg              len_cnt  ;
    reg[15:0]        data_cnt ;
    reg[1:0]         fcs_cnt  ;
    reg[7:0]         dout   ;
    reg              dout_vld;
    reg              dout_sop;
    reg              dout_eop;

 
    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            state_c <= HEAD;
        end
        else begin
            state_c <= state_n;
        end
    end


    always@(*)begin
        case(state_c)
            HEAD:begin
                if(head_cnt == 9 && din == 8'hd5)begin
                    state_n = TYPE;
                end
                else begin
                    state_n = HEAD;
                end
            end
            TYPE:begin
                if(din==0)begin
                    state_n = DATA;
                end
                else begin
                    state_n = LEN;
                end
            end
            LEN:begin
                if(len_cnt==1)begin
                    state_n = DATA;
                end
                else begin             
                    state_n = LEN;
                end
            end
            DATA:begin
                if(data_cnt == 0)begin
                    state_n = FCS;
                end
                else begin
                    state_n = DATA;
                end
            end
            FCS:begin
                if(fcs_cnt==3)begin
                    state_n = HEAD;
                end
                else begin             
                    state_n = FCS;
                end
            end            
        endcase
    end

    ////////headcnt
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            head_cnt <= 0;
        end
        else if(state_c == HEAD) begin
            if(head_flag == 0) begin
                if(din == 8'h55)
                    head_cnt <= head_cnt + 1;
                else
                    head_cnt <= 0;
            end
            else if(head_flag == 1) begin
                if(din == 8'hd5) begin
                    if(head_cnt == 9)
                        head_cnt <= 0;
                    else
                        head_cnt <= head_cnt + 1;
                end
                else if(din == 8'h55) begin
                    head_cnt <= 1;
                end
                else begin
                    head_cnt <= 0;
                end
            end
        end
        else begin
            head_cnt <= 0;
        end
    end
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            head_flag <= 1'b0;
        end
        else if(state_c == HEAD) begin
            if(head_flag == 1'b0) begin
                if(din == 8'h55)
                    head_flag <= 1'b1;//want d5
            end
            else begin
                if(din == 8'h55)
                    head_flag <= 1'b1;//want d5
                else
                    head_flag <= 1'b0;//want 55
            end
        end
        else begin
            head_flag <= 1'b0;
        end
    end

    /////////len cnt
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            len_cnt <= 1'b0;
        end
        else if(state_c == LEN ) begin
            len_cnt <= ~len_cnt;
        end
        else begin
            len_cnt <= 1'b0;
        end
    end     
    
    /////////data cnt
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            data_cnt <= 0;
        end                         
        else if(state_c == TYPE && din == 0)begin
            data_cnt <= CTRL_PKT_LEN-1;     //64-1
        end
        else if(state_c == LEN)begin
            if(len_cnt == 0) begin
                data_cnt <= {data_cnt[7:0],din};
            end
            else begin
                data_cnt <= {data_cnt[7:0],din}-1;
            end
        end
        else if(data_cnt != 0) begin
            data_cnt <= data_cnt - 1;
        end
    end

    ////////fcs cnt
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            fcs_cnt <= 0;
        end
        else if(state_c == FCS)begin
            if(fcs_cnt == 3)
                fcs_cnt <= 0;
            else
                fcs_cnt <= fcs_cnt + 1;
        end
    end


    ///////out
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout <= 0;
        end
        else begin
            dout <= din;
        end
    end
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_vld <= 1'b0;
        end
        else if(state_c != HEAD)begin
            dout_vld <= 1'b1;
        end
        else begin
            dout_vld <= 1'b0;
        end
    end
    
    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_sop <= 1'b0;
        end
        else if(state_c == TYPE)begin
            dout_sop <= 1'b1;
        end
        else begin
            dout_sop <= 1'b0;
        end
    end

    always  @(posedge clk or negedge rst_n)begin
        if(rst_n==1'b0)begin
            dout_eop <= 1'b0;
        end
        else if(state_c == FCS && fcs_cnt == 3)begin
            dout_eop <= 1'b1;
        end
        else begin
            dout_eop <= 1'b0;
        end
    end    


    endmodule

