/************************************************************************************
�������������﹤���Ҿ������ƺ�������

����ϣ��ͨ���淶���Ͻ��Ĵ��룬ʹͬѧ�ǽӴ��������ļ��ɵ�·/FPGA���롣

�����﹤���ҳ�����ļ��Ա����������ѵ����ӭ���ɵ�·/FPGA�����߼��롣

ѧϰ����Ⱥ��97925396

*************************************************************************************/

module fifo_prj(
    clk_in       ,
    rst_n        ,
    data_in      ,
    data_in_vld  ,
    clk_out      ,
    data_out     ,
    data_out_vld ,
    b_rdy
    );

    //��������
    parameter      DATA_W =       10;

    //�����źŶ���
    input               clk_in        ;
    input               rst_n         ;
    input [DATA_W-1:0]  data_in       ;
    input               data_in_vld   ;
    input               clk_out       ;
    output[DATA_W-1:0]  data_out      ;
    output              data_out_vld  ;
    input               b_rdy         ;

    //�����ź�reg����
    reg   [DATA_W-1:0]  data_out      ;
    reg                 data_out_vld  ;

    //�м��źŶ���
    reg                 fifo_wr       ;//дFIFOʹ�ܣ�Ҫ����дʱ����ͬ��
    reg                 fifo_rd       ;//��FIFOʹ�ܣ�Ҫ������ʱ����ͬ��
    wire[DATA_W-1:0]    fifo_out      ;//FIFO���������ݣ�����ʱ����ͬ��
    wire[5:0]           rdusedw       ;//FIFO�ڲ��������ݵĸ���������ʱ����ͬ��
    wire[5:0]           wrusedw       ;//FIFO�ڲ��������ݵĸ�������дʱ����ͬ��
    wire                rdempty       ;//FIFO��ָʾ�źţ�����ʱ����ͬ��
    reg                 rdempty_ff0   ;//
    wire                wrfull        ;//FIFO��ָʾ�źţ���дʱ����ͬ��
/*********www.mdy-edu.com �������ƽ� ע�Ϳ�ʼ****************
����FIFO
**********www.mdy-edu.com �������ƽ� ע�ͽ���****************/

    my_fifo u_my_fifo(
	                  .data    (data_in ),
	                  .rdclk   (clk_out ),
	                  .rdreq   (fifo_rd ),
	                  .wrclk   (clk_in  ),
	                  .wrreq   (fifo_wr ),
	                  .q       (fifo_out),
                      .rdempty (rdempty ),
                      .wrfull  (wrfull  ),
	                  .rdusedw (rdusedw ),
	                  .wrusedw (wrusedw ) 
                  );
    
/*********www.mdy-edu.com �������ƽ� ע�Ϳ�ʼ****************
����FIFOдʹ�ܣ���С��61ʱ���һ�����ݾ�д��FIFO���������ڻ�
����61���򲻹���û�����ݣ�дʹ�ܾ���Ч��
**********www.mdy-edu.com �������ƽ� ע�ͽ���****************/

    always  @(*)begin
        if(wrusedw >=61)begin
            fifo_wr = 1'b0;
        end
        else begin
            fifo_wr = data_in_vld;
        end
    end

    always  @(posedge clk_out or negedge rst_n)begin
        if(rst_n==1'b0)begin
            rdempty_ff0 <= 1'b1;
        end
        else begin
            rdempty_ff0 <= rdempty;
        end
    end

/*********www.mdy-edu.com �������ƽ� ע�Ϳ�ʼ****************
����FIFO��ʹ�ܣ�ע���˴�һ��Ϊ�����߼���������FIFOΪ��ʱ��Ҳ��
����ȡ�Ŀ���
**********www.mdy-edu.com �������ƽ� ע�ͽ���****************/

    always  @(*)begin
         if(b_rdy==1'b1 && (rdempty_ff0==1'b0 && rdempty == 0))begin
            fifo_rd <= 1'b1;
        end
        else begin
            fifo_rd <= 1'b0;
        end
    end

    always  @(posedge clk_out or negedge rst_n)begin
        if(rst_n==1'b0)begin
            data_out_vld <= 1'b0;
        end
        else begin
            data_out_vld <= fifo_rd;
        end
    end

    always  @(posedge clk_out or negedge rst_n)begin
        if(rst_n==1'b0)begin
            data_out <= 0;
        end
        else begin
            data_out <= fifo_out;
        end
    end



endmodule

