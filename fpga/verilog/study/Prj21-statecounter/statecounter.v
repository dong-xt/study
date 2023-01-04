module statecounter(
    clk    ,
    rst_n  ,
    en     ,

    state_c
    );

    parameter      IDLE =         2'B00;
    parameter      S1   =         2'B01;
    parameter      S2   =         2'B10;

    input               clk    ;
    input               rst_n  ;
    input               en     ;

    output[1:0]  state_c   ;

    reg   [1:0]  state_c   ;
    reg   [1:0]  state_n   ;
    reg   [2:0]  cnt       ;

    wire         idl2s1_start;
    wire         s12s2_start;
    wire         s22idl_start;
    wire         add_cnt;
    wire         end_cnt1;
    wire         end_cnt2;


    always@(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            state_c <= IDLE;
        end
        else begin
            state_c <= state_n;
        end
    end

    always@(*)begin
        case(state_c)
            IDLE:begin
                if(idl2s1_start)begin
                    state_n = S1;
                end
                else begin
                    state_n = state_c;
                end
            end
            S1:begin
                if(s12s2_start)begin
                    state_n = S2;
                end
                else begin
                    state_n = state_c;
                end
            end
            S2:begin
                if(s22idl_start)begin
                    state_n = IDLE;
                end
                else begin
                    state_n = state_c;
                end
            end
            default:begin
                state_n = state_c;
            end
        endcase
    end                         
    
    assign idl2s1_start  = state_c==IDLE && en == 1;
    assign s12s2_start = state_c==S1    && end_cnt1;
    assign s22idl_start  = state_c==S2    && end_cnt2;

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            cnt <= 0;
        end
        else if(state_c == S1)begin
            if(add_cnt) begin
                if(end_cnt1)
                    cnt <= 0;
                else
                    cnt <= cnt + 1;
            end
        end
		  else if(state_c == S2) begin
            if(add_cnt) begin
                if(end_cnt2)
                    cnt <= 0;
                else
                    cnt <= cnt + 1;
            end			
		  end
		  else begin
				cnt <= 0;
		  end
    end    

    assign add_cnt =  en == 1 ;       
    assign end_cnt1 = add_cnt && cnt == 5-1;   
    assign end_cnt2 = add_cnt && cnt == 7-1;

    endmodule

