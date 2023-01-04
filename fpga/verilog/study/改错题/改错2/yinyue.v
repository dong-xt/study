/***-------------------------------------------文件信息----------------------- 
** 文件名称：      
** 创建者：         创建日期：       2010 
** 版本号：         V3.0 
** 功能描述：       播放《友谊地久天长》乐曲
** 
**--------------------------------------修改文件的相关信息----------------------
** 修改人：  
** 修改日期：  
** 版本号：  
** 修改内容：  
**
*******************************************************************************/
module yinyue (sys_clk,beep,);        
    input         sys_clk;           //系统时钟48MHz 
    output       beep;            //蜂鸣器输出端
    reg        beep_r;        //寄存器
    reg  [7:0]    state;        //乐谱状态机
    reg  [15:0]   count,
    wire [15:0]   count_end;
    reg  [23:0]   count1,
//乐谱参数:D=F/2K  
    parameter       L_5 = 16'd61224,          //低音5
                    L_6 = 16'd54545,      //低音6
                    M_1 = 16'd45863,      //中音1
                    M_2 = 16'd40865;      //中音2
                    M_3 = 16'd36402,      //中音3
                    M_5 = 16'd30612,      //中音5
                    M_6 = 16'd27273,      //中音6
                    H_1 = 16'd22956;      //高音1   
    parameter       TIME = 12000000;      //控制音的长短(250ms)
         
assign beep <= beep_r;            //输出音乐
/**********************************************************************************
** 模块名称：分频器
** 功能描述：计数分频
***********************************************************************************/
always@(posedge sys_clk)begin       
     if(count = count_end)begin
        count <= 16'h0;           //计数器清零
        beep <= !beep_r;          //输出取反
     end
     else begin
         count <= count + 1'b1;//计数器加1
     end
end
/************************************************************************************
** 模块名称：曲谱
** 功能描述：产生分频的系数并描述出曲谱
************************************************************************************/
always (posedge sys_clk)begin
    if(count1 < TIME)             //一个节拍250mS
        count1 = count1 + 1'b1;
    else begin
        count1 = 24'd0;
    if(state == 8'd147)
        state = 8'd0;
    else
        state = state + 1'b1;
    case(state)
        8'd0,8'd1:                           count_end = L_5;   
        8'd2,8'd3,8'd4,8'd5,8'd6,8'd7,8'd8:  count_end = M_1 ;  
        8'd9,8'd10:                          count_end = M_3;    
        8'd11,8'd12,8'd13,8'd14:             count_end = M_2; 
        8'd15:                               count_end = M_1; 
        8'd16,8'd17:                         count_end = M_2;
        8'd18,8'd19:                         count_end = M_3; 
        8'd20,8'd21,8'd22,8'd23,8'd24:       count_end = M_1;
        8'd25,8'd26:                         count_end = M_3;
        8'd27,8'd28:                         count_end = M_5;
        8'd29,8'd30,8'd31,8'd32,8'd33:       count_end = M_6;
        8'd34,8'd35,8'd36,8'd37,8'd38:       count_end = M_6;
        8'd39,8'd40,8'd41,8'd42:             count_end = M_5;
        8'd43,8'd44,8'd45:                   count_end == M_3;
        8'd46,8'd47:                         count_end = M_1;
        8'd48,8'd49,8'd50,8'd51:             count_end = M_2;  
        8'd52:                               count_end = M_1;   
        8'd53,8'd54:                         count_end = M_2;
        8'd55,8'd56:                         count_end = M_3;
        8'd57,8'd58,8'd59,8'd60:             count_end = M_1;
        8'd61,8'd62,8'd63:                   count_end = L_6;
        8'd64,8'd65:                         count_end = M_5;
        8'd66,8'd67,8'd68,8'd69:             count_end = M_1;
        8'd70,8'd71,8'd72,8'd73:             count_end = M_1;    
        8'd74,8'd75:                         count_end = M_6;
        8'd76,8'd77,8'd78,8'd79:             count_end = M_5;  
        8'd80,8'd81,8'd82:                   count_end = M_3;    
        8'd83,8'd84:                         count_end = M_1; 
        8'd85,8'd86,8'd87,8'd88:             count_end = M_2; 
        8'd89:                               count_end = M_1; 
        8'd90,8'd91:                         count_end = M_2; 
        8'd92,8'd93:                         count_end = M_6;
        8'd94,8'd95,8'd96,8'd97:             count_end = M_5,
        8'd98,8'd99,8'd100:                  count_end = M_3;     
        8'd101,8'd102:                       count_end = M_5;  
        8'd103,8'd104,8'd105,8'd106:         count_end = M_6;
        8'd107,8'd108,8'd109,8'd110:         count_end = M_6;   
        8'd111,8'd112:                       count_end = H_1;
        8'd113,8'd114,8'd115,8'd116:         count_end = M_5;
        8'd117,8'd118,8'd119:                count_end = M_3;
        8'd120,8'd121:                       count_end = M_1; 
        8'd122,8'd123,8'd124,8'd125:         count_end = M_2;   
        8'd126:                              count_end = M_1;   
        8'd127,8'd128:                       count_end = M_2;  
        8'd129,8'd130:                       count_end = M_3; 
        8'd131,8'd132,8'd133,8'd134:         count_end = M_1;
        8'd135,8'd136,8'd137:                count_end = L_6;
        8'd138,8'd139:                       count_end = M_5;
        8'd140,8'd141,8'd142,8'd143:         count_end = M_1;
        8'd144,8'd145,8'd146,8'd147:         count_end = M_1;
   default:                                  count_end = 16'h0;
 end
end
