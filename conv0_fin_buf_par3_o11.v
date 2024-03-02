/*
	ʱ�䣺			2023.10.24
	���ܣ�			ʵ����������ͼ����
	
	��Դ���ģ�		Vivado 2023.1:	708LUT, 48LUTRAM, 803FF, 24BRAM
	
	�������ͣ�		�����ȸ���
	�汾��			1.0
	
	ʱ��			�� 200MHzʱ��
					�� new_fin_channel -> new_fin_row -> ������
					�� in_channel = x�ڼ�from_ddr_fin���������ڸ�ͨ�������ݣ����ܳ���in_channel��ʱ�ӵ�0~28ʱ����ͨ��1��������ʱ�ӵ�1~29��ͨ��1������
	
	�������Ʋ��֣�	��	����clk��clj_inv����ʱ�ӣ�ʹ��clk����BRAM��B�˿ڵ�ַ����clk_inv��ΪB�˿ڵĶ�ʱ�ӣ�������clk�������ؿ�����ǰB�˿ڵ�ַ��Ӧ�����ݿ�������һ��ʱ���õ�
					�� 	���ÿ��ͨ��ֻ����3�оͿ�ʼ�������ΪDDR���������º���һЩ�е����ݶ�ȡ����
	�ɸĽ��ķ���	��	
					�� 	�ʼ������Ǽ��в�Ҫ�����ˣ����������ڼ�����ܹ����ʼ��13�ж�������
	�޸ģ�			�� 	wire bram2_addr_eq = fin_ch2_row_cnt[4:0] == fin_rd_row_base[4:0]; �ж�����Ӧ���Ǳ����ڵĵ�һ�в��ܱ�����
	
	�޸���ͼ��		�� 
	
	����뷨��		��	��������ͬ��fifo��˼·�����ö�д��ַ���Ѿ��Ƿ��ǻ�����ĳһ�е����һ�����ݡ��Ƿ��ڴ�����������ͼĳһ�е��������	
*/
module conv0_fin_buf_par3_o11 (
	input								clk						,		//	200M
	input								rst_n					,
	
	//	����ģ�齻���ź�
	input		[1:0]					in_channel				,		//	ָʾ��ǰddr�������������������ͼ�ĸ�ͨ����,��Чֵ��Χ��1~3
	input								new_fin_channel			,		//	����������Ҫ�������������������ͼ����ͨ��
	input								new_fin_row				,		//	�������������������µ�һ������ͼ
	input								conv0_calc_ing			,		//	������ʱ���ڼ��������			
	input								fin_calc_done			,		//	��ǰ��fin������ȫ���������ˣ�Ҫ���¿�ʼ�µ�fin�㴦��һ��Ҫ����64 / 2 = 32��
	
	output	reg	[7:0]					fin_ch0_row_cnt			,		//	��ǰ������ͨ��0�Ķ��������ݣ�ȡ��5bit��Ϊдbram��high_addr����Чֵ��0~226
	output	reg	[7:0]					fin_ch1_row_cnt			,		//	fin_chx_row_cnt = y����˼��0~y-1�е���������ͼ�Ѿ����浽BRAM�ˣ��������ڻ����y�е�
	output	reg	[7:0]					fin_ch2_row_cnt			,		
	
	input	 	 [5:0]					fout_proc_chnl			,		//	��ǰ���ڴ���fout_chnl��fout_chnl+1�������ͨ�������ݣ���Ϊ���ͨ�����ж�Ϊ2
	input	 	 [5:0]					fout_proc_row			,		//	��ǰ���ڴ����������ͼ����һ�У���Чֵ��0~54
	input	 	 [5:0]					fout_proc_col			,		//	��ǰ���ڴ����������ͼ����һ�У���Чֵ��0~54
	
	output								proc_col_last			,		//	���ڴ���ǰ�е����һ������	
	output								proc_col_next_last		,		//	���ڴ���ǰ�еĵ����ڶ������ݣ��������״̬��Ŀ���ǿ��ǵ�״̬ -> ��ַ -> ����һ��������ʱ�ӵ��ӳ�
	output								proc_win_last_row		,		//	���ڴ���ǰ���ڵ����һ��
	
	//	����DDR��fin����
	output	reg							fin_buf_row0_empty		,		
	output	reg							fin_buf_row0_full		,		//	���Դ�DDR�н������ݣ���Ҫ��Ҫ�������������ݻ᲻��ѻ�û����������ͼ���ݸ�������
	output	reg							fin_buf_row1_empty		,	
	output	reg							fin_buf_row1_full		,		//	ֻ�е�fullΪ�͵�ƽʱ������BRAM�л�������
	output	reg							fin_buf_row2_empty		,	
	output	reg							fin_buf_row2_full		,
	input		[255:0]					from_ddr_fin			,		//	��ȻDDR�����100M & 256bit��������FPGA���ô�һ���Ĵ����ǽ�������
	input								fin_vld					,
	
	//	�����vecMac61��
	output	reg							vecMac11_fin_ok	,		//	��������Ҫ������ͼ���ݶ�׼������
	output		[31:0]					fin_ch0_0		,		//	�����Ż����ԣ�����ͨ�����ж�Ϊ3
	output		[31:0]					fin_ch0_1		,
	output		[31:0]					fin_ch0_2		,
	output		[31:0]					fin_ch0_3		,
	output		[31:0]					fin_ch0_4		,
	output		[31:0]					fin_ch0_5		,
	output		[31:0]					fin_ch0_6		,
	output	reg	[31:0]					fin_ch0_7		,
	output	reg	[31:0]					fin_ch0_8		,
	output	reg	[31:0]					fin_ch0_9		,
	output	reg	[31:0]					fin_ch0_10		,
										
	output		[31:0]					fin_ch1_0		,
	output		[31:0]					fin_ch1_1		,
	output		[31:0]					fin_ch1_2		,
	output		[31:0]					fin_ch1_3		,
	output		[31:0]					fin_ch1_4		,
	output		[31:0]					fin_ch1_5		,
	output		[31:0]					fin_ch1_6		,
	output	reg	[31:0]					fin_ch1_7		,
	output	reg	[31:0]					fin_ch1_8		,
	output	reg	[31:0]					fin_ch1_9		,
	output	reg	[31:0]					fin_ch1_10		,
										
	output		[31:0]					fin_ch2_0		,
	output		[31:0]					fin_ch2_1		,
	output		[31:0]					fin_ch2_2		,
	output		[31:0]					fin_ch2_3		,
	output		[31:0]					fin_ch2_4		,
	output		[31:0]					fin_ch2_5		,
	output		[31:0]					fin_ch2_6		,
	output	reg	[31:0]					fin_ch2_7		,
	output	reg	[31:0]					fin_ch2_8		,
	output	reg	[31:0]					fin_ch2_9		,
	output	reg	[31:0]					fin_ch2_10		
);

//	��Щ����������Էŵ�VH�ļ���
localparam	CONV0_STRIDE	= 	4	;
localparam	CONV0_KH		=	11	;
localparam	CONV0_KW		=	8'd11	;
localparam	CONV0_IH		=	227	;
localparam	CONV0_IW		=	227	;
localparam	CONV0_IC		=	3	;
localparam	CONV0_OH		=	55	;
localparam	CONV0_OW		=	55	;
localparam	CONV0_OC		=	64	;
localparam 	CONV0_FIN_PAR	=	3	;			//	����ͨ�����ж�Ϊ3
//localparam 	FIN_NUM			= 	232	;			//	��Ҫʵ����227������Ϊ�˼򻯴��룬��Ҫ����Ϊ8��������
localparam 	FIN_NUM_256		=	29	;			//	29 * 8 = 232

parameter	IDLE			=	3'd0;
parameter	LINE_INIT		=	3'd1;	//	��ÿ��ͨ�������һ�л���������Ϊ��ʼ�����֣���ʱ���㻹û��ʼ
parameter	WAIT_TRIGGER	=	3'd2;	//	�ȴ�д��������
parameter	WRITE_BRAM		=	3'd3;	//	����ͼ����д��BRAM����ʱ����ͻ�����ͬʱ���е�
parameter	CONV0_END		=	3'd4;	//	conv0������ȫ���������


//	���new_fin_row��new_fin_channel��������
reg new_fin_row_r;				wire new_fin_row_pos;
reg new_fin_channel_r;			wire new_fin_channel_pos;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		new_fin_row_r <= 1'b0;
		new_fin_channel_r <= 1'b0;
	end
	else 
	begin
		new_fin_row_r <= new_fin_row;
		new_fin_channel_r <= new_fin_channel;
	end
end
assign	new_fin_row_pos = new_fin_row && (~new_fin_row_r);
assign	new_fin_channel_pos = new_fin_channel && (~new_fin_channel_r);

//	�������256bit���ݴ�һ�ģ�Ŀ��������512bit������
reg	[255:0] from_ddr_fin_r	;
reg 		wr_bram_flag	;
wire		fin_last_256;					//	��ǰ�����һ��2586bit������
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		from_ddr_fin_r <= 256'd0;
		wr_bram_flag <= 1'b0;
	end
	else if (fin_last_256)					//	����Ǳ������һ�������ˣ�˵����һ��256bit�϶���������һ�����ݵĵ�512bit��256λ
	begin
		from_ddr_fin_r <= 256'd0;
		wr_bram_flag <= 1'b0;
	end
	else if (new_fin_channel_pos)			//	�����������ͼͨ��Ҫ������ô�϶���Ҫ�����
	begin
		from_ddr_fin_r <= 256'd0;
		wr_bram_flag <= 1'b0;
	end
	else if (fin_vld)
	begin
		from_ddr_fin_r <= from_ddr_fin;
		wr_bram_flag <= ~wr_bram_flag;
	end
end

//	����ָʾ��ǰ�н����˶��ٸ�256bit������
reg [4:0]	fin_cnt;						//	��Чֵ��0~28
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fin_cnt <= 5'd0;
	end
	else if (new_fin_row_pos || fin_last_256)//	���������ͼͨ�µ�һ������
	begin
		fin_cnt <= 5'd0;
	end
	else if (fin_vld)						//	fin_cnt[4:1]���Ը�bram��д��ַ��
	begin
		fin_cnt <= fin_cnt + 5'd1;	
	end
end
assign	fin_last_256 = fin_cnt == FIN_NUM_256 - 1;		

//	��ǰ�ڻ����ĸ�ͨ��������
wire [2:0]	fin_ch_sel;
assign		fin_ch_sel[0] = in_channel == 2'd1;		//	in_channel����Чֵ��Χ��1,2,3
assign		fin_ch_sel[1] = in_channel == 2'd2;
assign		fin_ch_sel[2] = in_channel == 2'd3;

//	����ͼͨ��0�Ѿ������˶�����
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fin_ch0_row_cnt <= 8'd0;
	end
	else if (fin_ch_sel[0] && fin_last_256)
	begin
		fin_ch0_row_cnt <= fin_ch0_row_cnt + 8'd1;
	end
end

//	����ͼͨ��1�Ѿ������˶�����
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fin_ch1_row_cnt <= 8'd0;
	end
	else if (fin_ch_sel[1] && fin_last_256)
	begin
		fin_ch1_row_cnt <= fin_ch1_row_cnt + 8'd1;
	end
end

//	����ͼͨ��2�Ѿ������˶�����
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fin_ch2_row_cnt <= 8'd0;
	end
	else if (fin_ch_sel[2] && fin_last_256)
	begin
		fin_ch2_row_cnt <= fin_ch2_row_cnt + 8'd1;
	end
end

//	��ddr�ж���������ͼ����д�뵽BRAM�л���
wire 			wr_bram_en		;
wire	[2:0]	wr_bram_en_i	;													//	�������ĸ�BRAM��д����
assign	wr_bram_en = (fin_vld && wr_bram_flag) || fin_last_256;						//	����д����ϣ��512bit�Լ����һ��256bit���ܻ�������
assign	wr_bram_en_i[0] = fin_ch_sel[0] && wr_bram_en;								//	ֻ�е�ǰ����bram_iд���ݲ�����������Ч�ź�ʱ������BRAMд����
assign	wr_bram_en_i[1] = fin_ch_sel[1] && wr_bram_en;
assign	wr_bram_en_i[2] = fin_ch_sel[2] && wr_bram_en;

//	����ָʾ��ǰ�Ǵ���һ�����������һ�е�����
//	������Щ����ͼ��ͨ���ĳߴ�;���˳ߴ�һ���������϶��Ͳ���������Ĵ����߼���
reg [3:0]	kernel_row_cnt;															//	ȡֵ��Χ��0~10		
assign	proc_col_last	=	fout_proc_col == CONV0_OW - 1;							//	���ڴ���ǰ�е����һ������	
assign	proc_col_next_last	=	fout_proc_col == CONV0_OW - 2;						//	���ڴ���ǰ�еĵ����ڶ������ݣ��������״̬��Ŀ���ǿ��ǵ�״̬ -> ��ַ -> ����һ��������ʱ�ӵ��ӳ�
assign	proc_win_last_row	=	kernel_row_cnt == CONV0_KH - 1;						//	�������ڴ���ǰ���ڵ����һ������					
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		kernel_row_cnt <= 4'd0;
	end
	else if (proc_win_last_row && proc_col_last)								//	���һ�е����һ�н����˲���˵���н�����
	begin
		kernel_row_cnt <= 4'd0;
	end
	else if (proc_col_last)
	begin
		kernel_row_cnt <= kernel_row_cnt + 4'd1;
	end
end

//	���ɶ�BRAM�ĵ�ַ�źţ�����Ҫ�����к��Լ�mod(col, 16)���
//	col = 0ʱstride_0Ӧ����15��col = 1ʱstride_0Ӧ����19���Դ�����
reg [7:0]	fin_rd_row;																//	ָʾ��Ҫ�����ж������ݣ���Чֵ��Χ��0~227
reg [7:0]	fin_rd_row_base;														//	ָʾ��Ҫ�����ж������ݣ���Чֵ��Χ��0~227
reg [7:0]	stride_0;
wire [7:0]  stride_1,stride_2,stride_3;									//	����ָʾ�´μ�������Ҫ��4��stride�������꣬ע�������������0~227���־���ֵ����
reg [3:0]	addrb_0 = 0, addrb_1 = 0, addrb_2 = 0, addrb_3 = 0, addrb_4 = 0,addrb_5 = 0, addrb_6 = 0, addrb_7 = 0;	
reg [3:0]	addrb_8 = 0, addrb_9 = 0, addrb_10 = 0, addrb_11 = 0, addrb_12 = 0,addrb_13 = 0, addrb_14 = 0, addrb_15 = 0;
assign	stride_1 = stride_0 + 8'd1;		assign	stride_2 = stride_0 + 8'd2;		assign	stride_3 = stride_0 + 8'd3;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fin_rd_row <= 8'd0;
		fin_rd_row_base <= 8'd0;
		stride_0 <= CONV0_KW;
	end
	else if (proc_win_last_row && proc_col_next_last)					//	���ڴ���ǰ�������һ�еĵ����ڶ�������
	begin
		fin_rd_row <= fin_rd_row - 8'd6;														//	KH -1 - STRIDE = 11 - 1 - 4 = 6, -1��ԭ���Ǽ������Ǵ�0~10,�ټ�ȥSTRIDE��˵����ǰwin�����һ������һ��win��ʼ�ĵ�һ�еľ���
		fin_rd_row_base <= fin_rd_row - 8'd6;														//	KH -1 - STRIDE = 11 - 1 - 4 = 6, -1��ԭ���Ǽ������Ǵ�0~10,�ټ�ȥSTRIDE��˵����ǰwin�����һ������һ��win��ʼ�ĵ�һ�еľ���
		stride_0 <= CONV0_KW - 8'd4;																		//	(CONV0_KW, CONV0_KW + 1, CONV0_KW + 2, CONV0_KW + 3) - STRIDE
	end
	else if (proc_col_next_last)										//	������ڴ���ǰ�еĵ����ڶ��У���ô�����μ�������Ҫ�������Ǵ���һ�е��ʼ11�����ݿ�ʼ��ȡ
	begin
		fin_rd_row <= fin_rd_row + 8'd1;
		stride_0 <= CONV0_KW - 8'd4;	
	end
	else if (conv0_calc_ing)																	//	else if (conv0_calc_ing)�������״̬�ϲ�
	begin
		fin_rd_row <= fin_rd_row;																//	��ǰһ��״̬�Ѿ���������кţ�������ﲻ��Ҫ�ٴ�����
		stride_0 <= stride_0 + CONV0_STRIDE;	
	end
end

always @(*)
begin
	if (proc_col_last)
	begin
		addrb_0 = 0; addrb_1 = 0; addrb_2 = 0; addrb_3 = 0; addrb_4 = 0;addrb_5 = 0; addrb_6 = 0; addrb_7 = 0;	
		addrb_8 = 0; addrb_9 = 0; addrb_10 = 0; addrb_11 = 0; addrb_12 = 0;addrb_13 = 0; addrb_14 = 0; addrb_15 = 0;
	end
	else
	begin
		case (stride_0[3:0])																	//	ҪŪ�����4bit���4bit���Եĺ���
			4'd0:	begin	addrb_0 = stride_0[7:4];	addrb_1 = stride_1[7:4];	addrb_2 = stride_2[7:4];	addrb_3 = stride_3[7:4];	end
			4'd1:	begin	addrb_1 = stride_0[7:4];	addrb_2 = stride_1[7:4];	addrb_3 = stride_2[7:4];	addrb_4 = stride_3[7:4];	end
			4'd2:	begin	addrb_2 = stride_0[7:4];	addrb_3 = stride_1[7:4];	addrb_4 = stride_2[7:4];	addrb_5 = stride_3[7:4];	end
			4'd3:	begin	addrb_3 = stride_0[7:4];	addrb_4 = stride_1[7:4];	addrb_5 = stride_2[7:4];	addrb_6 = stride_3[7:4];	end
			4'd4:	begin	addrb_4 = stride_0[7:4];	addrb_5 = stride_1[7:4];	addrb_6 = stride_2[7:4];	addrb_7 = stride_3[7:4];	end
			4'd5:	begin	addrb_5 = stride_0[7:4];	addrb_6 = stride_1[7:4];	addrb_7 = stride_2[7:4];	addrb_8 = stride_3[7:4];	end
			4'd6:	begin	addrb_6 = stride_0[7:4];	addrb_7 = stride_1[7:4];	addrb_8 = stride_2[7:4];	addrb_9 = stride_3[7:4];	end
			4'd7:	begin	addrb_7 = stride_0[7:4];	addrb_8 = stride_1[7:4];	addrb_9 = stride_2[7:4];	addrb_10 = stride_3[7:4];	end
			4'd8:	begin	addrb_8 = stride_0[7:4];	addrb_9 = stride_1[7:4];	addrb_10 = stride_2[7:4];	addrb_11 = stride_3[7:4];	end
			4'd9:	begin	addrb_9 = stride_0[7:4];	addrb_10 = stride_1[7:4];	addrb_11 = stride_2[7:4];	addrb_12 = stride_3[7:4];	end
			4'd10:	begin	addrb_10 = stride_0[7:4];	addrb_11 = stride_1[7:4];	addrb_12 = stride_2[7:4];	addrb_13 = stride_3[7:4];	end
			4'd11:	begin	addrb_11 = stride_0[7:4];	addrb_12 = stride_1[7:4];	addrb_13 = stride_2[7:4];	addrb_14 = stride_3[7:4];	end
			4'd12:	begin	addrb_12 = stride_0[7:4];	addrb_13 = stride_1[7:4];	addrb_14 = stride_2[7:4];	addrb_15 = stride_3[7:4];	end
			4'd13:	begin	addrb_13 = stride_0[7:4];	addrb_14 = stride_1[7:4];	addrb_15 = stride_2[7:4];	addrb_0 = stride_3[7:4];	end
			4'd14:	begin	addrb_14 = stride_0[7:4];	addrb_15 = stride_1[7:4];	addrb_0 = stride_2[7:4];	addrb_1 = stride_3[7:4];	end
			4'd15:	begin	addrb_15 = stride_0[7:4];	addrb_0 = stride_1[7:4];	addrb_1 = stride_2[7:4];	addrb_2 = stride_3[7:4];	end
		endcase
	end
end

//	�����е�ַ���ڻع������Ҫע���д��ַ�᲻����ֳ�ͻ
//	Ҫע����û�п���ĳһ�е����ݻ�û�����������ͱ������ݸ�����,���Կ���1_wr_addr��rd_addr���бȽ�
//������ͬ��fifo��ʵ��˼·ȥ����BRAM�ܷ�д���µ�����
//	fin_chx_row_cnt = y����˼��0~y-1�е���������ͼ�Ѿ����浽BRAM�ˣ��������ڻ����y�е�
wire bram0_addr_eq = fin_ch0_row_cnt[4:0] == fin_rd_row_base[4:0];
wire bram1_addr_eq = fin_ch1_row_cnt[4:0] == fin_rd_row_base[4:0];
wire bram2_addr_eq = fin_ch2_row_cnt[4:0] == fin_rd_row_base[4:0];
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fin_buf_row0_empty <= 1'b1;
		fin_buf_row0_full <= 1'b0;
	end
	else if (bram0_addr_eq == 0)										//	�����ַ���ȣ���ôһ�����ڷǿշ���״̬
	begin
		fin_buf_row0_empty <= 1'b0;
		fin_buf_row0_full <= 1'b0;
	end
	else if (bram0_addr_eq && fin_buf_row0_empty)						//	�����ַ��ȵ���empty˵����ûд���ݽ�ȥ
	begin
		fin_buf_row0_empty <= 1'b1;
		fin_buf_row0_full <= 1'b0;
	end
	else if (bram0_addr_eq)												//	�����ַ��ȵ���empty˵����ûд���ݽ�ȥ
	begin
		fin_buf_row0_empty <= 1'b0;
		fin_buf_row0_full <= 1'b1;
	end
end

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fin_buf_row1_empty <= 1'b1;
		fin_buf_row1_full <= 1'b0;
	end
	else if (bram1_addr_eq == 0)										//	�����ַ���ȣ���ôһ�����ڷǿշ���״̬
	begin
		fin_buf_row1_empty <= 1'b0;
		fin_buf_row1_full <= 1'b0;
	end
	else if (bram1_addr_eq && fin_buf_row1_empty)						//	�����ַ��ȵ���empty˵����ûд���ݽ�ȥ
	begin
		fin_buf_row1_empty <= 1'b1;
		fin_buf_row1_full <= 1'b0;
	end
	else if (bram1_addr_eq)												//	�����ַ��ȵ���empty˵����ûд���ݽ�ȥ
	begin
		fin_buf_row1_empty <= 1'b0;
		fin_buf_row1_full <= 1'b1;
	end
end

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fin_buf_row2_empty <= 1'b1;
		fin_buf_row2_full <= 1'b0;
	end
	else if (bram2_addr_eq == 0)										//	�����ַ���ȣ���ôһ�����ڷǿշ���״̬
	begin
		fin_buf_row2_empty <= 1'b0;
		fin_buf_row2_full <= 1'b0;
	end
	else if (bram2_addr_eq && fin_buf_row2_empty)						//	�����ַ��ȵ���empty˵����ûд���ݽ�ȥ
	begin
		fin_buf_row2_empty <= 1'b1;
		fin_buf_row2_full <= 1'b0;
	end
	else if (bram2_addr_eq)												//	�����ַ��ȵ���empty˵����ûд���ݽ�ȥ
	begin
		fin_buf_row2_empty <= 1'b0;
		fin_buf_row2_full <= 1'b1;
	end
end

//	3��bram_512_512���ڻ�������ͨ�������ݣ�����д���ǿ��Եģ������е��˷Ѵ洢��Դ
wire [511 : 0] ch0_doutb;        
wire [511 : 0] dina;	//	Ŀ���������һ��256bit����512bit�ĵͲ���
assign	dina = fin_last_256 ?	{256'd0,from_ddr_fin} :	{from_ddr_fin,from_ddr_fin_r};
bram_512_512 fin_buf_ch0 (
    .clka 		(clk                        				),
    .wea  		(wr_bram_en_i[0]							),
    .addra		({fin_ch0_row_cnt[4:0],fin_cnt[4:1]} 	 	),
    .dina 		(dina						        		),
			
    .clkb 		(clk	                        			),
	.rstb		(!rst_n										),
    .addrb_0 	({fin_rd_row[4:0],addrb_0 }        			),
    .addrb_1 	({fin_rd_row[4:0],addrb_1 }					),
    .addrb_2 	({fin_rd_row[4:0],addrb_2 }					),
    .addrb_3 	({fin_rd_row[4:0],addrb_3 }					),
    .addrb_4 	({fin_rd_row[4:0],addrb_4 }					),
    .addrb_5 	({fin_rd_row[4:0],addrb_5 }					),
    .addrb_6 	({fin_rd_row[4:0],addrb_6 }					),
    .addrb_7 	({fin_rd_row[4:0],addrb_7 }					),
    .addrb_8 	({fin_rd_row[4:0],addrb_8 }        			),
    .addrb_9 	({fin_rd_row[4:0],addrb_9 }					),
    .addrb_10	({fin_rd_row[4:0],addrb_10}					),
    .addrb_11	({fin_rd_row[4:0],addrb_11}					),
    .addrb_12	({fin_rd_row[4:0],addrb_12}					),
    .addrb_13	({fin_rd_row[4:0],addrb_13}					),
    .addrb_14	({fin_rd_row[4:0],addrb_14}					),
    .addrb_15	({fin_rd_row[4:0],addrb_15}					),
    .doutb		(ch0_doutb	                				)
);

wire [511 : 0] ch1_doutb;      
bram_512_512 fin_buf_ch1 (
    .clka 		(clk                        				),
    .wea  		(wr_bram_en_i[1]							),
    .addra		({fin_ch1_row_cnt[4:0],fin_cnt[4:1]}  		),
    .dina 		(dina						        		),
			
    .clkb 		(clk	                        			),
	.rstb		(!rst_n										),
    .addrb_0 	({fin_rd_row[4:0],addrb_0 }        			),
    .addrb_1 	({fin_rd_row[4:0],addrb_1 }					),
    .addrb_2 	({fin_rd_row[4:0],addrb_2 }					),
    .addrb_3 	({fin_rd_row[4:0],addrb_3 }					),
    .addrb_4 	({fin_rd_row[4:0],addrb_4 }					),
    .addrb_5 	({fin_rd_row[4:0],addrb_5 }					),
    .addrb_6 	({fin_rd_row[4:0],addrb_6 }					),
    .addrb_7 	({fin_rd_row[4:0],addrb_7 }					),
    .addrb_8 	({fin_rd_row[4:0],addrb_8 }        			),
    .addrb_9 	({fin_rd_row[4:0],addrb_9 }					),
    .addrb_10	({fin_rd_row[4:0],addrb_10}					),
    .addrb_11	({fin_rd_row[4:0],addrb_11}					),
    .addrb_12	({fin_rd_row[4:0],addrb_12}					),
    .addrb_13	({fin_rd_row[4:0],addrb_13}					),
    .addrb_14	({fin_rd_row[4:0],addrb_14}					),
    .addrb_15	({fin_rd_row[4:0],addrb_15}					),
    .doutb		(ch1_doutb	                				)
);			

wire [511 : 0] ch2_doutb;        
bram_512_512 fin_buf_ch2 (
    .clka 		(clk                        				),
    .wea  		(wr_bram_en_i[2]							),
    .addra		({fin_ch2_row_cnt[4:0],fin_cnt[4:1]}  		),
    .dina 		(dina						        		),
			
    .clkb 		(clk	                        			),
	.rstb		(!rst_n										),
    .addrb_0 	({fin_rd_row[4:0],addrb_0 }        			),
    .addrb_1 	({fin_rd_row[4:0],addrb_1 }					),
    .addrb_2 	({fin_rd_row[4:0],addrb_2 }					),
    .addrb_3 	({fin_rd_row[4:0],addrb_3 }					),
    .addrb_4 	({fin_rd_row[4:0],addrb_4 }					),
    .addrb_5 	({fin_rd_row[4:0],addrb_5 }					),
    .addrb_6 	({fin_rd_row[4:0],addrb_6 }					),
    .addrb_7 	({fin_rd_row[4:0],addrb_7 }					),
    .addrb_8 	({fin_rd_row[4:0],addrb_8 }        			),
    .addrb_9 	({fin_rd_row[4:0],addrb_9 }					),
    .addrb_10	({fin_rd_row[4:0],addrb_10}					),
    .addrb_11	({fin_rd_row[4:0],addrb_11}					),
    .addrb_12	({fin_rd_row[4:0],addrb_12}					),
    .addrb_13	({fin_rd_row[4:0],addrb_13}					),
    .addrb_14	({fin_rd_row[4:0],addrb_14}					),
    .addrb_15	({fin_rd_row[4:0],addrb_15}					),
    .doutb		(ch2_doutb	                				)
);			

//	��Ҫ��11��Ȩ�����ݵĸ�7�����ݻ�������
reg [223:0]	ch0_high_buf;	reg [223:0]	ch1_high_buf;	reg [223:0]	ch2_high_buf;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		ch0_high_buf <= 224'd0;
		ch1_high_buf <= 224'd0;
		ch2_high_buf <= 224'd0;
	end
	else 
	begin
		ch0_high_buf <= {fin_ch0_10,fin_ch0_9,fin_ch0_8,fin_ch0_7,fin_ch0_6,fin_ch0_5,fin_ch0_4};
		ch1_high_buf <= {fin_ch1_10,fin_ch1_9,fin_ch1_8,fin_ch1_7,fin_ch1_6,fin_ch1_5,fin_ch1_4};
		ch2_high_buf <= {fin_ch2_10,fin_ch2_9,fin_ch2_8,fin_ch2_7,fin_ch2_6,fin_ch2_5,fin_ch2_4};
	end
end

assign	fin_ch0_0 = (fout_proc_col == 6'd0)	?	ch0_doutb[31 : 0]		:	ch0_high_buf[31 : 0]	;
assign	fin_ch0_1 = (fout_proc_col == 6'd0)	?	ch0_doutb[63 : 32]		:	ch0_high_buf[63 : 32]	;
assign	fin_ch0_2 = (fout_proc_col == 6'd0)	?	ch0_doutb[95 : 64]		:	ch0_high_buf[95 : 64]	;
assign	fin_ch0_3 = (fout_proc_col == 6'd0)	?	ch0_doutb[127 : 96]		:	ch0_high_buf[127 : 96]	;
assign	fin_ch0_4 = (fout_proc_col == 6'd0)	?	ch0_doutb[159 : 128]	:	ch0_high_buf[159 : 128]	;
assign	fin_ch0_5 = (fout_proc_col == 6'd0)	?	ch0_doutb[191 : 160]	:	ch0_high_buf[191 : 160]	;
assign	fin_ch0_6 = (fout_proc_col == 6'd0)	?	ch0_doutb[223 : 192]	:	ch0_high_buf[223 : 192]	;
assign	fin_ch1_0 = (fout_proc_col == 6'd0)	?	ch1_doutb[31 : 0]		:	ch1_high_buf[31 : 0]	;
assign	fin_ch1_1 = (fout_proc_col == 6'd0)	?	ch1_doutb[63 : 32]		:	ch1_high_buf[63 : 32]	;
assign	fin_ch1_2 = (fout_proc_col == 6'd0)	?	ch1_doutb[95 : 64]		:	ch1_high_buf[95 : 64]	;
assign	fin_ch1_3 = (fout_proc_col == 6'd0)	?	ch1_doutb[127 : 96]		:	ch1_high_buf[127 : 96]	;
assign	fin_ch1_4 = (fout_proc_col == 6'd0)	?	ch1_doutb[159 : 128]	:	ch1_high_buf[159 : 128]	;
assign	fin_ch1_5 = (fout_proc_col == 6'd0)	?	ch1_doutb[191 : 160]	:	ch1_high_buf[191 : 160]	;
assign	fin_ch1_6 = (fout_proc_col == 6'd0)	?	ch1_doutb[223 : 192]	:	ch1_high_buf[223 : 192]	;
assign	fin_ch2_0 = (fout_proc_col == 6'd0)	?	ch2_doutb[31 : 0]		:	ch2_high_buf[31 : 0]	;
assign	fin_ch2_1 = (fout_proc_col == 6'd0)	?	ch2_doutb[63 : 32]		:	ch2_high_buf[63 : 32]	;
assign	fin_ch2_2 = (fout_proc_col == 6'd0)	?	ch2_doutb[95 : 64]		:	ch2_high_buf[95 : 64]	;
assign	fin_ch2_3 = (fout_proc_col == 6'd0)	?	ch2_doutb[127 : 96]		:	ch2_high_buf[127 : 96]	;
assign	fin_ch2_4 = (fout_proc_col == 6'd0)	?	ch2_doutb[159 : 128]	:	ch2_high_buf[159 : 128]	;
assign	fin_ch2_5 = (fout_proc_col == 6'd0)	?	ch2_doutb[191 : 160]	:	ch2_high_buf[191 : 160]	;
assign	fin_ch2_6 = (fout_proc_col == 6'd0)	?	ch2_doutb[223 : 192]	:	ch2_high_buf[223 : 192]	;

//	��stride_0�����ģ���Ϊstride_0��Ҫһ��ʱ�ӵ�BRAM��ַ�źţ���һ��ʱ�ӵ�����
reg [7:0]	stride_0_r0;	
reg 		buf_done_flag;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		stride_0_r0 <= 8'd0;
		buf_done_flag <= 1'b0;
		vecMac11_fin_ok <= 1'b0;
	end
	else 
	begin
		stride_0_r0 <= stride_0;
		buf_done_flag <= conv0_calc_ing;
		vecMac11_fin_ok <= buf_done_flag;
	end
end

//	����stride_0_r1����������ȡ������
always @(*)
begin
	if (fout_proc_col == 6'd0)		//	������ʼ��һ�����ݾ���������7,8,9,10��λ��
	begin
		fin_ch0_7 = ch0_doutb[255:224];	fin_ch0_8 = ch0_doutb[287:256];	fin_ch0_9 = ch0_doutb[319:288];	fin_ch0_10 = ch0_doutb[351:320];	
		fin_ch1_7 = ch1_doutb[255:224];	fin_ch1_8 = ch1_doutb[287:256];	fin_ch1_9 = ch1_doutb[319:288];	fin_ch1_10 = ch1_doutb[351:320];	
		fin_ch2_7 = ch2_doutb[255:224];	fin_ch2_8 = ch2_doutb[287:256];	fin_ch2_9 = ch2_doutb[319:288];	fin_ch2_10 = ch2_doutb[351:320];	
	end
	else 
	begin
		case (stride_0_r0[3:0])	
			4'd0:	
			begin	
				fin_ch0_7 = ch0_doutb[31:0];	fin_ch0_8 = ch0_doutb[63:32];	fin_ch0_9 = ch0_doutb[95:64];	fin_ch0_10 = ch0_doutb[127:96];	
				fin_ch1_7 = ch1_doutb[31:0];	fin_ch1_8 = ch1_doutb[63:32];	fin_ch1_9 = ch1_doutb[95:64];	fin_ch1_10 = ch1_doutb[127:96];	
				fin_ch2_7 = ch2_doutb[31:0];	fin_ch2_8 = ch2_doutb[63:32];	fin_ch2_9 = ch2_doutb[95:64];	fin_ch2_10 = ch2_doutb[127:96];	
			end
			4'd1:	
			begin	
				fin_ch0_7 = ch0_doutb[63:32];	fin_ch0_8 = ch0_doutb[95:64];	fin_ch0_9 = ch0_doutb[127:96];	fin_ch0_10 = ch0_doutb[159:128];	
				fin_ch1_7 = ch1_doutb[63:32];	fin_ch1_8 = ch1_doutb[95:64];	fin_ch1_9 = ch1_doutb[127:96];	fin_ch1_10 = ch1_doutb[159:128];	
				fin_ch2_7 = ch2_doutb[63:32];	fin_ch2_8 = ch2_doutb[95:64];	fin_ch2_9 = ch2_doutb[127:96];	fin_ch2_10 = ch2_doutb[159:128];	
			end
			4'd2:	
			begin	
				fin_ch0_7 = ch0_doutb[95:64];	fin_ch0_8 = ch0_doutb[127:96];	fin_ch0_9 = ch0_doutb[159:128];	fin_ch0_10 = ch0_doutb[191:160];	
				fin_ch1_7 = ch1_doutb[95:64];	fin_ch1_8 = ch1_doutb[127:96];	fin_ch1_9 = ch1_doutb[159:128];	fin_ch1_10 = ch1_doutb[191:160];	
				fin_ch2_7 = ch2_doutb[95:64];	fin_ch2_8 = ch2_doutb[127:96];	fin_ch2_9 = ch2_doutb[159:128];	fin_ch2_10 = ch2_doutb[191:160];	
			end
			4'd3:	
			begin	
				fin_ch0_7 = ch0_doutb[127:96];	fin_ch0_8 = ch0_doutb[159:128];	fin_ch0_9 = ch0_doutb[191:160];	fin_ch0_10 = ch0_doutb[223:192];	
				fin_ch1_7 = ch1_doutb[127:96];	fin_ch1_8 = ch1_doutb[159:128];	fin_ch1_9 = ch1_doutb[191:160];	fin_ch1_10 = ch1_doutb[223:192];	
				fin_ch2_7 = ch2_doutb[127:96];	fin_ch2_8 = ch2_doutb[159:128];	fin_ch2_9 = ch2_doutb[191:160];	fin_ch2_10 = ch2_doutb[223:192];	
			end
			4'd4:	
			begin	
				fin_ch0_7 = ch0_doutb[159:128];	fin_ch0_8 = ch0_doutb[191:160];	fin_ch0_9 = ch0_doutb[223:192];	fin_ch0_10 = ch0_doutb[255:224];	
				fin_ch1_7 = ch1_doutb[159:128];	fin_ch1_8 = ch1_doutb[191:160];	fin_ch1_9 = ch1_doutb[223:192];	fin_ch1_10 = ch1_doutb[255:224];	
				fin_ch2_7 = ch2_doutb[159:128];	fin_ch2_8 = ch2_doutb[191:160];	fin_ch2_9 = ch2_doutb[223:192];	fin_ch2_10 = ch2_doutb[255:224];	
			end
			4'd5:	
			begin	
				fin_ch0_7 = ch0_doutb[191:160];	fin_ch0_8 = ch0_doutb[223:192];	fin_ch0_9 = ch0_doutb[255:224];	fin_ch0_10 = ch0_doutb[287:256];	
				fin_ch1_7 = ch1_doutb[191:160];	fin_ch1_8 = ch1_doutb[223:192];	fin_ch1_9 = ch1_doutb[255:224];	fin_ch1_10 = ch1_doutb[287:256];	
				fin_ch2_7 = ch2_doutb[191:160];	fin_ch2_8 = ch2_doutb[223:192];	fin_ch2_9 = ch2_doutb[255:224];	fin_ch2_10 = ch2_doutb[287:256];	
			end
			4'd6:	
			begin	
				fin_ch0_7 = ch0_doutb[223:192];	fin_ch0_8 = ch0_doutb[255:224];	fin_ch0_9 = ch0_doutb[287:256];	fin_ch0_10 = ch0_doutb[319:288];	
				fin_ch1_7 = ch1_doutb[223:192];	fin_ch1_8 = ch1_doutb[255:224];	fin_ch1_9 = ch1_doutb[287:256];	fin_ch1_10 = ch1_doutb[319:288];	
				fin_ch2_7 = ch2_doutb[223:192];	fin_ch2_8 = ch2_doutb[255:224];	fin_ch2_9 = ch2_doutb[287:256];	fin_ch2_10 = ch2_doutb[319:288];	
			end
			4'd7:	
			begin	
				fin_ch0_7 = ch0_doutb[255:224];	fin_ch0_8 = ch0_doutb[287:256];	fin_ch0_9 = ch0_doutb[319:288];	fin_ch0_10 = ch0_doutb[351:320];	
				fin_ch1_7 = ch1_doutb[255:224];	fin_ch1_8 = ch1_doutb[287:256];	fin_ch1_9 = ch1_doutb[319:288];	fin_ch1_10 = ch1_doutb[351:320];	
				fin_ch2_7 = ch2_doutb[255:224];	fin_ch2_8 = ch2_doutb[287:256];	fin_ch2_9 = ch2_doutb[319:288];	fin_ch2_10 = ch2_doutb[351:320];	
			end
			4'd8:	
			begin	
				fin_ch0_7 = ch0_doutb[287:256];	fin_ch0_8 = ch0_doutb[319:288];	fin_ch0_9 = ch0_doutb[351:320];	fin_ch0_10 = ch0_doutb[383:352];	
				fin_ch1_7 = ch1_doutb[287:256];	fin_ch1_8 = ch1_doutb[319:288];	fin_ch1_9 = ch1_doutb[351:320];	fin_ch1_10 = ch1_doutb[383:352];	
				fin_ch2_7 = ch2_doutb[287:256];	fin_ch2_8 = ch2_doutb[319:288];	fin_ch2_9 = ch2_doutb[351:320];	fin_ch2_10 = ch2_doutb[383:352];	
			end
			4'd9:	
			begin	
				fin_ch0_7 = ch0_doutb[319:288];	fin_ch0_8 = ch0_doutb[351:320];	fin_ch0_9 = ch0_doutb[383:352];	fin_ch0_10 = ch0_doutb[415:384];	
				fin_ch1_7 = ch1_doutb[319:288];	fin_ch1_8 = ch1_doutb[351:320];	fin_ch1_9 = ch1_doutb[383:352];	fin_ch1_10 = ch1_doutb[415:384];	
				fin_ch2_7 = ch2_doutb[319:288];	fin_ch2_8 = ch2_doutb[351:320];	fin_ch2_9 = ch2_doutb[383:352];	fin_ch2_10 = ch2_doutb[415:384];	
			end
			4'd10:	
			begin	
				fin_ch0_7 = ch0_doutb[351:320];	fin_ch0_8 = ch0_doutb[383:352];	fin_ch0_9 = ch0_doutb[415:384];	fin_ch0_10 = ch0_doutb[447:416];	
				fin_ch1_7 = ch1_doutb[351:320];	fin_ch1_8 = ch1_doutb[383:352];	fin_ch1_9 = ch1_doutb[415:384];	fin_ch1_10 = ch1_doutb[447:416];	
				fin_ch2_7 = ch2_doutb[351:320];	fin_ch2_8 = ch2_doutb[383:352];	fin_ch2_9 = ch2_doutb[415:384];	fin_ch2_10 = ch2_doutb[447:416];	
			end
			4'd11:	
			begin	
				fin_ch0_7 = ch0_doutb[383:352];	fin_ch0_8 = ch0_doutb[415:384];	fin_ch0_9 = ch0_doutb[447:416];	fin_ch0_10 = ch0_doutb[479:448];	
				fin_ch1_7 = ch1_doutb[383:352];	fin_ch1_8 = ch1_doutb[415:384];	fin_ch1_9 = ch1_doutb[447:416];	fin_ch1_10 = ch1_doutb[479:448];	
				fin_ch2_7 = ch2_doutb[383:352];	fin_ch2_8 = ch2_doutb[415:384];	fin_ch2_9 = ch2_doutb[447:416];	fin_ch2_10 = ch2_doutb[479:448];	
			end
			4'd12:	
			begin	
				fin_ch0_7 = ch0_doutb[415:384];	fin_ch0_8 = ch0_doutb[447:416];	fin_ch0_9 = ch0_doutb[479:448];	fin_ch0_10 = ch0_doutb[511:480];	
				fin_ch1_7 = ch1_doutb[415:384];	fin_ch1_8 = ch1_doutb[447:416];	fin_ch1_9 = ch1_doutb[479:448];	fin_ch1_10 = ch1_doutb[511:480];	
				fin_ch2_7 = ch2_doutb[415:384];	fin_ch2_8 = ch2_doutb[447:416];	fin_ch2_9 = ch2_doutb[479:448];	fin_ch2_10 = ch2_doutb[511:480];	
			end
			4'd13:	
			begin	
				fin_ch0_7 = ch0_doutb[447:416];	fin_ch0_8 = ch0_doutb[479:448];	fin_ch0_9 = ch0_doutb[511:480];	fin_ch0_10 = ch0_doutb[31:0];	
				fin_ch1_7 = ch1_doutb[447:416];	fin_ch1_8 = ch1_doutb[479:448];	fin_ch1_9 = ch1_doutb[511:480];	fin_ch1_10 = ch1_doutb[31:0];	
				fin_ch2_7 = ch2_doutb[447:416];	fin_ch2_8 = ch2_doutb[479:448];	fin_ch2_9 = ch2_doutb[511:480];	fin_ch2_10 = ch2_doutb[31:0];	
			end
			4'd14:	
			begin	
				fin_ch0_7 = ch0_doutb[479:448];	fin_ch0_8 = ch0_doutb[511:480];	fin_ch0_9 = ch0_doutb[31:0];	fin_ch0_10 = ch0_doutb[63:32];	
				fin_ch1_7 = ch1_doutb[479:448];	fin_ch1_8 = ch1_doutb[511:480];	fin_ch1_9 = ch1_doutb[31:0];	fin_ch1_10 = ch1_doutb[63:32];	
				fin_ch2_7 = ch2_doutb[479:448];	fin_ch2_8 = ch2_doutb[511:480];	fin_ch2_9 = ch2_doutb[31:0];	fin_ch2_10 = ch2_doutb[63:32];	
			end
			4'd15:	
			begin	
				fin_ch0_7 = ch0_doutb[511:480];	fin_ch0_8 = ch0_doutb[31:0];	fin_ch0_9 = ch0_doutb[63:32];	fin_ch0_10 = ch0_doutb[95:64];	
				fin_ch1_7 = ch1_doutb[511:480];	fin_ch1_8 = ch1_doutb[31:0];	fin_ch1_9 = ch1_doutb[63:32];	fin_ch1_10 = ch1_doutb[95:64];	
				fin_ch2_7 = ch2_doutb[511:480];	fin_ch2_8 = ch2_doutb[31:0];	fin_ch2_9 = ch2_doutb[63:32];	fin_ch2_10 = ch2_doutb[95:64];	
			end
		endcase
	end
end

endmodule
