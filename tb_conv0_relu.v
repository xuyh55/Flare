`timescale 1ns/100ps
module tb_conv0_relu();

reg								clk					;
reg								rst_n				;

//	控制模块交互信号                                ;
reg		[1:0]					in_channel			;
reg								new_fin_channel		;
reg								new_fin_row			;
wire							conv0_calc_ing		;
reg								fin_calc_done		;

wire	[7:0]					fin_ch0_row_cnt		;
wire	[7:0]					fin_ch1_row_cnt		;
wire	[7:0]					fin_ch2_row_cnt		;

reg [5:0]					fout_proc_chnl			;
reg	[5:0]					fout_proc_row			;
reg	[5:0]					kernel_row_cnt			;
reg [5:0]					fout_proc_col			;

//	来自DDR的fin数据                                ;
wire							fin_buf_row0_empty	;
wire							fin_buf_row0_full	;
wire							fin_buf_row1_empty	;
wire							fin_buf_row1_full	;
wire							fin_buf_row2_empty	;
wire							fin_buf_row2_full	;
reg		[255:0]					from_ddr_fin		;
reg								fin_vld				;

reg		[255:0]				wgt_from_ddr_fin    ;
reg							wgt_din_vld		    ;
reg 						new_wgt_fout_chnl	;

reg [15:0]	ch0_cnt,ch1_cnt,ch2_cnt;
//	227 * (232 / 8) = 6583
reg [11:0]	wgt_cnt;
reg [255:0]	fin_ch0 [6582:0];	reg [255:0]	fin_ch1 [6582:0];	reg [255:0]	fin_ch2 [6582:0];
reg [255:0]	conv0_weight [3167:0];

//	检测new_fin_row和new_fin_channel的上升沿
reg new_fin_row_r;				wire new_fin_row_pos;
reg new_fin_channel_r;			wire new_fin_channel_pos;

wire	[6:0]				din_cnt			          ;
wire	[4:0]				ch_out_buf_cnt            ;
wire						wgt_buf_empty	          ;
wire						wgt_buf_full	          ;

wire							init_buf				;

wire	 			vecMac11_wgt_ok			;		//	计算所需要的权重数据都准备好了
wire	[31:0]		wgt_fout0_fin0_0		;
wire	[31:0]		wgt_fout0_fin0_1		;
wire	[31:0]		wgt_fout0_fin0_2		;
wire	[31:0]		wgt_fout0_fin0_3		;
wire	[31:0]		wgt_fout0_fin0_4		;
wire	[31:0]		wgt_fout0_fin0_5		;
wire	[31:0]		wgt_fout0_fin0_6		;
wire    [31:0]		wgt_fout0_fin0_7		;
wire	[31:0]		wgt_fout0_fin0_8		;
wire	[31:0]		wgt_fout0_fin0_9		;
wire	[31:0]		wgt_fout0_fin0_10		;														
wire	[31:0]		wgt_fout0_fin1_0		;
wire	[31:0]		wgt_fout0_fin1_1		;
wire	[31:0]		wgt_fout0_fin1_2		;
wire	[31:0]		wgt_fout0_fin1_3		;
wire	[31:0]		wgt_fout0_fin1_4		;
wire	[31:0]		wgt_fout0_fin1_5		;
wire	[31:0]		wgt_fout0_fin1_6		;
wire	[31:0]		wgt_fout0_fin1_7		;
wire	[31:0]		wgt_fout0_fin1_8		;
wire	[31:0]		wgt_fout0_fin1_9		;
wire	[31:0]		wgt_fout0_fin1_10		;														
wire	[31:0]		wgt_fout0_fin2_0		;
wire	[31:0]		wgt_fout0_fin2_1		;
wire	[31:0]		wgt_fout0_fin2_2		;
wire	[31:0]		wgt_fout0_fin2_3		;
wire	[31:0]		wgt_fout0_fin2_4		;
wire	[31:0]		wgt_fout0_fin2_5		;
wire	[31:0]		wgt_fout0_fin2_6		;
wire	[31:0]		wgt_fout0_fin2_7		;
wire	[31:0]		wgt_fout0_fin2_8		;
wire	[31:0]		wgt_fout0_fin2_9		;
wire	[31:0]		wgt_fout0_fin2_10		;														
wire	[31:0]		wgt_fout1_fin0_0		;
wire	[31:0]		wgt_fout1_fin0_1		;
wire	[31:0]		wgt_fout1_fin0_2		;
wire	[31:0]		wgt_fout1_fin0_3		;
wire	[31:0]		wgt_fout1_fin0_4		;
wire	[31:0]		wgt_fout1_fin0_5		;
wire	[31:0]		wgt_fout1_fin0_6		;
wire 	[31:0]		wgt_fout1_fin0_7		;
wire	[31:0]		wgt_fout1_fin0_8		;
wire	[31:0]		wgt_fout1_fin0_9		;
wire	[31:0]		wgt_fout1_fin0_10		;														
wire	[31:0]		wgt_fout1_fin1_0		;
wire	[31:0]		wgt_fout1_fin1_1		;
wire	[31:0]		wgt_fout1_fin1_2		;
wire	[31:0]		wgt_fout1_fin1_3		;
wire	[31:0]		wgt_fout1_fin1_4		;
wire	[31:0]		wgt_fout1_fin1_5		;
wire	[31:0]		wgt_fout1_fin1_6		;
wire	[31:0]		wgt_fout1_fin1_7		;
wire	[31:0]		wgt_fout1_fin1_8		;
wire	[31:0]		wgt_fout1_fin1_9		;
wire	[31:0]		wgt_fout1_fin1_10		;														
wire	[31:0]		wgt_fout1_fin2_0		;
wire	[31:0]		wgt_fout1_fin2_1		;
wire	[31:0]		wgt_fout1_fin2_2		;
wire	[31:0]		wgt_fout1_fin2_3		;
wire	[31:0]		wgt_fout1_fin2_4		;
wire	[31:0]		wgt_fout1_fin2_5		;
wire	[31:0]		wgt_fout1_fin2_6		;
wire	[31:0]		wgt_fout1_fin2_7		;
wire	[31:0]		wgt_fout1_fin2_8		;
wire	[31:0]		wgt_fout1_fin2_9		;
wire	[31:0]		wgt_fout1_fin2_10		;

wire				vecMac11_fin_ok		;
wire	[31:0]  	fin_ch0_0   		;
wire	[31:0]  	fin_ch0_1   		;
wire	[31:0]  	fin_ch0_2   		;
wire	[31:0]  	fin_ch0_3   		;
wire	[31:0]  	fin_ch0_4   		;
wire	[31:0]  	fin_ch0_5   		;
wire	[31:0]  	fin_ch0_6   		;
wire	[31:0]  	fin_ch0_7   		;
wire	[31:0]  	fin_ch0_8   		;
wire	[31:0]  	fin_ch0_9   		;
wire	[31:0]  	fin_ch0_10  		;
wire	[31:0]  	fin_ch1_0   		;
wire	[31:0]  	fin_ch1_1   		;
wire	[31:0]  	fin_ch1_2   		;
wire	[31:0]  	fin_ch1_3   		;
wire	[31:0]  	fin_ch1_4   		;
wire	[31:0]  	fin_ch1_5   		;
wire	[31:0]  	fin_ch1_6   		;
wire	[31:0]  	fin_ch1_7   		;
wire	[31:0]  	fin_ch1_8   		;
wire	[31:0]  	fin_ch1_9   		;
wire	[31:0]  	fin_ch1_10  		;
wire	[31:0]  	fin_ch2_0   		;
wire	[31:0]  	fin_ch2_1   		;
wire	[31:0]  	fin_ch2_2   		;
wire	[31:0]  	fin_ch2_3   		;
wire	[31:0]  	fin_ch2_4   		;
wire	[31:0]  	fin_ch2_5   		;
wire	[31:0]  	fin_ch2_6   		;
wire	[31:0]  	fin_ch2_7   		;
wire	[31:0]  	fin_ch2_8   		;
wire	[31:0]  	fin_ch2_9   		;
wire	[31:0]  	fin_ch2_10  		;

wire	[5:0]				real_proc_fout_chnl		;	//	由于数据从输入到输出需要一段时间，因此用这组信号表示输出数据有效时对应的坐标
wire	[5:0]				real_proc_fout_row		;	//	
wire	[5:0]				real_proc_fout_col		;	//	
wire	[3:0]				real_proc_win_row		;	//	

 //	当前通道计数
 reg [1:0] in_channel_r;
initial
begin
	$readmemh("C:/Users/11787/Desktop/jupyter_lab/fin_ch_0.txt", fin_ch0);
	$readmemh("C:/Users/11787/Desktop/jupyter_lab/fin_ch_1.txt", fin_ch1);
	$readmemh("C:/Users/11787/Desktop/jupyter_lab/fin_ch_2.txt", fin_ch2);
	$readmemh("C:/Users/11787/Desktop/jupyter_lab/conv0_weight.txt", conv0_weight);
	
/* 	$readmemh("/home/xuyh/Desktop/alexnet/tb/fin_ch_0.txt", fin_ch0);
	$readmemh("/home/xuyh/Desktop/alexnet/tb/fin_ch_1.txt", fin_ch1);
	$readmemh("/home/xuyh/Desktop/alexnet/tb/fin_ch_2.txt", fin_ch2);	 
	$readmemh("/home/xuyh/Desktop/alexnet/tb/conv0_weight.txt", conv0_weight);*/
	
	clk = 0;
	rst_n = 0;
	
	in_channel			   = 0;
	in_channel_r		   = 0;
	new_fin_channel		   = 0;
	new_fin_row			   = 0;
	fin_calc_done		   = 0;
	
	fout_proc_chnl	       = 0;
	fout_proc_row	       = 0;
	kernel_row_cnt	       = 0;
	fout_proc_col	       = 0;
	
	ch0_cnt = 0;
	ch1_cnt = 0;
	ch2_cnt = 0;
	
	new_fin_row_r <= 0;
	new_fin_channel_r <= 1'b0;
	
	wgt_cnt					=	0;
	wgt_from_ddr_fin       	= 0;
	wgt_din_vld		       	= 0;
	new_wgt_fout_chnl 		= 0;
	
	#123
	rst_n = 1;
	
	wait((real_proc_fout_chnl == 31) && (real_proc_fout_row == 54) && (real_proc_fout_col == 54) && (real_proc_win_row == 10));		
	#1000
	$stop();
end

always #2.5 clk = ~clk;

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


always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		in_channel_r <= 2'b0;
	end
	else
		in_channel_r <= in_channel;
end 

//	生成写进BRAM的权重和特征图数据数据
wire	wgt_wr_bram_en;
assign	wgt_wr_bram_en = conv0_calc_ing	?	1	:	init_buf;		//	在
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		wgt_cnt <= 12'd0;
		wgt_from_ddr_fin   <= 0;
		wgt_din_vld		   <= 0;
	end
	else if ((wgt_buf_full == 0) && (wgt_cnt < 3168) && wgt_wr_bram_en)				//	只要bram没有满就可以写
	begin
		wgt_cnt <= wgt_cnt + 12'd1;
		wgt_from_ddr_fin   <= conv0_weight[wgt_cnt];
		wgt_din_vld		   <= 1;
		if (wgt_cnt % 99 == 0)														//	72 / 8 * 11 = 99
			new_wgt_fout_chnl <= 1'b1;
		else
			new_wgt_fout_chnl <= 1'b0;	
	end
	else	//	不管是满了还是全部缓存了都让状态保持不变
	begin
		wgt_cnt <= wgt_cnt;
		wgt_from_ddr_fin   <= wgt_from_ddr_fin;
		wgt_din_vld		   <= 0;
	end
end

wire	fin_wr_bram_en;
assign	fin_wr_bram_en = ~wgt_din_vld;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		ch0_cnt <= 1'b0;
		ch1_cnt <= 1'b0;
		ch2_cnt <= 1'b0;
		new_fin_channel		  <= 0;
		new_fin_row <= 0;
		from_ddr_fin <= 256'd0;
		fin_vld <= 1'b0;
		in_channel <= 1'b0;
	end
	else if ((in_channel >= 1) && fin_wr_bram_en)
	begin
		if ((in_channel == 1) && (fin_buf_row0_full == 0))
		begin
			if (ch0_cnt == 6582)
				ch0_cnt <= 0;
			else
				ch0_cnt <= ch0_cnt + 1;
			from_ddr_fin <= fin_ch0[ch0_cnt];
			fin_vld <= 1'b1;
			if ((ch0_cnt + 1) % 29 == 0)
			begin
				new_fin_channel <= 1;
				new_fin_row <= 1;
				in_channel <= 2'd2;
			end
			else
			begin
				in_channel <= 2'd1;
				new_fin_row <= 0;
				new_fin_channel <= 0;
			end
		end		
		else if ((in_channel == 2) && (fin_buf_row1_full == 0))
		begin
			if (ch1_cnt == 6582)
				ch1_cnt <= 0;
			else
				ch1_cnt <= ch1_cnt + 1;
			from_ddr_fin <= fin_ch1[ch1_cnt];
			fin_vld <= 1'b1;
			if ((ch1_cnt + 1) % 29 == 0)
			begin
				new_fin_channel <= 1;
				new_fin_row <= 1;
				in_channel <= 2'd3;
			end
			else
			begin
				new_fin_row <= 0;
				new_fin_channel <= 0;
				in_channel <= 2'd2;
			end
		end
		else if ((in_channel == 3) && (fin_buf_row2_full == 0))
		begin
			if (ch2_cnt == 6582)
				ch2_cnt <= 0;
			else
				ch2_cnt <= ch2_cnt + 1;
			from_ddr_fin <= fin_ch2[ch2_cnt];
			fin_vld <= 1'b1;
			if ((ch2_cnt + 1) % 29 == 0)
			begin
				new_fin_channel <= 1;
				new_fin_row <= 1;
				in_channel <= 2'd1;
			end
			else
			begin
				new_fin_row <= 0;
				new_fin_channel <= 0;
				in_channel <= 2'd3;
			end
		end
		else 
		begin
			fin_vld <= 1'b0;
		end
	end
	else 
	begin
		fin_vld <= 1'b0;
		if ((fin_buf_row0_full == 0) && (fin_buf_row1_full == 0)&& (fin_buf_row2_full == 0))
		begin
			in_channel <= conv0_calc_ing ? in_channel : 1;
			new_fin_channel <= conv0_calc_ing ? new_fin_channel : 1;
			new_fin_row <= new_fin_channel;
		end
		else
		begin
			new_fin_row <= 0;
			new_fin_channel <= 0;
		end
	end
end

//	当数据缓存好了就可以开始计算了 232 * 13 / 8 = 377
assign conv0_calc_ing = ((wgt_cnt >= 72) && (ch0_cnt >= 377) && (ch1_cnt >= 377) && (ch2_cnt >=377)) ? 1 : (fout_proc_chnl > 0) || ((fout_proc_row > 0) && (fout_proc_col >= 0));
assign	init_buf  = wgt_cnt <= 72;
//	生成处理过程中的状态信息														//	取值范围是0~10		
wire	proc_col_last	=	fout_proc_col == 54;							//	正在处理当前行的最后一列数据	
wire	proc_col_next_last	=	fout_proc_col == 53;						//	正在处理当前行的倒数第二列数据，增加这个状态的目的是考虑到状态 -> 地址 -> 数据一共有两个时钟的延迟
wire	proc_win_last_row	=	kernel_row_cnt == 10;						//	表明正在处理当前窗口的最后一行数据					
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fout_proc_chnl 	<= 0;
		fout_proc_row 	<= 0;
		fout_proc_col 	<= 0;
		kernel_row_cnt 	<= 0;
		fin_calc_done	<= 0;
	end
	else if (conv0_calc_ing)													//	缓存好了最初的数据
	begin		
		if ((fout_proc_row == 54) && proc_col_last && proc_win_last_row)
		begin
			fin_calc_done <= 1;
			fout_proc_row <= 0;
			fout_proc_chnl 	<= fout_proc_chnl + 1;
		end
		else if (proc_col_last)
		begin
			if (kernel_row_cnt == 10)
			begin
				fout_proc_row <= fout_proc_row + 1;
				kernel_row_cnt <= 0;
			end
			else 
			begin
				fout_proc_row <= fout_proc_row;
				kernel_row_cnt <= kernel_row_cnt + 1;
			end
			fout_proc_chnl 	<= fout_proc_chnl;
			fin_calc_done <= 0;
		end		
		if (proc_col_last || init_buf)			//	好像快了一个时钟
			fout_proc_col 	<= 0;
		else 
			fout_proc_col 	<= fout_proc_col + 1;
	end
end

	
conv0_wgt_par6_o66 U_wgt(
	.clk					(clk														),		//	200M
	.rst_n					(rst_n														),
	
	//	与控制模块的交互信号	
	.new_wgt_fout_chnl		(new_wgt_fout_chnl											),		//	把WEIGHT[i:i+1][:][:][:]看做一个新的权重输出通道，也就是说来新的上升沿之前一定是因为2 * 3 * 11 * 11个权值数据都缓存完毕了
	.fin_calc_done			(fin_calc_done												),		//	当前的fin层数据全部处理完了，也意味着当的wgt[i][:][:][:]和wgt[i+1][:][:][:]处理完毕了
	.init_buf				(init_buf													),
	.conv0_calc_ing       	(conv0_calc_ing       										),
	.fout_proc_chnl			(fout_proc_chnl												),		//	当前正在处理fout_chnl和fout_chnl+1输出特征通道的数据，因为输出通道并行度为2
	.fout_proc_row			(fout_proc_row												),		//	当前正在处理输出特征图的哪一行，有效值是0-54
	.fout_proc_col			(fout_proc_col												),		//	当前正在处理输出特征图的哪一列，有效值是0-54
	.win_proc_row			(kernel_row_cnt												),
	.proc_col_last			(proc_col_last												),		//	正在处理当前行的最后一列数据	
	.proc_col_next_last		(proc_col_next_last											),		//	正在处理当前行的倒数第二列数据，增加这个状态的目的是考虑到状态 -> 地址 -> 数据一共有两个时钟的延迟
	.proc_win_last_row		(proc_win_last_row											),		//	正在处理当前窗口的最后一行
	
	.din_cnt				(din_cnt													),		//	对DDR输入的256bit数据计数，2 * 3 * 11 * 11 = 726，再加66个32'd0凑成总bit数为256bit的整数倍
	.ch_out_buf_cnt			(ch_out_buf_cnt												),		//	缓存了多少个WEIGHT[i][:][:][:]，取值范围是0~31,
		
	//	来自DDR的fin数据	
	.wgt_buf_empty			(wgt_buf_empty												),		
	.wgt_buf_full			(wgt_buf_full												),		//	可以从DDR中接收数据，主要是要考虑新来的数据会不会把还没读出的权重数据给覆盖了
	.from_ddr_fin			(wgt_from_ddr_fin											),		//	虽然DDR最大是100M & 256bit，但是在FPGA中用大一倍的带宽是接收数据
	.din_vld				(wgt_din_vld												),
	
	.vecMac11_wgt_ok		(vecMac11_wgt_ok											),		//	计算所需要的权重数据都准备好了
	.wgt_fout0_fin0_0		(wgt_fout0_fin0_0											),
	.wgt_fout0_fin0_1		(wgt_fout0_fin0_1											),
	.wgt_fout0_fin0_2		(wgt_fout0_fin0_2											),
	.wgt_fout0_fin0_3		(wgt_fout0_fin0_3											),
	.wgt_fout0_fin0_4		(wgt_fout0_fin0_4											),
	.wgt_fout0_fin0_5		(wgt_fout0_fin0_5											),
	.wgt_fout0_fin0_6		(wgt_fout0_fin0_6											),
	.wgt_fout0_fin0_7		(wgt_fout0_fin0_7											),
	.wgt_fout0_fin0_8		(wgt_fout0_fin0_8											),
	.wgt_fout0_fin0_9		(wgt_fout0_fin0_9											),
	.wgt_fout0_fin0_10		(wgt_fout0_fin0_10											),	
	.wgt_fout0_fin1_0		(wgt_fout0_fin1_0											),
	.wgt_fout0_fin1_1		(wgt_fout0_fin1_1											),
	.wgt_fout0_fin1_2		(wgt_fout0_fin1_2											),
	.wgt_fout0_fin1_3		(wgt_fout0_fin1_3											),
	.wgt_fout0_fin1_4		(wgt_fout0_fin1_4											),
	.wgt_fout0_fin1_5		(wgt_fout0_fin1_5											),
	.wgt_fout0_fin1_6		(wgt_fout0_fin1_6											),
	.wgt_fout0_fin1_7		(wgt_fout0_fin1_7											),
	.wgt_fout0_fin1_8		(wgt_fout0_fin1_8											),
	.wgt_fout0_fin1_9		(wgt_fout0_fin1_9											),
	.wgt_fout0_fin1_10		(wgt_fout0_fin1_10											),	
	.wgt_fout0_fin2_0		(wgt_fout0_fin2_0											),
	.wgt_fout0_fin2_1		(wgt_fout0_fin2_1											),
	.wgt_fout0_fin2_2		(wgt_fout0_fin2_2											),
	.wgt_fout0_fin2_3		(wgt_fout0_fin2_3											),
	.wgt_fout0_fin2_4		(wgt_fout0_fin2_4											),
	.wgt_fout0_fin2_5		(wgt_fout0_fin2_5											),
	.wgt_fout0_fin2_6		(wgt_fout0_fin2_6											),
	.wgt_fout0_fin2_7		(wgt_fout0_fin2_7											),
	.wgt_fout0_fin2_8		(wgt_fout0_fin2_8											),
	.wgt_fout0_fin2_9		(wgt_fout0_fin2_9											),
	.wgt_fout0_fin2_10		(wgt_fout0_fin2_10											),	
	.wgt_fout1_fin0_0		(wgt_fout1_fin0_0											),
	.wgt_fout1_fin0_1		(wgt_fout1_fin0_1											),
	.wgt_fout1_fin0_2		(wgt_fout1_fin0_2											),
	.wgt_fout1_fin0_3		(wgt_fout1_fin0_3											),
	.wgt_fout1_fin0_4		(wgt_fout1_fin0_4											),
	.wgt_fout1_fin0_5		(wgt_fout1_fin0_5											),
	.wgt_fout1_fin0_6		(wgt_fout1_fin0_6											),
	.wgt_fout1_fin0_7		(wgt_fout1_fin0_7											),
	.wgt_fout1_fin0_8		(wgt_fout1_fin0_8											),
	.wgt_fout1_fin0_9		(wgt_fout1_fin0_9											),
	.wgt_fout1_fin0_10		(wgt_fout1_fin0_10											),	
	.wgt_fout1_fin1_0		(wgt_fout1_fin1_0											),
	.wgt_fout1_fin1_1		(wgt_fout1_fin1_1											),
	.wgt_fout1_fin1_2		(wgt_fout1_fin1_2											),
	.wgt_fout1_fin1_3		(wgt_fout1_fin1_3											),
	.wgt_fout1_fin1_4		(wgt_fout1_fin1_4											),
	.wgt_fout1_fin1_5		(wgt_fout1_fin1_5											),
	.wgt_fout1_fin1_6		(wgt_fout1_fin1_6											),
	.wgt_fout1_fin1_7		(wgt_fout1_fin1_7											),
	.wgt_fout1_fin1_8		(wgt_fout1_fin1_8											),
	.wgt_fout1_fin1_9		(wgt_fout1_fin1_9											),
	.wgt_fout1_fin1_10		(wgt_fout1_fin1_10											),	
	.wgt_fout1_fin2_0		(wgt_fout1_fin2_0											),
	.wgt_fout1_fin2_1		(wgt_fout1_fin2_1											),
	.wgt_fout1_fin2_2		(wgt_fout1_fin2_2											),
	.wgt_fout1_fin2_3		(wgt_fout1_fin2_3											),
	.wgt_fout1_fin2_4		(wgt_fout1_fin2_4											),
	.wgt_fout1_fin2_5		(wgt_fout1_fin2_5											),
	.wgt_fout1_fin2_6		(wgt_fout1_fin2_6											),
	.wgt_fout1_fin2_7		(wgt_fout1_fin2_7											),
	.wgt_fout1_fin2_8		(wgt_fout1_fin2_8											),
	.wgt_fout1_fin2_9		(wgt_fout1_fin2_9											),
	.wgt_fout1_fin2_10		(wgt_fout1_fin2_10											)
);

conv0_fin_buf_par3_o11 U_fin(
    .clk                  	(clk                  	),
    .rst_n                	(rst_n                	),
    .in_channel           	(in_channel_r          	),
    .new_fin_channel      	(new_fin_channel      	),
    .new_fin_row          	(new_fin_row          	),
    .conv0_calc_ing       	(conv0_calc_ing       	),
    .fin_calc_done        	(fin_calc_done        	),
    .fin_ch0_row_cnt      	(fin_ch0_row_cnt      	),
    .fin_ch1_row_cnt      	(fin_ch1_row_cnt      	),
    .fin_ch2_row_cnt      	(fin_ch2_row_cnt      	),
    .fout_proc_chnl       	(fout_proc_chnl       	),
    .fout_proc_row        	(fout_proc_row        	),
    .fout_proc_col        	(fout_proc_col        	),
    .proc_col_last        	(proc_col_last        	),
    .proc_col_next_last   	(proc_col_next_last   	),
    .proc_win_last_row    	(proc_win_last_row    	),
    .fin_buf_row0_empty   	(fin_buf_row0_empty   	),
    .fin_buf_row0_full    	(fin_buf_row0_full    	),
    .fin_buf_row1_empty   	(fin_buf_row1_empty   	),
    .fin_buf_row1_full    	(fin_buf_row1_full    	),
    .fin_buf_row2_empty   	(fin_buf_row2_empty   	),
    .fin_buf_row2_full    	(fin_buf_row2_full    	),
    .from_ddr_fin         	(from_ddr_fin         	),
    .fin_vld              	(fin_vld              	),
	
	.vecMac11_fin_ok		(vecMac11_fin_ok	),		//	计算所需要的特征图数据都准备好了
	.fin_ch0_0				(fin_ch0_0 			),
	.fin_ch0_1				(fin_ch0_1 			),
	.fin_ch0_2				(fin_ch0_2 			),
	.fin_ch0_3				(fin_ch0_3 			),
	.fin_ch0_4				(fin_ch0_4 			),
	.fin_ch0_5				(fin_ch0_5 			),
	.fin_ch0_6				(fin_ch0_6 			),
	.fin_ch0_7				(fin_ch0_7 			),
	.fin_ch0_8				(fin_ch0_8 			),
	.fin_ch0_9				(fin_ch0_9 			),
	.fin_ch0_10				(fin_ch0_10			),	
	.fin_ch1_0				(fin_ch1_0 			),
	.fin_ch1_1				(fin_ch1_1 			),
	.fin_ch1_2				(fin_ch1_2 			),
	.fin_ch1_3				(fin_ch1_3 			),
	.fin_ch1_4				(fin_ch1_4 			),
	.fin_ch1_5				(fin_ch1_5 			),
	.fin_ch1_6				(fin_ch1_6 			),
	.fin_ch1_7				(fin_ch1_7 			),
	.fin_ch1_8				(fin_ch1_8 			),
	.fin_ch1_9				(fin_ch1_9 			),
	.fin_ch1_10				(fin_ch1_10			),	
	.fin_ch2_0				(fin_ch2_0 			),
	.fin_ch2_1				(fin_ch2_1 			),
	.fin_ch2_2				(fin_ch2_2 			),
	.fin_ch2_3				(fin_ch2_3 			),
	.fin_ch2_4				(fin_ch2_4 			),
	.fin_ch2_5				(fin_ch2_5 			),
	.fin_ch2_6				(fin_ch2_6 			),
	.fin_ch2_7				(fin_ch2_7 			),
	.fin_ch2_8				(fin_ch2_8 			),
	.fin_ch2_9				(fin_ch2_9 			),
	.fin_ch2_10				(fin_ch2_10			)
);

pe_vecMac11_fin3_fout2	u_pe_vecMac11(
    .clk                  	(clk                  	),
    .rst_n                	(rst_n                	),
	
	//	控制接口
	.conv0_calc_ing       	(conv0_calc_ing       	),	
	.proc_fout_chnl			(fout_proc_chnl			),		//	当前正在处理fout_chnl和fout_chnl+1输出特征通道的数据，因为输出通道并行度为2
	.proc_fout_row			(fout_proc_row			),		//	当前正在处理输出特征图的哪一行，有效值是0-54
	.proc_fout_col			(fout_proc_col			),		//	当前正在处理输出特征图的哪一列，有效值是0-54
	.proc_win_row			(kernel_row_cnt			),

	.real_proc_fout_chnl	(real_proc_fout_chnl	),		//	由于数据从输入到输出需要一段时间，因此用这组信号表示输出数据有效时对应的坐标
	.real_proc_fout_row		(real_proc_fout_row		),		//	
	.real_proc_fout_col		(real_proc_fout_col		),		//	
	.real_proc_win_row		(real_proc_win_row		),		//	
			
	
	//	缓存接口
	//.vecMac11_bias_ok		(0),		//	偏置准备好了
	.vecMac11_bias_0		(0),		//	因为输出通道并行度为2，所以这里需要两个偏置数据
	.vecMac11_bias_1		(0),		
	
	//.vecMac11_wgt_ok		(vecMac11_wgt_ok	),		//	计算所需要的权重数据都准备好了
	.wgt_fout0_fin0_0		(wgt_fout0_fin0_0	),
	.wgt_fout0_fin0_1		(wgt_fout0_fin0_1	),
	.wgt_fout0_fin0_2		(wgt_fout0_fin0_2	),
	.wgt_fout0_fin0_3		(wgt_fout0_fin0_3	),
	.wgt_fout0_fin0_4		(wgt_fout0_fin0_4	),
	.wgt_fout0_fin0_5		(wgt_fout0_fin0_5	),
	.wgt_fout0_fin0_6		(wgt_fout0_fin0_6	),
	.wgt_fout0_fin0_7		(wgt_fout0_fin0_7	),
	.wgt_fout0_fin0_8		(wgt_fout0_fin0_8	),
	.wgt_fout0_fin0_9		(wgt_fout0_fin0_9	),
	.wgt_fout0_fin0_10		(wgt_fout0_fin0_10	),	
	.wgt_fout0_fin1_0		(wgt_fout0_fin1_0	),
	.wgt_fout0_fin1_1		(wgt_fout0_fin1_1	),
	.wgt_fout0_fin1_2		(wgt_fout0_fin1_2	),
	.wgt_fout0_fin1_3		(wgt_fout0_fin1_3	),
	.wgt_fout0_fin1_4		(wgt_fout0_fin1_4	),
	.wgt_fout0_fin1_5		(wgt_fout0_fin1_5	),
	.wgt_fout0_fin1_6		(wgt_fout0_fin1_6	),
	.wgt_fout0_fin1_7		(wgt_fout0_fin1_7	),
	.wgt_fout0_fin1_8		(wgt_fout0_fin1_8	),
	.wgt_fout0_fin1_9		(wgt_fout0_fin1_9	),
	.wgt_fout0_fin1_10		(wgt_fout0_fin1_10	),	
	.wgt_fout0_fin2_0		(wgt_fout0_fin2_0	),
	.wgt_fout0_fin2_1		(wgt_fout0_fin2_1	),
	.wgt_fout0_fin2_2		(wgt_fout0_fin2_2	),
	.wgt_fout0_fin2_3		(wgt_fout0_fin2_3	),
	.wgt_fout0_fin2_4		(wgt_fout0_fin2_4	),
	.wgt_fout0_fin2_5		(wgt_fout0_fin2_5	),
	.wgt_fout0_fin2_6		(wgt_fout0_fin2_6	),
	.wgt_fout0_fin2_7		(wgt_fout0_fin2_7	),
	.wgt_fout0_fin2_8		(wgt_fout0_fin2_8	),
	.wgt_fout0_fin2_9		(wgt_fout0_fin2_9	),
	.wgt_fout0_fin2_10		(wgt_fout0_fin2_10	),	
	.wgt_fout1_fin0_0		(wgt_fout1_fin0_0	),
	.wgt_fout1_fin0_1		(wgt_fout1_fin0_1	),
	.wgt_fout1_fin0_2		(wgt_fout1_fin0_2	),
	.wgt_fout1_fin0_3		(wgt_fout1_fin0_3	),
	.wgt_fout1_fin0_4		(wgt_fout1_fin0_4	),
	.wgt_fout1_fin0_5		(wgt_fout1_fin0_5	),
	.wgt_fout1_fin0_6		(wgt_fout1_fin0_6	),
	.wgt_fout1_fin0_7		(wgt_fout1_fin0_7	),
	.wgt_fout1_fin0_8		(wgt_fout1_fin0_8	),
	.wgt_fout1_fin0_9		(wgt_fout1_fin0_9	),
	.wgt_fout1_fin0_10		(wgt_fout1_fin0_10	),	
	.wgt_fout1_fin1_0		(wgt_fout1_fin1_0	),
	.wgt_fout1_fin1_1		(wgt_fout1_fin1_1	),
	.wgt_fout1_fin1_2		(wgt_fout1_fin1_2	),
	.wgt_fout1_fin1_3		(wgt_fout1_fin1_3	),
	.wgt_fout1_fin1_4		(wgt_fout1_fin1_4	),
	.wgt_fout1_fin1_5		(wgt_fout1_fin1_5	),
	.wgt_fout1_fin1_6		(wgt_fout1_fin1_6	),
	.wgt_fout1_fin1_7		(wgt_fout1_fin1_7	),
	.wgt_fout1_fin1_8		(wgt_fout1_fin1_8	),
	.wgt_fout1_fin1_9		(wgt_fout1_fin1_9	),
	.wgt_fout1_fin1_10		(wgt_fout1_fin1_10	),	
	.wgt_fout1_fin2_0		(wgt_fout1_fin2_0	),
	.wgt_fout1_fin2_1		(wgt_fout1_fin2_1	),
	.wgt_fout1_fin2_2		(wgt_fout1_fin2_2	),
	.wgt_fout1_fin2_3		(wgt_fout1_fin2_3	),
	.wgt_fout1_fin2_4		(wgt_fout1_fin2_4	),
	.wgt_fout1_fin2_5		(wgt_fout1_fin2_5	),
	.wgt_fout1_fin2_6		(wgt_fout1_fin2_6	),
	.wgt_fout1_fin2_7		(wgt_fout1_fin2_7	),
	.wgt_fout1_fin2_8		(wgt_fout1_fin2_8	),
	.wgt_fout1_fin2_9		(wgt_fout1_fin2_9	),
	.wgt_fout1_fin2_10		(wgt_fout1_fin2_10	),
	
	//.vecMac11_fin_ok		(vecMac11_fin_ok	),		//	计算所需要的特征图数据都准备好了
	.fin_ch0_0				(fin_ch0_0 			),
	.fin_ch0_1				(fin_ch0_1 			),
	.fin_ch0_2				(fin_ch0_2 			),
	.fin_ch0_3				(fin_ch0_3 			),
	.fin_ch0_4				(fin_ch0_4 			),
	.fin_ch0_5				(fin_ch0_5 			),
	.fin_ch0_6				(fin_ch0_6 			),
	.fin_ch0_7				(fin_ch0_7 			),
	.fin_ch0_8				(fin_ch0_8 			),
	.fin_ch0_9				(fin_ch0_9 			),
	.fin_ch0_10				(fin_ch0_10			),	
	.fin_ch1_0				(fin_ch1_0 			),
	.fin_ch1_1				(fin_ch1_1 			),
	.fin_ch1_2				(fin_ch1_2 			),
	.fin_ch1_3				(fin_ch1_3 			),
	.fin_ch1_4				(fin_ch1_4 			),
	.fin_ch1_5				(fin_ch1_5 			),
	.fin_ch1_6				(fin_ch1_6 			),
	.fin_ch1_7				(fin_ch1_7 			),
	.fin_ch1_8				(fin_ch1_8 			),
	.fin_ch1_9				(fin_ch1_9 			),
	.fin_ch1_10				(fin_ch1_10			),	
	.fin_ch2_0				(fin_ch2_0 			),
	.fin_ch2_1				(fin_ch2_1 			),
	.fin_ch2_2				(fin_ch2_2 			),
	.fin_ch2_3				(fin_ch2_3 			),
	.fin_ch2_4				(fin_ch2_4 			),
	.fin_ch2_5				(fin_ch2_5 			),
	.fin_ch2_6				(fin_ch2_6 			),
	.fin_ch2_7				(fin_ch2_7 			),
	.fin_ch2_8				(fin_ch2_8 			),
	.fin_ch2_9				(fin_ch2_9 			),
	.fin_ch2_10				(fin_ch2_10			)				
);


endmodule