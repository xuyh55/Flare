/*
	时间：			2023.10.18
	功能：			实现输入权重数据的缓存
	
	数据类型：		单精度浮点
	版本：			1.0
	
	时序：			① 200MHz时钟
	
	功能限制部分：	①	权重的缓存方案是：wgt[0][:][0][:], wgt[1][:][0][:], wgt[0][:][1][:], wgt[1][:][1][:], wgt[0][:][2][:], wgt[1][:][2][:]
	
	可改进的方向：	① 	
	
	修改：			① 	新增一个初始化缓存的指示信号init_buf
	
	修改意图：		① 
	
	设计想法：		①	
*/
module conv0_wgt_par6_o66 (
	input							clk						,		//	200M
	input							rst_n					,
		
	//	与控制模块的交互信号	
	input							new_wgt_fout_chnl		,		//	把WEIGHT[i:i+1][:][:][:]看做一个新的权重输出通道,也就是说来新的上升沿之前一定是因为2 * 3 * 11 * 11个权值数据都缓存完毕了
	input							fin_calc_done			,		//	当前的fin层数据全部处理完了,也意味着当的wgt[i][:][:][:]和wgt[i+1][:][:][:]处理完毕了
	input							init_buf				,		//	表示当前正在最开始的8 * 3 * 2 *11个权重的缓存过程中
	input							conv0_calc_ing			,		//	表明此时正在计算过程中
	
	input	 	 [5:0]				fout_proc_chnl			,		//	当前正在处理fout_chnl和fout_chnl+1输出特征通道的数据,因为输出通道并行度为2
	input	 	 [5:0]				fout_proc_row			,		//	当前正在处理输出特征图的哪一行,有效值是0~54
	input	 	 [5:0]				fout_proc_col			,		//	当前正在处理输出特征图的哪一列,有效值是0~54
	input		 [3:0]				win_proc_row			,		//	当前正在处理卷积窗的哪一行
	
	input							proc_col_last			,		//	正在处理当前行的最后一列数据	
	input							proc_col_next_last		,		//	正在处理当前行的倒数第二列数据,增加这个状态的目的是考虑到状态 -> 地址 -> 数据一共有两个时钟的延迟
	input							proc_win_last_row		,		//	正在处理当前窗口的最后一行
	
	output	reg	[6:0]				din_cnt					,		//	对DDR输入的256bit数据计数,2 * 3 * 11 * 11 = 726,再加66个32'd0凑成总bit数为256bit的整数倍
	output	reg	[4:0]				ch_out_buf_cnt			,		//	缓存了多少个WEIGHT[i][:][:][:]，取值范围是0~31,
		
	//	来自DDR的fin数据	
	output	reg						wgt_buf_empty			,		
	output	 						wgt_buf_full			,		//	可以从DDR中接收数据,主要是要考虑新来的数据会不会把还没读出的权重数据给覆盖了
	input		[255:0]				from_ddr_fin			,		//	虽然DDR最大是100M & 256bit,但是在FPGA中用大一倍的带宽是接收数据
	input							din_vld					,
		
	//	根据优化策略,输入通道并行度为3,输出通道并行度为2
	output		 					vecMac11_wgt_ok			,		//	计算所需要的权重数据都准备好了
	output			[31:0]			wgt_fout0_fin0_0		,
	output			[31:0]			wgt_fout0_fin0_1		,
	output			[31:0]			wgt_fout0_fin0_2		,
	output			[31:0]			wgt_fout0_fin0_3		,
	output			[31:0]			wgt_fout0_fin0_4		,
	output			[31:0]			wgt_fout0_fin0_5		,
	output			[31:0]			wgt_fout0_fin0_6		,
	output	   		[31:0]			wgt_fout0_fin0_7		,
	output	  		[31:0]			wgt_fout0_fin0_8		,
	output	  		[31:0]			wgt_fout0_fin0_9		,
	output	  		[31:0]			wgt_fout0_fin0_10		,
	
	output	    	[31:0]			wgt_fout0_fin1_0		,
	output	    	[31:0]			wgt_fout0_fin1_1		,
	output	    	[31:0]			wgt_fout0_fin1_2		,
	output	    	[31:0]			wgt_fout0_fin1_3		,
	output	    	[31:0]			wgt_fout0_fin1_4		,
	output	    	[31:0]			wgt_fout0_fin1_5		,
	output	    	[31:0]			wgt_fout0_fin1_6		,
	output	    	[31:0]			wgt_fout0_fin1_7		,
	output	    	[31:0]			wgt_fout0_fin1_8		,
	output	    	[31:0]			wgt_fout0_fin1_9		,
	output	    	[31:0]			wgt_fout0_fin1_10		,
	
	output	    	[31:0]			wgt_fout0_fin2_0		,
	output	    	[31:0]			wgt_fout0_fin2_1		,
	output	    	[31:0]			wgt_fout0_fin2_2		,
	output	    	[31:0]			wgt_fout0_fin2_3		,
	output	    	[31:0]			wgt_fout0_fin2_4		,
	output	    	[31:0]			wgt_fout0_fin2_5		,
	output	    	[31:0]			wgt_fout0_fin2_6		,
	output			[31:0]			wgt_fout0_fin2_7		,
	output			[31:0]			wgt_fout0_fin2_8		,
	output			[31:0]			wgt_fout0_fin2_9		,
	output			[31:0]			wgt_fout0_fin2_10		,
	
	output			[31:0]			wgt_fout1_fin0_0		,
	output			[31:0]			wgt_fout1_fin0_1		,
	output			[31:0]			wgt_fout1_fin0_2		,
	output			[31:0]			wgt_fout1_fin0_3		,
	output			[31:0]			wgt_fout1_fin0_4		,
	output			[31:0]			wgt_fout1_fin0_5		,
	output			[31:0]			wgt_fout1_fin0_6		,
	output	   		[31:0]			wgt_fout1_fin0_7		,
	output	  		[31:0]			wgt_fout1_fin0_8		,
	output	  		[31:0]			wgt_fout1_fin0_9		,
	output	  		[31:0]			wgt_fout1_fin0_10		,
	
	output	    	[31:0]			wgt_fout1_fin1_0		,
	output	    	[31:0]			wgt_fout1_fin1_1		,
	output	    	[31:0]			wgt_fout1_fin1_2		,
	output	    	[31:0]			wgt_fout1_fin1_3		,
	output	    	[31:0]			wgt_fout1_fin1_4		,
	output	    	[31:0]			wgt_fout1_fin1_5		,
	output	    	[31:0]			wgt_fout1_fin1_6		,
	output	    	[31:0]			wgt_fout1_fin1_7		,
	output	    	[31:0]			wgt_fout1_fin1_8		,
	output	    	[31:0]			wgt_fout1_fin1_9		,
	output	    	[31:0]			wgt_fout1_fin1_10		,
	
	output	    	[31:0]			wgt_fout1_fin2_0		,
	output	    	[31:0]			wgt_fout1_fin2_1		,
	output	    	[31:0]			wgt_fout1_fin2_2		,
	output	    	[31:0]			wgt_fout1_fin2_3		,
	output	    	[31:0]			wgt_fout1_fin2_4		,
	output	    	[31:0]			wgt_fout1_fin2_5		,
	output	    	[31:0]			wgt_fout1_fin2_6		,
	output	  		[31:0]			wgt_fout1_fin2_7		,
	output	  		[31:0]			wgt_fout1_fin2_8		,
	output	  		[31:0]			wgt_fout1_fin2_9		,
	output	  		[31:0]			wgt_fout1_fin2_10		
);

//	这些参数后面可以放到VH文件里
localparam	CONV0_STRIDE	= 	4	;
localparam	CONV0_KH		=	11	;
localparam	CONV0_KW		=	11	;
localparam	CONV0_IH		=	227	;
localparam	CONV0_IW		=	227	;
localparam	CONV0_IC		=	3	;
localparam	CONV0_OH		=	55	;
localparam	CONV0_OW		=	55	;
localparam	CONV0_OC		=	64	;
localparam 	CONV0_FIN_PAR	=	3	;			//	输入通道并行度为3
localparam 	CONV0_FOUT_PAR	=	2	;			//	输出通道并行度为3
localparam	INIT_WGT_BUF	=	8	;			//	根据设计的探索算法发现至少需要缓存8个6*11权重数据才能实现后续的一边计算一边缓存,因此在din_cnt >= INIT_WGT_BUF * BUF_66_WGT_CLK之后才能认为权重部分准备好了
localparam 	BUF_66_WGT_CLK	=	18	;			//	为了简化代码,把3 * 2 * 11 = 66放大到72,这样就需要72 / 4 = 18个时钟
localparam 	WGT_FOUT_NUM	=	99	;			//	72 * 11 / 8 = 99,意思是3 * 2 * 11 * 11个32bit需要扩展到99个256bit数据

//	上升沿检测专用
reg new_wgt_fout_chnl_r;	wire	new_wgt_fout_chnl_pos;
reg fin_calc_done_r;		wire	fin_calc_done_pos;
reg proc_win_last_row_r;		wire	proc_win_last_row_pos;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		new_wgt_fout_chnl_r <= 1'b0;
		fin_calc_done_r <= 1'b0;
		proc_win_last_row_r <= 1'b0;
	end
	else 
	begin
		new_wgt_fout_chnl_r <= new_wgt_fout_chnl;		//	检测new_wgt_fout_chnl的上升沿
		fin_calc_done_r <= fin_calc_done;				//	检测fin_calc_done上升沿
		proc_win_last_row_r <= proc_win_last_row;				//	检测proc_win_last_row上升沿
	end
end
assign new_wgt_fout_chnl_pos = new_wgt_fout_chnl && (!new_wgt_fout_chnl_r);
assign fin_calc_done_pos = fin_calc_done && (!fin_calc_done_r);
assign proc_win_last_row_pos = proc_win_last_row && (!proc_win_last_row_r);


//	对输入的256bit数据计数,以及对权重输出通道的计数器
wire wgt_fout_last = din_cnt == WGT_FOUT_NUM - 1;			
wire [4:0]	ch_out_buf_cnt_tmp;
assign	 ch_out_buf_cnt_tmp = ch_out_buf_cnt + wgt_fout_last;			
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		din_cnt <= 7'd0;
		ch_out_buf_cnt <= 5'd0;
	end
	else if (new_wgt_fout_chnl_pos && din_vld)			//	如果新的权重输出通道和数据有效同时到来
	begin
		din_cnt <= 7'd1;
		ch_out_buf_cnt <= ch_out_buf_cnt;				//	此时不用急着更新权重输出通道计数器的值
	end
	else if (new_wgt_fout_chnl_pos)				//	如果有新的权重输出通道要来了肯定要清空计数器
	begin
		din_cnt <= 7'd0;
		ch_out_buf_cnt <= ch_out_buf_cnt;				//	此时不用急着更新权重输出通道计数器的值
	end
	else if (din_vld)
	begin
		if (wgt_fout_last)		
		begin
			din_cnt <= 7'd0;
			ch_out_buf_cnt <= ch_out_buf_cnt_tmp;	//	权重输出通道的最后一个256bit被缓存了才能加1
		end
		else 
		begin
			din_cnt <= din_cnt + 7'd1;
			ch_out_buf_cnt <= ch_out_buf_cnt;
		end
	end
end

reg [31:0]  buf_fout0_fin0_0,	buf_fout0_fin0_1,	buf_fout0_fin0_2,	buf_fout0_fin0_3,	buf_fout0_fin0_4,	buf_fout0_fin0_5,	buf_fout0_fin0_6,	buf_fout0_fin0_7,	buf_fout0_fin0_8,	buf_fout0_fin0_9,	buf_fout0_fin0_10;
reg [31:0]  buf_fout1_fin0_0,	buf_fout1_fin0_1,	buf_fout1_fin0_2,	buf_fout1_fin0_3,	buf_fout1_fin0_4,	buf_fout1_fin0_5,	buf_fout1_fin0_6,	buf_fout1_fin0_7,	buf_fout1_fin0_8,	buf_fout1_fin0_9,	buf_fout1_fin0_10;
reg [31:0]  buf_fout0_fin1_0,	buf_fout0_fin1_1,	buf_fout0_fin1_2,	buf_fout0_fin1_3,	buf_fout0_fin1_4,	buf_fout0_fin1_5,	buf_fout0_fin1_6,	buf_fout0_fin1_7,	buf_fout0_fin1_8,	buf_fout0_fin1_9,	buf_fout0_fin1_10;
reg [31:0]  buf_fout1_fin1_0,	buf_fout1_fin1_1,	buf_fout1_fin1_2,	buf_fout1_fin1_3,	buf_fout1_fin1_4,	buf_fout1_fin1_5,	buf_fout1_fin1_6,	buf_fout1_fin1_7,	buf_fout1_fin1_8,	buf_fout1_fin1_9,	buf_fout1_fin1_10;
reg [31:0]  buf_fout0_fin2_0,	buf_fout0_fin2_1,	buf_fout0_fin2_2,	buf_fout0_fin2_3,	buf_fout0_fin2_4,	buf_fout0_fin2_5,	buf_fout0_fin2_6,	buf_fout0_fin2_7,	buf_fout0_fin2_8,	buf_fout0_fin2_9,	buf_fout0_fin2_10;
reg [31:0]  buf_fout1_fin2_0,	buf_fout1_fin2_1,	buf_fout1_fin2_2,	buf_fout1_fin2_3,	buf_fout1_fin2_4,	buf_fout1_fin2_5,	buf_fout1_fin2_6,	buf_fout1_fin2_7,	buf_fout1_fin2_8,	buf_fout1_fin2_9,	buf_fout1_fin2_10;


//	用于读出权重数据
reg [1:0]	rd_wgt_fout_cnt;																//	读出wgt[rd_wgt_fout_cnt+1:rd_wgt_fout_cnt][:][:][:]
reg [6:0]	addrb;																			//	由于是把3*2*11凑成了8的倍数,因此后面bram的8个读地址只需要一个就够了
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		rd_wgt_fout_cnt <= 2'd0;
		addrb <= 7'd0;
	end
	else if (init_buf || (conv0_calc_ing == 0))			//	既然在最开始的缓存过程中，那相关读地址信号肯定是0,如果还没开始计算，也先别读权重数据
	begin
		rd_wgt_fout_cnt <= 2'd0;
		addrb <= 7'd9;
	end
	else if (fin_calc_done_pos)							//	由于输出通道的并行度为2,所以这里应该加2,但是由于存储的时候是两个输出通道一起缓存,因此加1就够了
	begin
		rd_wgt_fout_cnt <= rd_wgt_fout_cnt + 1'd1;
		addrb <= 7'd0;									//	通道都更新了,那通道内的具体地址肯定从0开始
	end
	else if ((win_proc_row == 4'd9) && proc_col_last)	//	如果当前是处理win的倒数第二行的最后一个数据，那么意味着下一行肯定是win的最后一行，由于代码是提前一行的时间准备好下次计算所需要的数据，因此此时需要提前一个时钟给出地址
	begin
		rd_wgt_fout_cnt <= rd_wgt_fout_cnt;
		addrb <= 7'd0;	
	end
	else if (fout_proc_col == 6'd0)						//	如果是处理第一列数据,那么就开始准备下一行计算所需要的权重数据
	begin
		rd_wgt_fout_cnt <= rd_wgt_fout_cnt;
		addrb <= addrb + 7'd1;
	end
	else if (vecMac11_wgt_ok == 0)						//	vecMac11_wgt_ok为0说明需要更新权重数据了
	begin
		rd_wgt_fout_cnt <= rd_wgt_fout_cnt;
		addrb <= addrb + 7'd1;
	end
end

//	bram存储状态的判断，由于权重是需要把每个通道的数据都读很多次，因此在一个通道的数据被完全用不上之前不能被新的数据覆盖
wire addr_eq = rd_wgt_fout_cnt == ch_out_buf_cnt_tmp[1:0];		//	目的是提取一个时钟拿到满标志
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		wgt_buf_empty <= 1'b1;
	end
	else if ((din_cnt != addrb) && (addr_eq == 0))				//	地址不等,那么肯定不满也不空	
	begin
		wgt_buf_empty <= 1'b0;
	end
	else if (addr_eq && wgt_buf_empty)
	begin
		wgt_buf_empty <= 1'b1;
	end
	else if (addr_eq)
	begin
		wgt_buf_empty <= 1'b0;
	end
end
assign	wgt_buf_full = addr_eq && (wgt_buf_empty == 0);

//	1组bram_256_512用于缓存权重数据,8 * 512 / (3 * 11 * 11) = 11
//	意味着bram_256_512可以缓存weight[10:0][:][:][:]，为了简化代码,只缓存weight[7:0][:][:][:]
wire [255 : 0] bram_doutb;        
bram_256_512 wgt_buf (
    .clka 		(clk                        				),
    .wea  		(din_vld									),
    .addra		({ch_out_buf_cnt[1:0],din_cnt} 			 	),
    .dina 		(from_ddr_fin				        		),
			
    .clkb 		(clk	                        			),
	.rstb		(!rst_n										),
    .addrb_0 	({rd_wgt_fout_cnt,addrb}        			),
    .addrb_1 	({rd_wgt_fout_cnt,addrb}					),
    .addrb_2 	({rd_wgt_fout_cnt,addrb}					),
    .addrb_3 	({rd_wgt_fout_cnt,addrb}					),
    .addrb_4 	({rd_wgt_fout_cnt,addrb}					),
    .addrb_5 	({rd_wgt_fout_cnt,addrb}					),
    .addrb_6 	({rd_wgt_fout_cnt,addrb}					),
    .addrb_7 	({rd_wgt_fout_cnt,addrb}					),
    .doutb		(bram_doutb	                				)
);

assign vecMac11_wgt_ok = (fout_proc_col > 6'd8) || (addrb == 7'd9);	//	第一个条件是开始计算到第8个数据了，第二个条件是初始化结束了
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		buf_fout0_fin0_0	<=	32'd0;	buf_fout0_fin1_0	<=	32'd0;	buf_fout0_fin2_0	<=	32'd0;	buf_fout1_fin0_0	<=	32'd0;	buf_fout1_fin1_0	<=	32'd0;	buf_fout1_fin2_0	<=	32'd0;	
		buf_fout0_fin0_1	<=	32'd0;	buf_fout0_fin1_1	<=	32'd0;	buf_fout0_fin2_1	<=	32'd0;	buf_fout1_fin0_1	<=	32'd0;	buf_fout1_fin1_1	<=	32'd0;	buf_fout1_fin2_1	<=	32'd0;	
		buf_fout0_fin0_2	<=	32'd0;	buf_fout0_fin1_2	<=	32'd0;	buf_fout0_fin2_2	<=	32'd0;	buf_fout1_fin0_2	<=	32'd0;	buf_fout1_fin1_2	<=	32'd0;	buf_fout1_fin2_2	<=	32'd0;	
		buf_fout0_fin0_3	<=	32'd0;	buf_fout0_fin1_3	<=	32'd0;	buf_fout0_fin2_3	<=	32'd0;	buf_fout1_fin0_3	<=	32'd0;	buf_fout1_fin1_3	<=	32'd0;	buf_fout1_fin2_3	<=	32'd0;	
		buf_fout0_fin0_4	<=	32'd0;	buf_fout0_fin1_4	<=	32'd0;	buf_fout0_fin2_4	<=	32'd0;	buf_fout1_fin0_4	<=	32'd0;	buf_fout1_fin1_4	<=	32'd0;	buf_fout1_fin2_4	<=	32'd0;	
		buf_fout0_fin0_5	<=	32'd0;	buf_fout0_fin1_5	<=	32'd0;	buf_fout0_fin2_5	<=	32'd0;	buf_fout1_fin0_5	<=	32'd0;	buf_fout1_fin1_5	<=	32'd0;	buf_fout1_fin2_5	<=	32'd0;	
		buf_fout0_fin0_6	<=	32'd0;	buf_fout0_fin1_6	<=	32'd0;	buf_fout0_fin2_6	<=	32'd0;	buf_fout1_fin0_6	<=	32'd0;	buf_fout1_fin1_6	<=	32'd0;	buf_fout1_fin2_6	<=	32'd0;	
		buf_fout0_fin0_7	<=	32'd0;	buf_fout0_fin1_7	<=	32'd0;	buf_fout0_fin2_7	<=	32'd0;	buf_fout1_fin0_7	<=	32'd0;	buf_fout1_fin1_7	<=	32'd0;	buf_fout1_fin2_7	<=	32'd0;	
		buf_fout0_fin0_8	<=	32'd0;	buf_fout0_fin1_8	<=	32'd0;	buf_fout0_fin2_8	<=	32'd0;	buf_fout1_fin0_8	<=	32'd0;	buf_fout1_fin1_8	<=	32'd0;	buf_fout1_fin2_8	<=	32'd0;	
		buf_fout0_fin0_9	<=	32'd0;	buf_fout0_fin1_9	<=	32'd0;	buf_fout0_fin2_9	<=	32'd0;	buf_fout1_fin0_9	<=	32'd0;	buf_fout1_fin1_9	<=	32'd0;	buf_fout1_fin2_9	<=	32'd0;	
		buf_fout0_fin0_10	<=	32'd0;	buf_fout0_fin1_10	<=	32'd0;	buf_fout0_fin2_10	<=	32'd0;	buf_fout1_fin0_10	<=	32'd0;	buf_fout1_fin1_10	<=	32'd0;	buf_fout1_fin2_10	<=	32'd0;	
	end
	else if (init_buf && din_vld)			//	在缓存过程中就把第一次计算所需要的权重数据准备好
	begin
		case (din_cnt)	//	0~8输出地址,自然1~9拿到数据
			6'd0:	begin {buf_fout0_fin0_7,buf_fout0_fin0_6,buf_fout0_fin0_5,buf_fout0_fin0_4,buf_fout0_fin0_3,buf_fout0_fin0_2,buf_fout0_fin0_1,buf_fout0_fin0_0} <= from_ddr_fin;	end			//	wgt[0][0][0][0:7]
			6'd1:	{buf_fout0_fin1_4,buf_fout0_fin1_3,buf_fout0_fin1_2,buf_fout0_fin1_1,buf_fout0_fin1_0,buf_fout0_fin0_10,buf_fout0_fin0_9,buf_fout0_fin0_8} <= from_ddr_fin;		//	wgt[0][1][0][0:4],wgt[0][0][0][8:10]
			6'd2:	{buf_fout0_fin2_1,buf_fout0_fin2_0,buf_fout0_fin1_10,buf_fout0_fin1_9,buf_fout0_fin1_8,buf_fout0_fin1_7,buf_fout0_fin1_6,buf_fout0_fin1_5} <= from_ddr_fin;		//	wgt[0][2][0][0:1],wgt[0][1][0][5:10]
			6'd3:	{buf_fout0_fin2_9,buf_fout0_fin2_8,buf_fout0_fin2_7,buf_fout0_fin2_6,buf_fout0_fin2_5,buf_fout0_fin2_4,buf_fout0_fin2_3,buf_fout0_fin2_2} <= from_ddr_fin;		//	wgt[0][2][0][2:9]
			6'd4:	{buf_fout1_fin0_6,buf_fout1_fin0_5,buf_fout1_fin0_4,buf_fout1_fin0_3,buf_fout1_fin0_2,buf_fout1_fin0_1,buf_fout1_fin0_0,buf_fout0_fin2_10} <= from_ddr_fin;		//	wgt[1][0][0][0:6],wgt[0][2][0][10]
			6'd5:	{buf_fout1_fin1_3,buf_fout1_fin1_2,buf_fout1_fin1_1,buf_fout1_fin1_0,buf_fout1_fin0_10,buf_fout1_fin0_9,buf_fout1_fin0_8,buf_fout1_fin0_7} <= from_ddr_fin;		//	wgt[1][1][0][0:3],wgt[1][0][0][7:10]
			6'd6:	{buf_fout1_fin2_0,buf_fout1_fin1_10,buf_fout1_fin1_9,buf_fout1_fin1_8,buf_fout1_fin1_7,buf_fout1_fin1_6,buf_fout1_fin1_5,buf_fout1_fin1_4} <= from_ddr_fin;		//	wgt[1][2][0][0],wgt[1][1][0][4:10]
			6'd7:	{buf_fout1_fin2_8,buf_fout1_fin2_7,buf_fout1_fin2_6,buf_fout1_fin2_5,buf_fout1_fin2_4,buf_fout1_fin2_3,buf_fout1_fin2_2,buf_fout1_fin2_1} <= from_ddr_fin;		//	wgt[1][2][0][1:8]
			6'd8:	begin	{buf_fout1_fin2_10,buf_fout1_fin2_9} <= from_ddr_fin[63:0];	end																	//	wgt[1][2][0][9:10],多了6个0
			default:
			begin
					buf_fout0_fin0_0	<=	buf_fout0_fin0_0;	buf_fout0_fin1_0	<=	buf_fout0_fin1_0;	buf_fout0_fin2_0	<=	buf_fout0_fin2_0;	buf_fout1_fin0_0	<=	buf_fout1_fin0_0;	buf_fout1_fin1_0	<=	buf_fout1_fin1_0;	buf_fout1_fin2_0	<=	buf_fout1_fin2_0;	
					buf_fout0_fin0_1	<=	buf_fout0_fin0_1;	buf_fout0_fin1_1	<=	buf_fout0_fin1_1;	buf_fout0_fin2_1	<=	buf_fout0_fin2_1;	buf_fout1_fin0_1	<=	buf_fout1_fin0_1;	buf_fout1_fin1_1	<=	buf_fout1_fin1_1;	buf_fout1_fin2_1	<=	buf_fout1_fin2_1;	
					buf_fout0_fin0_2	<=	buf_fout0_fin0_2;	buf_fout0_fin1_2	<=	buf_fout0_fin1_2;	buf_fout0_fin2_2	<=	buf_fout0_fin2_2;	buf_fout1_fin0_2	<=	buf_fout1_fin0_2;	buf_fout1_fin1_2	<=	buf_fout1_fin1_2;	buf_fout1_fin2_2	<=	buf_fout1_fin2_2;	
					buf_fout0_fin0_3	<=	buf_fout0_fin0_3;	buf_fout0_fin1_3	<=	buf_fout0_fin1_3;	buf_fout0_fin2_3	<=	buf_fout0_fin2_3;	buf_fout1_fin0_3	<=	buf_fout1_fin0_3;	buf_fout1_fin1_3	<=	buf_fout1_fin1_3;	buf_fout1_fin2_3	<=	buf_fout1_fin2_3;	
					buf_fout0_fin0_4	<=	buf_fout0_fin0_4;	buf_fout0_fin1_4	<=	buf_fout0_fin1_4;	buf_fout0_fin2_4	<=	buf_fout0_fin2_4;	buf_fout1_fin0_4	<=	buf_fout1_fin0_4;	buf_fout1_fin1_4	<=	buf_fout1_fin1_4;	buf_fout1_fin2_4	<=	buf_fout1_fin2_4;	
					buf_fout0_fin0_5	<=	buf_fout0_fin0_5;	buf_fout0_fin1_5	<=	buf_fout0_fin1_5;	buf_fout0_fin2_5	<=	buf_fout0_fin2_5;	buf_fout1_fin0_5	<=	buf_fout1_fin0_5;	buf_fout1_fin1_5	<=	buf_fout1_fin1_5;	buf_fout1_fin2_5	<=	buf_fout1_fin2_5;	
					buf_fout0_fin0_6	<=	buf_fout0_fin0_6;	buf_fout0_fin1_6	<=	buf_fout0_fin1_6;	buf_fout0_fin2_6	<=	buf_fout0_fin2_6;	buf_fout1_fin0_6	<=	buf_fout1_fin0_6;	buf_fout1_fin1_6	<=	buf_fout1_fin1_6;	buf_fout1_fin2_6	<=	buf_fout1_fin2_6;	
					buf_fout0_fin0_7	<=	buf_fout0_fin0_7;	buf_fout0_fin1_7	<=	buf_fout0_fin1_7;	buf_fout0_fin2_7	<=	buf_fout0_fin2_7;	buf_fout1_fin0_7	<=	buf_fout1_fin0_7;	buf_fout1_fin1_7	<=	buf_fout1_fin1_7;	buf_fout1_fin2_7	<=	buf_fout1_fin2_7;	
					buf_fout0_fin0_8	<=	buf_fout0_fin0_8;	buf_fout0_fin1_8	<=	buf_fout0_fin1_8;	buf_fout0_fin2_8	<=	buf_fout0_fin2_8;	buf_fout1_fin0_8	<=	buf_fout1_fin0_8;	buf_fout1_fin1_8	<=	buf_fout1_fin1_8;	buf_fout1_fin2_8	<=	buf_fout1_fin2_8;	
					buf_fout0_fin0_9	<=	buf_fout0_fin0_9;	buf_fout0_fin1_9	<=	buf_fout0_fin1_9;	buf_fout0_fin2_9	<=	buf_fout0_fin2_9;	buf_fout1_fin0_9	<=	buf_fout1_fin0_9;	buf_fout1_fin1_9	<=	buf_fout1_fin1_9;	buf_fout1_fin2_9	<=	buf_fout1_fin2_9;	
					buf_fout0_fin0_10	<=	buf_fout0_fin0_10;	buf_fout0_fin1_10	<=	buf_fout0_fin1_10;	buf_fout0_fin2_10	<=	buf_fout0_fin2_10;	buf_fout1_fin0_10	<=	buf_fout1_fin0_10;	buf_fout1_fin1_10	<=	buf_fout1_fin1_10;	buf_fout1_fin2_10	<=	buf_fout1_fin2_10;
			end
		endcase
	end
	else 		
	begin
		case (fout_proc_col)	//	0~8输出地址,自然1~9拿到数据
			6'd1:	begin {buf_fout0_fin0_7,buf_fout0_fin0_6,buf_fout0_fin0_5,buf_fout0_fin0_4,buf_fout0_fin0_3,buf_fout0_fin0_2,buf_fout0_fin0_1,buf_fout0_fin0_0} <= bram_doutb;	end			//	wgt[0][0][0][0:7]
			6'd2:	{buf_fout0_fin1_4,buf_fout0_fin1_3,buf_fout0_fin1_2,buf_fout0_fin1_1,buf_fout0_fin1_0,buf_fout0_fin0_10,buf_fout0_fin0_9,buf_fout0_fin0_8} <= bram_doutb;		//	wgt[0][1][0][0:4],wgt[0][0][0][8:10]
			6'd3:	{buf_fout0_fin2_1,buf_fout0_fin2_0,buf_fout0_fin1_10,buf_fout0_fin1_9,buf_fout0_fin1_8,buf_fout0_fin1_7,buf_fout0_fin1_6,buf_fout0_fin1_5} <= bram_doutb;		//	wgt[0][2][0][0:1],wgt[0][1][0][5:10]
			6'd4:	{buf_fout0_fin2_9,buf_fout0_fin2_8,buf_fout0_fin2_7,buf_fout0_fin2_6,buf_fout0_fin2_5,buf_fout0_fin2_4,buf_fout0_fin2_3,buf_fout0_fin2_2} <= bram_doutb;		//	wgt[0][2][0][2:9]
			6'd5:	{buf_fout1_fin0_6,buf_fout1_fin0_5,buf_fout1_fin0_4,buf_fout1_fin0_3,buf_fout1_fin0_2,buf_fout1_fin0_1,buf_fout1_fin0_0,buf_fout0_fin2_10} <= bram_doutb;		//	wgt[1][0][0][0:6],wgt[0][2][0][10]
			6'd6:	{buf_fout1_fin1_3,buf_fout1_fin1_2,buf_fout1_fin1_1,buf_fout1_fin1_0,buf_fout1_fin0_10,buf_fout1_fin0_9,buf_fout1_fin0_8,buf_fout1_fin0_7} <= bram_doutb;		//	wgt[1][1][0][0:3],wgt[1][0][0][7:10]
			6'd7:	{buf_fout1_fin2_0,buf_fout1_fin1_10,buf_fout1_fin1_9,buf_fout1_fin1_8,buf_fout1_fin1_7,buf_fout1_fin1_6,buf_fout1_fin1_5,buf_fout1_fin1_4} <= bram_doutb;		//	wgt[1][2][0][0],wgt[1][1][0][4:10]
			6'd8:	{buf_fout1_fin2_8,buf_fout1_fin2_7,buf_fout1_fin2_6,buf_fout1_fin2_5,buf_fout1_fin2_4,buf_fout1_fin2_3,buf_fout1_fin2_2,buf_fout1_fin2_1} <= bram_doutb;		//	wgt[1][2][0][1:8]
			6'd9:	begin	{buf_fout1_fin2_10,buf_fout1_fin2_9} <= bram_doutb[63:0];	end																	//	wgt[1][2][0][9:10],多了6个0
			default:
			begin
					buf_fout0_fin0_0	<=	buf_fout0_fin0_0;	buf_fout0_fin1_0	<=	buf_fout0_fin1_0;	buf_fout0_fin2_0	<=	buf_fout0_fin2_0;	buf_fout1_fin0_0	<=	buf_fout1_fin0_0;	buf_fout1_fin1_0	<=	buf_fout1_fin1_0;	buf_fout1_fin2_0	<=	buf_fout1_fin2_0;	
					buf_fout0_fin0_1	<=	buf_fout0_fin0_1;	buf_fout0_fin1_1	<=	buf_fout0_fin1_1;	buf_fout0_fin2_1	<=	buf_fout0_fin2_1;	buf_fout1_fin0_1	<=	buf_fout1_fin0_1;	buf_fout1_fin1_1	<=	buf_fout1_fin1_1;	buf_fout1_fin2_1	<=	buf_fout1_fin2_1;	
					buf_fout0_fin0_2	<=	buf_fout0_fin0_2;	buf_fout0_fin1_2	<=	buf_fout0_fin1_2;	buf_fout0_fin2_2	<=	buf_fout0_fin2_2;	buf_fout1_fin0_2	<=	buf_fout1_fin0_2;	buf_fout1_fin1_2	<=	buf_fout1_fin1_2;	buf_fout1_fin2_2	<=	buf_fout1_fin2_2;	
					buf_fout0_fin0_3	<=	buf_fout0_fin0_3;	buf_fout0_fin1_3	<=	buf_fout0_fin1_3;	buf_fout0_fin2_3	<=	buf_fout0_fin2_3;	buf_fout1_fin0_3	<=	buf_fout1_fin0_3;	buf_fout1_fin1_3	<=	buf_fout1_fin1_3;	buf_fout1_fin2_3	<=	buf_fout1_fin2_3;	
					buf_fout0_fin0_4	<=	buf_fout0_fin0_4;	buf_fout0_fin1_4	<=	buf_fout0_fin1_4;	buf_fout0_fin2_4	<=	buf_fout0_fin2_4;	buf_fout1_fin0_4	<=	buf_fout1_fin0_4;	buf_fout1_fin1_4	<=	buf_fout1_fin1_4;	buf_fout1_fin2_4	<=	buf_fout1_fin2_4;	
					buf_fout0_fin0_5	<=	buf_fout0_fin0_5;	buf_fout0_fin1_5	<=	buf_fout0_fin1_5;	buf_fout0_fin2_5	<=	buf_fout0_fin2_5;	buf_fout1_fin0_5	<=	buf_fout1_fin0_5;	buf_fout1_fin1_5	<=	buf_fout1_fin1_5;	buf_fout1_fin2_5	<=	buf_fout1_fin2_5;	
					buf_fout0_fin0_6	<=	buf_fout0_fin0_6;	buf_fout0_fin1_6	<=	buf_fout0_fin1_6;	buf_fout0_fin2_6	<=	buf_fout0_fin2_6;	buf_fout1_fin0_6	<=	buf_fout1_fin0_6;	buf_fout1_fin1_6	<=	buf_fout1_fin1_6;	buf_fout1_fin2_6	<=	buf_fout1_fin2_6;	
					buf_fout0_fin0_7	<=	buf_fout0_fin0_7;	buf_fout0_fin1_7	<=	buf_fout0_fin1_7;	buf_fout0_fin2_7	<=	buf_fout0_fin2_7;	buf_fout1_fin0_7	<=	buf_fout1_fin0_7;	buf_fout1_fin1_7	<=	buf_fout1_fin1_7;	buf_fout1_fin2_7	<=	buf_fout1_fin2_7;	
					buf_fout0_fin0_8	<=	buf_fout0_fin0_8;	buf_fout0_fin1_8	<=	buf_fout0_fin1_8;	buf_fout0_fin2_8	<=	buf_fout0_fin2_8;	buf_fout1_fin0_8	<=	buf_fout1_fin0_8;	buf_fout1_fin1_8	<=	buf_fout1_fin1_8;	buf_fout1_fin2_8	<=	buf_fout1_fin2_8;	
					buf_fout0_fin0_9	<=	buf_fout0_fin0_9;	buf_fout0_fin1_9	<=	buf_fout0_fin1_9;	buf_fout0_fin2_9	<=	buf_fout0_fin2_9;	buf_fout1_fin0_9	<=	buf_fout1_fin0_9;	buf_fout1_fin1_9	<=	buf_fout1_fin1_9;	buf_fout1_fin2_9	<=	buf_fout1_fin2_9;	
					buf_fout0_fin0_10	<=	buf_fout0_fin0_10;	buf_fout0_fin1_10	<=	buf_fout0_fin1_10;	buf_fout0_fin2_10	<=	buf_fout0_fin2_10;	buf_fout1_fin0_10	<=	buf_fout1_fin0_10;	buf_fout1_fin1_10	<=	buf_fout1_fin1_10;	buf_fout1_fin2_10	<=	buf_fout1_fin2_10;
			end
		endcase
	end
end

//	每个输出特征图的第一列处理时才需要更新权重
assign	wgt_fout0_fin0_0	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_0	:	wgt_fout0_fin0_0	;
assign	wgt_fout0_fin0_1	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_1	:	wgt_fout0_fin0_1	;
assign	wgt_fout0_fin0_2	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_2	:	wgt_fout0_fin0_2	;
assign	wgt_fout0_fin0_3	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_3	:	wgt_fout0_fin0_3	;
assign	wgt_fout0_fin0_4	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_4	:	wgt_fout0_fin0_4	;
assign	wgt_fout0_fin0_5	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_5	:	wgt_fout0_fin0_5	;
assign	wgt_fout0_fin0_6	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_6	:	wgt_fout0_fin0_6	;
assign	wgt_fout0_fin0_7	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_7	:	wgt_fout0_fin0_7	;
assign	wgt_fout0_fin0_8	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_8	:	wgt_fout0_fin0_8	;
assign	wgt_fout0_fin0_9	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_9	:	wgt_fout0_fin0_9	;
assign	wgt_fout0_fin0_10	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin0_10	:	wgt_fout0_fin0_10	;
assign	wgt_fout0_fin1_0	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_0	:	wgt_fout0_fin1_0	;
assign	wgt_fout0_fin1_1	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_1	:	wgt_fout0_fin1_1	;
assign	wgt_fout0_fin1_2	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_2	:	wgt_fout0_fin1_2	;
assign	wgt_fout0_fin1_3	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_3	:	wgt_fout0_fin1_3	;
assign	wgt_fout0_fin1_4	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_4	:	wgt_fout0_fin1_4	;
assign	wgt_fout0_fin1_5	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_5	:	wgt_fout0_fin1_5	;
assign	wgt_fout0_fin1_6	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_6	:	wgt_fout0_fin1_6	;
assign	wgt_fout0_fin1_7	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_7	:	wgt_fout0_fin1_7	;
assign	wgt_fout0_fin1_8	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_8	:	wgt_fout0_fin1_8	;
assign	wgt_fout0_fin1_9	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_9	:	wgt_fout0_fin1_9	;
assign	wgt_fout0_fin1_10	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin1_10	:	wgt_fout0_fin1_10	;
assign	wgt_fout0_fin2_0	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_0	:	wgt_fout0_fin2_0	;
assign	wgt_fout0_fin2_1	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_1	:	wgt_fout0_fin2_1	;
assign	wgt_fout0_fin2_2	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_2	:	wgt_fout0_fin2_2	;
assign	wgt_fout0_fin2_3	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_3	:	wgt_fout0_fin2_3	;
assign	wgt_fout0_fin2_4	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_4	:	wgt_fout0_fin2_4	;
assign	wgt_fout0_fin2_5	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_5	:	wgt_fout0_fin2_5	;
assign	wgt_fout0_fin2_6	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_6	:	wgt_fout0_fin2_6	;
assign	wgt_fout0_fin2_7	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_7	:	wgt_fout0_fin2_7	;
assign	wgt_fout0_fin2_8	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_8	:	wgt_fout0_fin2_8	;
assign	wgt_fout0_fin2_9	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_9	:	wgt_fout0_fin2_9	;
assign	wgt_fout0_fin2_10	=	(fout_proc_col == 6'd0)	?	buf_fout0_fin2_10	:	wgt_fout0_fin2_10	;
assign	wgt_fout1_fin0_0	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_0	:	wgt_fout1_fin0_0	;
assign	wgt_fout1_fin0_1	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_1	:	wgt_fout1_fin0_1	;
assign	wgt_fout1_fin0_2	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_2	:	wgt_fout1_fin0_2	;
assign	wgt_fout1_fin0_3	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_3	:	wgt_fout1_fin0_3	;
assign	wgt_fout1_fin0_4	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_4	:	wgt_fout1_fin0_4	;
assign	wgt_fout1_fin0_5	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_5	:	wgt_fout1_fin0_5	;
assign	wgt_fout1_fin0_6	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_6	:	wgt_fout1_fin0_6	;
assign	wgt_fout1_fin0_7	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_7	:	wgt_fout1_fin0_7	;
assign	wgt_fout1_fin0_8	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_8	:	wgt_fout1_fin0_8	;
assign	wgt_fout1_fin0_9	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_9	:	wgt_fout1_fin0_9	;
assign	wgt_fout1_fin0_10	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin0_10	:	wgt_fout1_fin0_10	;
assign	wgt_fout1_fin1_0	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_0	:	wgt_fout1_fin1_0	;
assign	wgt_fout1_fin1_1	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_1	:	wgt_fout1_fin1_1	;
assign	wgt_fout1_fin1_2	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_2	:	wgt_fout1_fin1_2	;
assign	wgt_fout1_fin1_3	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_3	:	wgt_fout1_fin1_3	;
assign	wgt_fout1_fin1_4	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_4	:	wgt_fout1_fin1_4	;
assign	wgt_fout1_fin1_5	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_5	:	wgt_fout1_fin1_5	;
assign	wgt_fout1_fin1_6	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_6	:	wgt_fout1_fin1_6	;
assign	wgt_fout1_fin1_7	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_7	:	wgt_fout1_fin1_7	;
assign	wgt_fout1_fin1_8	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_8	:	wgt_fout1_fin1_8	;
assign	wgt_fout1_fin1_9	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_9	:	wgt_fout1_fin1_9	;
assign	wgt_fout1_fin1_10	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin1_10	:	wgt_fout1_fin1_10	;
assign	wgt_fout1_fin2_0	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_0	:	wgt_fout1_fin2_0	;
assign	wgt_fout1_fin2_1	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_1	:	wgt_fout1_fin2_1	;
assign	wgt_fout1_fin2_2	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_2	:	wgt_fout1_fin2_2	;
assign	wgt_fout1_fin2_3	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_3	:	wgt_fout1_fin2_3	;
assign	wgt_fout1_fin2_4	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_4	:	wgt_fout1_fin2_4	;
assign	wgt_fout1_fin2_5	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_5	:	wgt_fout1_fin2_5	;
assign	wgt_fout1_fin2_6	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_6	:	wgt_fout1_fin2_6	;
assign	wgt_fout1_fin2_7	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_7	:	wgt_fout1_fin2_7	;
assign	wgt_fout1_fin2_8	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_8	:	wgt_fout1_fin2_8	;
assign	wgt_fout1_fin2_9	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_9	:	wgt_fout1_fin2_9	;
assign	wgt_fout1_fin2_10	=	(fout_proc_col == 6'd0)	?	buf_fout1_fin2_10	:	wgt_fout1_fin2_10	;

endmodule