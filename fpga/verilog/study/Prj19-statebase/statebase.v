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

//�Ķ�ʽ״̬��

//��һ�Σ�ͬ��ʱ��alwaysģ�飬��ʽ��������̬�Ĵ���Ǩ�Ƶ���̬�Ĵ���(������ģ�
always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        state_c <= IDLE;
    end
    else begin
        state_c <= state_n;
    end
end

//�ڶ��Σ�����߼�alwaysģ�飬����״̬ת�������ж�
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
//�����Σ����ת������
assign idl2s1_start  = state_c==IDLE && en == 1;
assign s12s2_start   = state_c==S1   && en == 1;
assign s22idl_start  = state_c==S2   && en == 1;

    endmodule

