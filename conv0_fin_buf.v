/*
	时间：			2023.10.07
	功能：			实现ceil(vecLen / KH)行的输入特征图缓存
	
	数据类型：		单精度浮点
	版本：			1.0
	
	时序：			① 200MHz时钟
	
	功能限制部分：	①	由于本代码中涉及到两种数据位宽，因此要分清楚对数据的计数是针对哪个数据位宽而言的
					②	为了简化代码的编写，我们假设特征图的宽度是8(256bit)的整数倍，这样做的好处是可以避免窄带和非对齐传输，在实际中也是容易做到的，比如图像边上补0
					③ 	先有new_fin_channel || new_fin_line再有fin_vld，否则会导致计数器出错，new_fin_channel不能晚于new_fin_line出现
					
	可改进的方向：	① 	line_cnt的有效值是从1开始，这个地方需要注意一下
					②	{bram_row_wr_sel,line_in_cnt_256}这种写法会浪费一点资源，因为227(232)的话最多需要232/ 8 =29的存储深度，但是line_in_cnt_256的5bit的，最多可以是存储32 * 8 = 256个数据，这样就导致存储资源有一点浪费
					③ 	cur_channel_done这个信号后面应该可以优化掉，因为全流水的话其实不需要设定这个信号，不过目前留着方便代码编写
	修改：			① 
	
	修改意图：		① 
*/
module conv0_fin_buf (
	input								clk						,		//	200M
	input								rst_n					,
	
	//	控制模块交互信号
	input								vecMac_proc				,		//	如果为1表示当前vecMac正在运行中
	input								cur_fout_row_time		,		//	对于比较大的卷积核，比如11*11，如果vecLen=61那么意味着需要两次计算才行，所以通过这个信号只是当前在哪次
	input		[7:0]					cur_fout_row			,		//	当前正在处理哪一行的数据
	input		[7:0]					cur_fout_col			,		//	当前正在处理哪一列的数据，0~54的有效值
	input								cur_channel_done		,		//	当前输入通道处理完毕
	input								new_fin_channel			,		//	表明接下来要传输的数据是输入特征图的新通道
	input								new_fin_line			,		//	表明接下来的数据是新的一行特征图
	input								wr_fin_while_calc		,		//	表明外部的计算模块正在计算，但是此时可以将DDR的特征图缓存到BRAM中
	output	reg	[7:0]					line_in_cnt_32			,		//	表明当前行读了多少个数据
	output	reg	[7:0]					line_cnt				,		//	表明当前行是特征图某个通道的第多少行，有效行是从1开始
	
	//	来自DDR的fin数据
	output	reg							recv_ddr_fin_rdy		,		//	可以从DDR中接收数据
	input		[255:0]					from_ddr_fin			,		//	虽然DDR最大是100M & 256bit，但是在FPGA中用大一倍的带宽是接收数据
	input								fin_vld					,
	
	//	输出给vecMac61用
	output	reg							vecMac61_fin_buf_done	,		//	vecMac61所需的61个数据缓存好了,这个信号与权重模块的信号一起作为允许计算的使能信号
	output		[31:0]					to_vecMac61_fin_0		,
	output		[31:0]					to_vecMac61_fin_1		,
	output		[31:0]					to_vecMac61_fin_2		,
	output		[31:0]					to_vecMac61_fin_3		,
	output		[31:0]					to_vecMac61_fin_4		,
	output		[31:0]					to_vecMac61_fin_5		,
	output		[31:0]					to_vecMac61_fin_6		,
	output		[31:0]					to_vecMac61_fin_7		,
	output		[31:0]					to_vecMac61_fin_8		,
	output		[31:0]					to_vecMac61_fin_9		,
	output		[31:0]					to_vecMac61_fin_10		,
	output		[31:0]					to_vecMac61_fin_11		,
	output		[31:0]					to_vecMac61_fin_12		,
	output		[31:0]					to_vecMac61_fin_13		,
	output		[31:0]					to_vecMac61_fin_14		,
	output		[31:0]					to_vecMac61_fin_15		,
	output		[31:0]					to_vecMac61_fin_16		,
	output		[31:0]					to_vecMac61_fin_17		,
	output		[31:0]					to_vecMac61_fin_18		,
	output		[31:0]					to_vecMac61_fin_19		,
	output		[31:0]					to_vecMac61_fin_20		,
	output		[31:0]					to_vecMac61_fin_21		,
	output		[31:0]					to_vecMac61_fin_22		,
	output		[31:0]					to_vecMac61_fin_23		,
	output		[31:0]					to_vecMac61_fin_24		,
	output		[31:0]					to_vecMac61_fin_25		,
	output		[31:0]					to_vecMac61_fin_26		,
	output		[31:0]					to_vecMac61_fin_27		,
	output		[31:0]					to_vecMac61_fin_28		,
	output		[31:0]					to_vecMac61_fin_29		,
	output		[31:0]					to_vecMac61_fin_30		,
	output		[31:0]					to_vecMac61_fin_31		,
	output		[31:0]					to_vecMac61_fin_32		,
	output		[31:0]					to_vecMac61_fin_33		,
	output		[31:0]					to_vecMac61_fin_34		,
	output		[31:0]					to_vecMac61_fin_35		,
	output		[31:0]					to_vecMac61_fin_36		,
	output		[31:0]					to_vecMac61_fin_37		,
	output		[31:0]					to_vecMac61_fin_38		,
	output		[31:0]					to_vecMac61_fin_39		,
	output		[31:0]					to_vecMac61_fin_40		,
	output		[31:0]					to_vecMac61_fin_41		,
	output		[31:0]					to_vecMac61_fin_42		,
	output		[31:0]					to_vecMac61_fin_43		,
	output		[31:0]					to_vecMac61_fin_44		,
	output		[31:0]					to_vecMac61_fin_45		,
	output		[31:0]					to_vecMac61_fin_46		,
	output		[31:0]					to_vecMac61_fin_47		,
	output		[31:0]					to_vecMac61_fin_48		,
	output		[31:0]					to_vecMac61_fin_49		,
	output		[31:0]					to_vecMac61_fin_50		,
	output		[31:0]					to_vecMac61_fin_51		,
	output		[31:0]					to_vecMac61_fin_52		,
	output		[31:0]					to_vecMac61_fin_53		,
	output		[31:0]					to_vecMac61_fin_54		,
	output		[31:0]					to_vecMac61_fin_55		,
	output		[31:0]					to_vecMac61_fin_56		,
	output		[31:0]					to_vecMac61_fin_57		,
	output		[31:0]					to_vecMac61_fin_58		,
	output		[31:0]					to_vecMac61_fin_59		,
	output		[31:0]					to_vecMac61_fin_60		
);

//	这些参数后面可以放到VH文件里
localparam	STRIDE = 4;
localparam	KH	=	11;
localparam	OW	=	55;
localparam 	VECLEN = 61;
localparam 	LINE_NEED	=	6;			//	ceil(VECLEN / KH)
localparam 	FIN_LINE_NUM = 232;			//	需要实际是227，但是为了简化代码，需要令其为8的整数倍
localparam 	FIN_LINE_NUM_256 = (FIN_LINE_NUM * 32) / 256;

parameter	IDLE			=	3'd0;
parameter	LINE_NEED_INIT	=	3'd1;	//	每个特征图通道最开始的LINE_NEED需要缓存下来，作为初始化部分
parameter	WAIT_TRIGGER	=	3'd2;	//	等待读或写的具体控制请求，因为BRAM在一个时刻只能读或者写
parameter	WRITE_BRAM		=	3'd3;	//	特征图数据写入BRAM，虽然LINE_NEED_INIT也是将特征图数据写入BRAM，但是LINE_NEED_INIT是初始化用的
parameter	CHANNEL_END		=	3'd4;	//	当前特征图通道的数据全部处理结束

reg	[4:0]	line_in_cnt_256;			//	当前行输入了多少个256bit的数据
reg [2:0]	buf_line_sel;				//	用于指示当前行的缓存应该放进哪组bram里,下标从1开始表示有效的数据
reg [3:0]	bram_row_wr_sel;			//	用于指示当前是缓存了多少个6行的特征图，有效下标从0开始
//	需要ceil(vecLen / KH)行的缓存，并且每行都需要vecLen个缓存
reg [31 : 0]	line0_0,line0_1,line0_2,line0_3,line0_4,line0_5,line0_6,line0_7,line0_8,line0_9,line0_10;
reg [31 : 0]	line1_0,line1_1,line1_2,line1_3,line1_4,line1_5,line1_6,line1_7,line1_8,line1_9,line1_10;
reg [31 : 0]	line2_0,line2_1,line2_2,line2_3,line2_4,line2_5,line2_6,line2_7,line2_8,line2_9,line2_10;
reg [31 : 0]	line3_0,line3_1,line3_2,line3_3,line3_4,line3_5,line3_6,line3_7,line3_8,line3_9,line3_10;
reg [31 : 0]	line4_0,line4_1,line4_2,line4_3,line4_4,line4_5,line4_6,line4_7,line4_8,line4_9,line4_10;
reg [31 : 0]	line5_0,line5_1,line5_2,line5_3,line5_4,line5_5,line5_6,line5_7,line5_8,line5_9,line5_10;

//	检测new_fin_line和new_fin_channel的上升沿
reg new_fin_line_r;				wire new_fin_line_pos;
reg new_fin_channel_r;			wire new_fin_channel_pos;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		new_fin_line_r <= 1'b0;
		new_fin_channel_r <= 1'b0;
	end
	else 
	begin
		new_fin_line_r <= new_fin_line;
		new_fin_channel_r <= new_fin_channel;
	end
end
assign	new_fin_line_pos = new_fin_line && (~new_fin_line_r);
assign	new_fin_channel_pos = new_fin_channel && (~new_fin_channel_r);

//	当前行输入了多少个256bit的数据，29 * 8 =  232
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		line_in_cnt_256 <= 5'd0;
		line_in_cnt_32 <= 9'd0;
	end
	else if (new_fin_line_pos)								//	新的一行要来了肯定清空计数器
	begin
		line_in_cnt_256 <= 5'd0;
		line_in_cnt_32 <= 9'd0;
	end
	else if (fin_vld)										//	有效数据来了就加1或加8
	begin
		line_in_cnt_256 <= line_in_cnt_256 + 5'd1;			//	由于line_in_cnt_256是在fin_vld的下一个时钟才加1，因此使用line_in_cnt_256作为地址信号是刚好实现从0~28的有效值
		line_in_cnt_32 <= line_in_cnt_32 + 9'd8;
	end
end

//	当前处理到哪一行了
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		bram_row_wr_sel <= 4'd0;
		line_cnt <= 9'd0;
		buf_line_sel <= 3'd0;
	end
	else if (new_fin_channel_pos)								//	新的特征图要来了肯定清空计数器
	begin
		bram_row_wr_sel <= 4'd0;
		line_cnt <= 9'd0;
		buf_line_sel <= 3'd0;
	end
	else if (new_fin_line_pos)									//	新的特征图来了就加1
	begin
		line_cnt <= line_cnt + 9'd1;
		if (buf_line_sel == LINE_NEED)							//	如果当前行是需要缓存的最后一行，那么下一行应该放进第一个bram缓存里
		begin
			buf_line_sel <= 3'd1;
			bram_row_wr_sel <= bram_row_wr_sel + 4'd1;
		end
		else	
		begin
			buf_line_sel <= buf_line_sel + 3'd1;
			bram_row_wr_sel <= bram_row_wr_sel;
		end
	end
end

//	三段式状态机第一段
reg [2:0] current_state, next_state;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
		current_state <= IDLE;
	else 
		current_state <= next_state;
end

//	三段式状态机第二段
always @(*)
begin
	case (current_state)
		IDLE:
		begin
			//	只有当有新的通道数据请求过来才能从IDLE切换状态
			if (new_fin_channel_pos)
				next_state = LINE_NEED_INIT;
			else
				next_state = IDLE;
		end
		LINE_NEED_INIT:
		begin
			//	只要当需要的行数缓存完毕了才能退出初始化状态
			if ((line_cnt == LINE_NEED) && (line_in_cnt_256 == FIN_LINE_NUM_256))
				next_state = WAIT_TRIGGER;
			else
				next_state = LINE_NEED_INIT;
		end
		WAIT_TRIGGER:								//	由于读BRAM不会数据丢失或改变，所以不需要设置单独的读状态
		begin
			if (wr_fin_while_calc)					//	将特征图写入RBAM
				next_state = WRITE_BRAM;
			else if (cur_channel_done)				//	当前特征图通道的数据处理完毕
				next_state = CHANNEL_END;
			else
				next_state = WAIT_TRIGGER;
		end
		WRITE_BRAM:									//	在计算的过程中除了把特征图数据写入bram外，还需要从bram读出下次计算所需要的特征图数据，以及从DDR中读出权重数据写到权重缓存模块
		begin
			if (wr_fin_while_calc)					//	将特征图写入RBAM
				next_state = WRITE_BRAM;
			else
				next_state = WAIT_TRIGGER;
		end
		CHANNEL_END:
			next_state = IDLE;
		default:	
			next_state = IDLE;
	endcase
end

//	状态机第三段，对现态和次态的译码
wire 						bram_wr_en;
wire	[LINE_NEED - 1:0]	wr_bram_en;
assign	bram_wr_en = (current_state == LINE_NEED_INIT) || (current_state == WRITE_BRAM);	//	只有当处于初始化和写BRAM状态时才允许向BRAM写数据
//	只有当前是往bram_i写数据并且由数据有效信号时才能往BRAM写数据
genvar i;
for (i = 0; i < LINE_NEED; i = i + 1)
begin
	assign	wr_bram_en[i] = (buf_line_sel == (i + 1)) && fin_vld;
end

//	需要提前把下一个ceil(vecLen / KH)行的头(vecLen - 8)个数读取出来
reg [31:0] pre_line0_0,pre_line0_1,pre_line0_2;
reg [31:0] pre_line1_0,pre_line1_1,pre_line1_2;
reg [31:0] pre_line2_0,pre_line2_1,pre_line2_2;
reg [31:0] pre_line3_0,pre_line3_1,pre_line3_2;
reg [31:0] pre_line4_0,pre_line4_1,pre_line4_2;
reg [31:0] pre_line5_0,pre_line5_1,pre_line5_2;

//	缓存是按照6行11列进行缓存，最终输出的时候需要自己截取61个数据
//	缓存第一行，一定要注意256bit的数据中每32bit的数据究竟对应哪一个特征图数据
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)	
	begin
		line0_0 <= 32'd0;	line0_1 <= 32'd0;	line0_2 <= 32'd0;	line0_3 <= 32'd0;
		line0_4 <= 32'd0;	line0_5 <= 32'd0;	line0_6 <= 32'd0;	line0_7	<= 32'd0;
		line0_8 <= 32'd0;	line0_9 <= 32'd0;	line0_10 <= 32'd0;
	end
	else if (current_state == LINE_NEED_INIT)	//	在行初始化缓存阶段的操作
	begin
		if (wr_bram_en[0] && (line_in_cnt_256 == 5'd0))	//	在fin_vld高电平时line_in_cnt_256还没来得及加1
		begin
			{line0_7,line0_6,line0_5,line0_4,line0_3,line0_2,line0_1,line0_0} <= from_ddr_fin;
		end
		else if (wr_bram_en[0] && (line_in_cnt_256 == 5'd1))
		begin
			{line0_10,line0_9,line0_8} <= from_ddr_fin[95:0];
		end
	end
	else if (cur_fout_col == (OW - 1))			//	正在处理此LINE_NEED行的最后一组数据
	begin
		//	首先要注意pre_line0_0,pre_line0_1,pre_line0_2要在这个处理时刻的前两个时钟给出读BRAM请求
		//	line0_doutb要在这个处理时刻的前一个时钟给出读bram请求
		{line0_10,line0_9,line0_8,line0_7,line0_6,line0_5,line0_4,line0_3,line0_2,line0_1,line0_0} <= {line0_doutb,pre_line0_2,pre_line0_1,pre_line0_0};
	end
	else if (vecMac_proc)			//	如果正在计算中就把下次用的数据准备好
	begin
		//	这个时刻的难点在于取出更新所需的4个像素点的位置在哪
		if (bram_rd_en[6] == 1'b1)	//	需要用到3 4 5 6
			{line0_10,line0_9,line0_8,line0_7,line0_6,line0_5,line0_4,line0_3,line0_2,line0_1,line0_0} <= {line0_addrb_6,line0_addrb_5,line0_addrb_4,line0_addrb_3,line0_10,line0_9,line0_8,line0_7,line0_6,line0_5,line0_4};
		else						//	需要用到7 0 1 2
			{line0_10,line0_9,line0_8,line0_7,line0_6,line0_5,line0_4,line0_3,line0_2,line0_1,line0_0} <= {line0_addrb_2,line0_addrb_1,line0_addrb_0,line0_addrb_7,line0_10,line0_9,line0_8,line0_7,line0_6,line0_5,line0_4};
	end
end

//	由于6行是完全并行读取的，因此6组BRAM共用读地址信号是完全可行的
reg [8:0] addrb_0, addrb_1, addrb_2, addrb_3;	
reg [8:0] addrb_4, addrb_5, addrb_6, addrb_7;	
reg [7:0] bram_rd_en;	//	哪个bit是1就说明那组bram中哪个子bram会被读到
//////////////////////////////////////////////////////////////////////////////////还要把cur_fout_row_time也考虑进去//////////////////////////////////////////////////////////////////////////////////
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin	
		addrb_0 <=9'd0;	addrb_1 <= 9'd0;	addrb_2 <= 9'd0;	addrb_3 <= 9'd0;
		addrb_4 <=9'd0;	addrb_5 <= 9'd0;	addrb_6 <= 9'd0;	addrb_7 <= 9'd0;
	end
	else if (current_state == LINE_NEED_INIT)
	begin
		//	由于KH是11，所以从第12个fin肯定是要从bram中读出，又由于每组bram是8个32bit数据，所以第12个数据是从addrb_3开始
		//	3 4 5 6/ 7 0 1 2/ 3 4 5 6/ 7 0 1 2的规律依次一组读出4个数
		addrb_0 <= 9'd2;	addrb_1 <= 9'd2;	addrb_2 <= 9'd2;	addrb_3 <= 9'd1;
		addrb_4 <= 9'd1;	addrb_5 <= 9'd1;	addrb_6 <= 9'd1;	addrb_7 <= 9'd1;
	end
	else if (cur_fout_col == (OW - 3))	
	begin
		addrb_0 <= 9'd0;	addrb_1 <= 9'd0;	addrb_2 <= 9'd0;	addrb_3 <= 9'd0;
		addrb_4 <= 9'd0;	addrb_5 <= 9'd0;	addrb_6 <= 9'd0;	addrb_7 <= 9'd0;
		bram_rd_en <= 8'b0000_0111;		//	
	end
	else if (cur_fout_col == (OW - 2))	
	begin
		//	ceil(vecLen / KH)行最后(KH - 1)列正在处理时给下次要读数据的地址，注意是需要提前一个时钟给信号
		//	在处理当前的ceil(vecLen / KH)行时要记得把下次要用的ceil(vecLen / KH)行行所需要的(KH - 8) * ceil(vecLen / KH)个数缓存下来
		addrb_0 <= 9'd1;	addrb_1 <= 9'd1;	addrb_2 <= 9'd1;	addrb_3 <= 9'd0;
		addrb_4 <= 9'd0;	addrb_5 <= 9'd0;	addrb_6 <= 9'd0;	addrb_7 <= 9'd0;
		bram_rd_en <= 8'hff;		//	
	end
	else
	begin
		//	在正常的右移过程中，要么bram_rd_en[6:3]是f，要么bram_rd_en[2:0,7]是f
		if (bram_rd_en[0] == 1'b1)			addrb_0 <= addrb_0 + 9'd1;
		if (bram_rd_en[1] == 1'b1)			addrb_1 <= addrb_1 + 9'd1;
		if (bram_rd_en[2] == 1'b1)			addrb_2 <= addrb_2 + 9'd1;
		if (bram_rd_en[3] == 1'b1)			addrb_3 <= addrb_3 + 9'd1;
		if (bram_rd_en[4] == 1'b1)			addrb_4 <= addrb_4 + 9'd1;
		if (bram_rd_en[5] == 1'b1)			addrb_5 <= addrb_5 + 9'd1;
		if (bram_rd_en[6] == 1'b1)			addrb_6 <= addrb_6 + 9'd1;
		if (bram_rd_en[7] == 1'b1)			addrb_7 <= addrb_7 + 9'd1;
	end
end

//	8个bram_32_512组成一组bram_256_512，然后一共调用ceil(vecLen / KH)个bram_256_512
//	这种写法是可以的，但是有点浪费存储资源
//	输入特征图第0行缓存
reg [8:0]	line0_addrb_0, line0_addrb_1, line0_addrb_2, line0_addrb_3;	
reg [8:0]	line0_addrb_4, line0_addrb_5, line0_addrb_6, line0_addrb_7;	
wire [255 : 0] line0_doutb;        
bram_256_512 fin_buf_line0 (
    .clka 		(clk                        				),
    .wea  		(bram_wr_en && wr_bram_en[0]				),
    .addra		({bram_row_wr_sel,line_in_cnt_256}         	),
    .dina 		(from_ddr_fin               				),
			
    .clkb 		(clk                        				),
    .addrb_0	(line0_addrb_0                				),
    .addrb_1	(line0_addrb_1                				),
    .addrb_2	(line0_addrb_2                				),
    .addrb_3	(line0_addrb_3                				),
    .addrb_4	(line0_addrb_4                				),
    .addrb_5	(line0_addrb_5                				),
    .addrb_6	(line0_addrb_6                				),
    .addrb_7	(line0_addrb_7                				),
    .doutb		(line0_doutb                				)
);

//	输入特征图第1行缓存
reg [8 : 0] line1_addrb_0, line1_addrb_1, line1_addrb_2, line1_addrb_3;	
reg [8 : 0] line1_addrb_4, line1_addrb_5, line1_addrb_6, line1_addrb_7;	
wire [255 : 0] line1_doutb;        
bram_256_512 fin_buf_line1 (
    .clka 		(clk                        				),
    .wea  		(bram_wr_en && wr_bram_en[1]				),
    .addra		({bram_row_wr_sel,line_in_cnt_256}         	),
    .dina 		(from_ddr_fin               				),
			
    .clkb 		(clk                        				),
    .addrb_0	(line1_addrb_0                				),
    .addrb_1	(line1_addrb_1                				),
    .addrb_2	(line1_addrb_2                				),
    .addrb_3	(line1_addrb_3                				),
    .addrb_4	(line1_addrb_4                				),
    .addrb_5	(line1_addrb_5                				),
    .addrb_6	(line1_addrb_6                				),
    .addrb_7	(line1_addrb_7                				),
    .doutb		(line1_doutb                				)
);			

//	输入特征图第2行缓存
reg [8 : 0] line2_addrb_0, line2_addrb_1, line2_addrb_2, line2_addrb_3;	
reg [8 : 0] line2_addrb_4, line2_addrb_5, line2_addrb_6, line2_addrb_7;	
wire [255 : 0] line2_doutb;        
bram_256_512 fin_buf_line2 (
    .clka 		(clk                        				),
    .wea  		(bram_wr_en && wr_bram_en[2]				),
    .addra		({bram_row_wr_sel,line_in_cnt_256}         	),
    .dina 		(from_ddr_fin               				),
			
    .clkb 		(clk                        				),
    .addrb_0	(line2_addrb_0                				),
    .addrb_1	(line2_addrb_1                				),
    .addrb_2	(line2_addrb_2                				),
    .addrb_3	(line2_addrb_3                				),
    .addrb_4	(line2_addrb_4                				),
    .addrb_5	(line2_addrb_5                				),
    .addrb_6	(line2_addrb_6                				),
    .addrb_7	(line2_addrb_7                				),
    .doutb		(line2_doutb                				)
);

//	输入特征图第3行缓存
reg [8 : 0] line3_addrb_0, line3_addrb_1, line3_addrb_2, line3_addrb_3;	
reg [8 : 0] line3_addrb_4, line3_addrb_5, line3_addrb_6, line3_addrb_7;	
wire [255 : 0] line3_doutb;        
bram_256_512 fin_buf_line3 (
    .clka 		(clk                        				),
    .wea  		(bram_wr_en && wr_bram_en[3]				),
    .addra		({bram_row_wr_sel,line_in_cnt_256}         	),
    .dina 		(from_ddr_fin               				),
			
    .clkb 		(clk                        				),
    .addrb_0	(line3_addrb_0                				),
    .addrb_1	(line3_addrb_1                				),
    .addrb_2	(line3_addrb_2                				),
    .addrb_3	(line3_addrb_3                				),
    .addrb_4	(line3_addrb_4                				),
    .addrb_5	(line3_addrb_5                				),
    .addrb_6	(line3_addrb_6                				),
    .addrb_7	(line3_addrb_7                				),
    .doutb		(line3_doutb                				)
);

//	输入特征图第4行缓存
reg [8 : 0] line4_addrb_0, line4_addrb_1, line4_addrb_2, line4_addrb_3;	
reg [8 : 0] line4_addrb_4, line4_addrb_5, line4_addrb_6, line4_addrb_7;	
wire [255 : 0] line4_doutb;        
bram_256_512 fin_buf_line4 (
    .clka 		(clk                        				),
    .wea  		(bram_wr_en && wr_bram_en[4]				),
    .addra		({bram_row_wr_sel,line_in_cnt_256}         	),
    .dina 		(from_ddr_fin               				),
			
    .clkb 		(clk                        				),
    .addrb_0	(line4_addrb_0                				),
    .addrb_1	(line4_addrb_1                				),
    .addrb_2	(line4_addrb_2                				),
    .addrb_3	(line4_addrb_3                				),
    .addrb_4	(line4_addrb_4                				),
    .addrb_5	(line4_addrb_5                				),
    .addrb_6	(line4_addrb_6                				),
    .addrb_7	(line4_addrb_7                				),
    .doutb		(line4_doutb                				)
);

//	输入特征图第5行缓存
reg [8 : 0] line5_addrb_0, line5_addrb_1, line5_addrb_2, line5_addrb_3;	
reg [8 : 0] line5_addrb_4, line5_addrb_5, line5_addrb_6, line5_addrb_7;	
wire [255 : 0] line5_doutb;        
bram_256_512 fin_buf_line5 (
    .clka 		(clk                        				),
    .wea  		(bram_wr_en && wr_bram_en[5]				),
    .addra		({bram_row_wr_sel,line_in_cnt_256}         	),
    .dina 		(from_ddr_fin               				),
			
    .clkb 		(clk                        				),
    .addrb_0	(line5_addrb_0                				),
    .addrb_1	(line5_addrb_1                				),
    .addrb_2	(line5_addrb_2                				),
    .addrb_3	(line5_addrb_3                				),
    .addrb_4	(line5_addrb_4                				),
    .addrb_5	(line5_addrb_5                				),
    .addrb_6	(line5_addrb_6                				),
    .addrb_7	(line5_addrb_7                				),
    .doutb		(line5_doutb                				)
);

endmodule
