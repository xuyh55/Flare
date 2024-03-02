module tb_fc ();

reg							clk				;
reg							rst_n			;

reg			[11:0]			fin_div4_len	;
reg							fc_calc_ing		;

wire 		[11:0]			real_fin_idx	;
wire	 	[11:0]			real_fout_idx	;
wire						real_fin_last	;

reg			[31:0]			bias_buf		;
wire		[31:0]			fc_fin_0		;
wire		[31:0]			fc_fin_1		;
wire		[31:0]			fc_fin_2		;
wire		[31:0]			fc_fin_3		;
wire		[31:0]			fc_wgt_0		;
wire		[31:0]			fc_wgt_1		;
wire		[31:0]			fc_wgt_2		;
wire		[31:0]			fc_wgt_3		;

wire	 	 [31:0]			fc_fout			;
wire	 	 				fc_fout_vld		;
wire						mac_req			;
reg	[31:0]	cnt;
reg 		flag;
reg [255:0]	fin_buf;
reg [255:0]	wgt_buf;
												
reg	[255:0]	fc_bias [511:0];				//	4096个偏置数据		512*8=4096 									
reg	[255:0]	fc_fin  [1151:0];				//	9216个特征图数据	1152*8=9216		
//reg	[255:0]	fc_wgt	[4718591:0];			//	4096*9216个权值数据	4,718,592 * 8 = 4096*9216		
reg	[255:0]	fc_wgt	[11520-1:0];			//	4096*9216个权值数据	4,718,592 * 8 = 4096*9216		
												
initial
begin
	$readmemh("C:/Users/11787/Desktop/jupyter_lab/fc1_bias.txt", fc_bias);
	$readmemh("C:/Users/11787/Desktop/jupyter_lab/fc1_weight.txt", fc_wgt);
	$readmemh("C:/Users/11787/Desktop/jupyter_lab/conv10_mp_fout.txt", fc_fin);
	
/* 	$readmemh("/home/xuyh/Desktop/alexnet/tb/fc1_bias.txt", fc_bias);
	$readmemh("/home/xuyh/Desktop/alexnet/tb/fc1_weight.txt", fc_wgt);
	$readmemh("/home/xuyh/Desktop/alexnet/tb/conv10_mp_fout.txt", fc_fin);	 */
	
	clk = 0;
	rst_n = 0;
	
	cnt = 0;
	fin_div4_len = 2304;
	flag = 0;
	fc_calc_ing = 0;
	fin_buf = 0;
	wgt_buf = 0;
	bias_buf = 0;
	#123
	rst_n = 1;
	
	wait((real_fout_idx == 4095) && real_fin_last);		
	
	#1000
	$stop();
end

always #2.5 clk = ~clk;

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		cnt = 0;
		flag = 0;
		fin_buf = 0;
		wgt_buf = 0;
		bias_buf = 0;
		fc_calc_ing = 0;
	end
	else if (fc_calc_ing)
	begin
		if (flag)
		begin
			cnt <= cnt + 1;
			wgt_buf <= fc_wgt[cnt];
			fin_buf <= fc_fin[cnt%1152];
			bias_buf <= fc_bias[cnt/9216][((cnt%9216) / 1152) * 32 +: 32];
			flag <= 0;
			fc_calc_ing <= 1;
		end
		else 
		begin
			flag <= 1;
		end
	end
	else
	begin
		cnt <= 1;
		wgt_buf <= fc_wgt[0];
		fin_buf <= fc_fin[0];
		bias_buf <= fc_bias[0][31:0];
		flag <= 0;
		fc_calc_ing <= mac_req;
	end
end
assign	{fc_fin_3,fc_fin_2,fc_fin_1,fc_fin_0} = (flag == 0)	?	fin_buf [32*4 - 1 : 0]	:	fin_buf [32*8 - 1 : 32*4];
assign	{fc_wgt_3,fc_wgt_2,fc_wgt_1,fc_wgt_0} = (flag == 0)	?	wgt_buf [32*4 - 1 : 0]	:	wgt_buf [32*8 - 1 : 32*4];


full_connect u0(
	.clk					(clk						),		//	200M
	.rst_n					(rst_n						),
	
	.mac_req				(mac_req					),
	.fin_div4_len			(fin_div4_len				),		//	输入特征图长度除以4
	.fc_calc_ing			(fc_calc_ing				),		//	表明当前正在进行全连接层的计算
	.real_fin_idx			(real_fin_idx				),		//	由于处理是存在一点延时的，因此用real_fin_idx指示fc_fout_vld为1时已经处理了fin[real_fin_idx:real_fin_idx+3]的数据
	.real_fout_idx			(real_fout_idx				),
	.real_fin_last			(real_fin_last				),		//	正在处理当前输出通道的最后一个数据
	
	.fc_bias				(bias_buf					),
	
	.fc_fin_0				(fc_fin_0					),
	.fc_fin_1				(fc_fin_1					),
	.fc_fin_2				(fc_fin_2					),
	.fc_fin_3				(fc_fin_3					),	
	
	.fc_wgt_0				(fc_wgt_0					),
	.fc_wgt_1				(fc_wgt_1					),
	.fc_wgt_2				(fc_wgt_2					),
	.fc_wgt_3				(fc_wgt_3					),
	
	.fc_fout				(fc_fout					),
	.fc_fout_vld			(fc_fout_vld				)
);
												
endmodule                                       