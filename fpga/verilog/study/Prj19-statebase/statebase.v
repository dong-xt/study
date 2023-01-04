module statebase(
    clk    ,
    rst_n  ,
    en     ,
    
    state_c
    );

    parameter      IDLE =         2'b00;
    parameter      S1   =         2'b01;
    parameter      S2   =         2'b10;

    input               clk    ;
    input               rst_n  ;
    input               en     ;

    output[1:0]       state_c  ;

    reg   [1:0]       state_c  ;
    reg   [1:0]       state_n  ;
    
    wire              idl2s1_start;
    wire              s12s2_start;
    wire              s22idl_start;

//四段式状态机

//第一段：同步时序always模块，格式化描述次态寄存器迁移到现态寄存器(不需更改）
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        state_c <= IDLE;
    end
    else begin
        state_c <= state_n;
    end
end

//第二段：组合逻辑always模块，描述状态转移条件判断
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
//第三段：设计转移条件
assign idl2s1_start  = state_c==IDLE && en == 1;
assign s12s2_start   = state_c==S1   && en == 1;
assign s22idl_start  = state_c==S2   && en == 1;

    endmodule

