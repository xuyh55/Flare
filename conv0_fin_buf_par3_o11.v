/*
	时间：			2023.10.24
	功能：			实现输入特征图缓存
	
	资源消耗：		Vivado 2023.1:	708LUT, 48LUTRAM, 803FF, 24BRAM
	
	数据类型：		单精度浮点
	版本：			1.0
	
	时序：			① 200MHz时钟
					② new_fin_channel -> new_fin_row -> 传数据
					③ in_channel = x期间from_ddr_fin必须是属于该通道的数据，不能出现in_channel在时钟的0~28时候是通道1，但是在时钟的1~29是通道1的数据
	
	功能限制部分：	①	存在clk和clj_inv两个时钟，使用clk生成BRAM的B端口地址，用clk_inv作为B端口的读时钟，这样在clk的上升沿看来当前B端口地址对应的数据可以在下一个时钟拿到
					② 	如果每个通道只缓存3行就开始计算会因为DDR带宽不够导致后续一些行的数据读取错误
	可改进的方向：	①	
					② 	最开始缓存的那几行不要覆盖了！！！或者在计算的能够把最开始的13行都缓存了
	修改：			① 	wire bram2_addr_eq = fin_ch2_row_cnt[4:0] == fin_rd_row_base[4:0]; 判断条件应该是本窗口的第一行不能被覆盖
	
	修改意图：		① 
	
	设计想法：		①	借助类似同步fifo的思路，设置读写地址，已经是否是缓存了某一行的最后一个数据、是否在处理输入特征图某一行的最后数据	
*/
module conv0_fin_buf_par3_o11 (
	input								clk						,		//	200M
	input								rst_n					,
	
	//	控制模块交互信号
	input		[1:0]					in_channel				,		//	指示当前ddr输入的数据是输入特征图哪个通道的,有效值范围是1~3
	input								new_fin_channel			,		//	表明接下来要传输的数据是输入特征图的新通道
	input								new_fin_row				,		//	表明接下来的数据是新的一行特征图
	input								conv0_calc_ing			,		//	表明此时正在计算过程中			
	input								fin_calc_done			,		//	当前的fin层数据全部处理完了，要重新开始新的fin层处理，一共要处理64 / 2 = 32次
	
	output	reg	[7:0]					fin_ch0_row_cnt			,		//	当前缓存了通道0的多少行数据，取低5bit作为写bram的high_addr，有效值是0~226
	output	reg	[7:0]					fin_ch1_row_cnt			,		//	fin_chx_row_cnt = y的意思是0~y-1行的输入特征图已经缓存到BRAM了，现在正在缓存第y行的
	output	reg	[7:0]					fin_ch2_row_cnt			,		
	
	input	 	 [5:0]					fout_proc_chnl			,		//	当前正在处理fout_chnl和fout_chnl+1输出特征通道的数据，因为输出通道并行度为2
	input	 	 [5:0]					fout_proc_row			,		//	当前正在处理输出特征图的哪一行，有效值是0~54
	input	 	 [5:0]					fout_proc_col			,		//	当前正在处理输出特征图的哪一列，有效值是0~54
	
	output								proc_col_last			,		//	正在处理当前行的最后一列数据	
	output								proc_col_next_last		,		//	正在处理当前行的倒数第二列数据，增加这个状态的目的是考虑到状态 -> 地址 -> 数据一共有两个时钟的延迟
	output								proc_win_last_row		,		//	正在处理当前窗口的最后一行
	
	//	来自DDR的fin数据
	output	reg							fin_buf_row0_empty		,		
	output	reg							fin_buf_row0_full		,		//	可以从DDR中接收数据，主要是要考虑新来的数据会不会把还没读出的特征图数据给覆盖了
	output	reg							fin_buf_row1_empty		,	
	output	reg							fin_buf_row1_full		,		//	只有当full为低电平时才能往BRAM中缓存数据
	output	reg							fin_buf_row2_empty		,	
	output	reg							fin_buf_row2_full		,
	input		[255:0]					from_ddr_fin			,		//	虽然DDR最大是100M & 256bit，但是在FPGA中用大一倍的带宽是接收数据
	input								fin_vld					,
	
	//	输出给vecMac61用
	output	reg							vecMac11_fin_ok	,		//	计算所需要的特征图数据都准备好了
	output		[31:0]					fin_ch0_0		,		//	根据优化策略，输入通道并行度为3
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

//	这些参数后面可以放到VH文件里
localparam	CONV0_STRIDE	= 	4	;
localparam	CONV0_KH		=	11	;
localparam	CONV0_KW		=	8'd11	;
localparam	CONV0_IH		=	227	;
localparam	CONV0_IW		=	227	;
localparam	CONV0_IC		=	3	;
localparam	CONV0_OH		=	55	;
localparam	CONV0_OW		=	55	;
localparam	CONV0_OC		=	64	;
localparam 	CONV0_FIN_PAR	=	3	;			//	输入通道并行度为3
//localparam 	FIN_NUM			= 	232	;			//	需要实际是227，但是为了简化代码，需要令其为8的整数倍
localparam 	FIN_NUM_256		=	29	;			//	29 * 8 = 232

parameter	IDLE			=	3'd0;
parameter	LINE_INIT		=	3'd1;	//	将每个通道最初的一行缓存下来作为初始化部分，此时计算还没开始
parameter	WAIT_TRIGGER	=	3'd2;	//	等待写控制请求
parameter	WRITE_BRAM		=	3'd3;	//	特征图数据写入BRAM，此时计算和缓存是同时进行的
parameter	CONV0_END		=	3'd4;	//	conv0的数据全部处理结束


//	检测new_fin_row和new_fin_channel的上升沿
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

//	将输入的256bit数据打一拍，目的是生成512bit的数据
reg	[255:0] from_ddr_fin_r	;
reg 		wr_bram_flag	;
wire		fin_last_256;					//	当前行最后一个2586bit的数据
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		from_ddr_fin_r <= 256'd0;
		wr_bram_flag <= 1'b0;
	end
	else if (fin_last_256)					//	如果是本行最后一个数据了，说明下一个256bit肯定不是是下一行数据的第512bit高256位
	begin
		from_ddr_fin_r <= 256'd0;
		wr_bram_flag <= 1'b0;
	end
	else if (new_fin_channel_pos)			//	如果是新特征图通道要来了那么肯定是要清零的
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

//	用于指示当前行接收了多少个256bit的数据
reg [4:0]	fin_cnt;						//	有效值是0~28
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fin_cnt <= 5'd0;
	end
	else if (new_fin_row_pos || fin_last_256)//	如果是特征图通新的一行来了
	begin
		fin_cnt <= 5'd0;
	end
	else if (fin_vld)						//	fin_cnt[4:1]可以给bram的写地址用
	begin
		fin_cnt <= fin_cnt + 5'd1;	
	end
end
assign	fin_last_256 = fin_cnt == FIN_NUM_256 - 1;		

//	当前在缓存哪个通道的数据
wire [2:0]	fin_ch_sel;
assign		fin_ch_sel[0] = in_channel == 2'd1;		//	in_channel的有效值范围是1,2,3
assign		fin_ch_sel[1] = in_channel == 2'd2;
assign		fin_ch_sel[2] = in_channel == 2'd3;

//	特征图通道0已经缓存了多少行
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

//	特征图通道1已经缓存了多少行
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

//	特征图通道2已经缓存了多少行
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

//	把ddr中读到的特征图数据写入到BRAM中缓存
wire 			wr_bram_en		;
wire	[2:0]	wr_bram_en_i	;													//	具体往哪个BRAM中写数据
assign	wr_bram_en = (fin_vld && wr_bram_flag) || fin_last_256;						//	这种写法是希望512bit以及最后一个256bit都能缓存下来
assign	wr_bram_en_i[0] = fin_ch_sel[0] && wr_bram_en;								//	只有当前是往bram_i写数据并且由数据有效信号时才能往BRAM写数据
assign	wr_bram_en_i[1] = fin_ch_sel[1] && wr_bram_en;
assign	wr_bram_en_i[2] = fin_ch_sel[2] && wr_bram_en;

//	用于指示当前是处理一个卷积窗中哪一行的数据
//	对于那些特征图单通道的尺寸和卷积核尺寸一样大的情况肯定就不能用这里的处理逻辑了
reg [3:0]	kernel_row_cnt;															//	取值范围是0~10		
assign	proc_col_last	=	fout_proc_col == CONV0_OW - 1;							//	正在处理当前行的最后一列数据	
assign	proc_col_next_last	=	fout_proc_col == CONV0_OW - 2;						//	正在处理当前行的倒数第二列数据，增加这个状态的目的是考虑到状态 -> 地址 -> 数据一共有两个时钟的延迟
assign	proc_win_last_row	=	kernel_row_cnt == CONV0_KH - 1;						//	表明正在处理当前窗口的最后一行数据					
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		kernel_row_cnt <= 4'd0;
	end
	else if (proc_win_last_row && proc_col_last)								//	最后一行的最后一列结束了才能说此行结束了
	begin
		kernel_row_cnt <= 4'd0;
	end
	else if (proc_col_last)
	begin
		kernel_row_cnt <= kernel_row_cnt + 4'd1;
	end
end

//	生成读BRAM的地址信号，由需要读的行号以及mod(col, 16)组成
//	col = 0时stride_0应该是15，col = 1时stride_0应该是19，以此类推
reg [7:0]	fin_rd_row;																//	指示需要从哪行读出数据，有效值范围是0~227
reg [7:0]	fin_rd_row_base;														//	指示需要从哪行读出数据，有效值范围是0~227
reg [7:0]	stride_0;
wire [7:0]  stride_1,stride_2,stride_3;									//	用于指示下次计算所需要的4个stride数据坐标，注意这里的坐标是0~227这种绝对值坐标
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
	else if (proc_win_last_row && proc_col_next_last)					//	正在处理当前窗口最后一行的倒数第二个数据
	begin
		fin_rd_row <= fin_rd_row - 8'd6;														//	KH -1 - STRIDE = 11 - 1 - 4 = 6, -1的原因是计数器是从0~10,再减去STRIDE是说明当前win的最后一行与下一个win开始的第一行的距离
		fin_rd_row_base <= fin_rd_row - 8'd6;														//	KH -1 - STRIDE = 11 - 1 - 4 = 6, -1的原因是计数器是从0~10,再减去STRIDE是说明当前win的最后一行与下一个win开始的第一行的距离
		stride_0 <= CONV0_KW - 8'd4;																		//	(CONV0_KW, CONV0_KW + 1, CONV0_KW + 2, CONV0_KW + 3) - STRIDE
	end
	else if (proc_col_next_last)										//	如果是在处理当前行的倒数第二列，那么下两次计算所需要的数据是从下一行的最开始11个数据开始读取
	begin
		fin_rd_row <= fin_rd_row + 8'd1;
		stride_0 <= CONV0_KW - 8'd4;	
	end
	else if (conv0_calc_ing)																	//	else if (conv0_calc_ing)可以与此状态合并
	begin
		fin_rd_row <= fin_rd_row;																//	在前一个状态已经处理好了行号，因此这里不需要再处理了
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
		case (stride_0[3:0])																	//	要弄清楚高4bit与低4bit各自的含义
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

//	由于行地址存在回滚，因此要注意读写地址会不会出现冲突
//	要注意有没有可能某一行的数据还没读出参与计算就被新数据覆盖了,可以考虑1_wr_addr与rd_addr进行比较
//这里借鉴同步fifo的实现思路去控制BRAM能否写入新的数据
//	fin_chx_row_cnt = y的意思是0~y-1行的输入特征图已经缓存到BRAM了，现在正在缓存第y行的
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
	else if (bram0_addr_eq == 0)										//	如果地址不等，那么一定处于非空非满状态
	begin
		fin_buf_row0_empty <= 1'b0;
		fin_buf_row0_full <= 1'b0;
	end
	else if (bram0_addr_eq && fin_buf_row0_empty)						//	如果地址相等但是empty说明还没写数据进去
	begin
		fin_buf_row0_empty <= 1'b1;
		fin_buf_row0_full <= 1'b0;
	end
	else if (bram0_addr_eq)												//	如果地址相等但是empty说明还没写数据进去
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
	else if (bram1_addr_eq == 0)										//	如果地址不等，那么一定处于非空非满状态
	begin
		fin_buf_row1_empty <= 1'b0;
		fin_buf_row1_full <= 1'b0;
	end
	else if (bram1_addr_eq && fin_buf_row1_empty)						//	如果地址相等但是empty说明还没写数据进去
	begin
		fin_buf_row1_empty <= 1'b1;
		fin_buf_row1_full <= 1'b0;
	end
	else if (bram1_addr_eq)												//	如果地址相等但是empty说明还没写数据进去
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
	else if (bram2_addr_eq == 0)										//	如果地址不等，那么一定处于非空非满状态
	begin
		fin_buf_row2_empty <= 1'b0;
		fin_buf_row2_full <= 1'b0;
	end
	else if (bram2_addr_eq && fin_buf_row2_empty)						//	如果地址相等但是empty说明还没写数据进去
	begin
		fin_buf_row2_empty <= 1'b1;
		fin_buf_row2_full <= 1'b0;
	end
	else if (bram2_addr_eq)												//	如果地址相等但是empty说明还没写数据进去
	begin
		fin_buf_row2_empty <= 1'b0;
		fin_buf_row2_full <= 1'b1;
	end
end

//	3组bram_512_512用于缓存三个通道的数据，这种写法是可以的，但是有点浪费存储资源
wire [511 : 0] ch0_doutb;        
wire [511 : 0] dina;	//	目的是让最后一个256bit放在512bit的低部分
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

//	需要把11个权重数据的高7个数据缓存下来
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

//	把stride_0打两拍，因为stride_0需要一个时钟到BRAM地址信号，再一个时钟到数据
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

//	根据stride_0_r1决定从哪里取出数据
always @(*)
begin
	if (fout_proc_col == 6'd0)		//	如果是最开始的一个数据就是正常的7,8,9,10的位置
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
