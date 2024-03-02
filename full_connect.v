/*
	时间：			2023.10.31
	功能：			实现vecLen为4的全连接层的实现，注意所有全连接层的代码都用这个
	
	数据类型：		单精度浮点
	版本：			1.0
	
	时序：			① 
	
	功能限制部分：	① 	由于带宽限制，vecLen只能是最大带宽时一个时钟能够读取的数据个数
	
	可改进的方向：	① 
	
	修改：			① 
	
	修改意图：		① 
*/
module full_connect (
	input							clk				,
	input							rst_n			,
	
	//	控制模块
	output							mac_req			,
	input			[11:0]			fin_div4_len	,		//	输入特征图长度除以4
	input							fc_calc_ing		,		//	表明当前正在进行全连接层的计算
	input			[11:0]			proc_fin_idx	,		//	当前正在处理fin[proc_fin_idx:proc_fin_idx+3]的数据
	input			[11:0]			proc_fout_idx	,		//	当前正在处理fout[proc_fout_idx]的数据
	output	reg 	[11:0]			real_fin_idx	,		//	由于处理是存在一点延时的，因此用real_fin_idx指示fc_fout_vld为1时已经处理了fin[real_fin_idx:real_fin_idx+3]的数据
	output	reg 	[11:0]			real_fout_idx	,
	output							real_fin_last	,		//	正在处理当前输出通道的最后一个数据
	//	偏置数据
	//input							fc_bias_ok		,		//	偏置数据准备好了
	input			[31:0]			fc_bias			,
	
	//	输入特征图
	//input							fc_fin_ok		,		//	特征图数据准备好了
	input			[31:0]			fc_fin_0		,
	input			[31:0]			fc_fin_1		,
	input			[31:0]			fc_fin_2		,
	input			[31:0]			fc_fin_3		,	
	
	 //	输入权重数据
	//input							fc_wgt_ok		,		//	权重数据准备好了
	input			[31:0]			fc_wgt_0		,
	input			[31:0]			fc_wgt_1		,
	input			[31:0]			fc_wgt_2		,
	input			[31:0]			fc_wgt_3		,
	
	//	输出特征数据
	output	reg	 	[31:0]			fc_fout			,
	output	reg	 					fc_fout_vld		
);

//	乘法器部分变量
wire 		wgt_req_part,	fin_req_part;
wire [31:0] mul_0;		wire mul_0_vld;
wire [31:0] mul_1;		wire mul_1_vld;
wire [31:0] mul_2;		wire mul_2_vld;
wire [31:0] mul_3;		wire mul_3_vld;
//	 第0级加法器部分
wire add_0_a_0;		wire add_0_b_0;		wire [31:0] add_0_0;		wire add_0_0_vld;
wire add_0_a_1;		wire add_0_b_1;		wire [31:0] add_0_1;		wire add_0_1_vld;
//	 第1级加法器部分
wire add_1_a_0;		wire add_1_b_0;		wire [31:0] add_1_0;		wire add_1_0_vld;
//	 第2级加法器部分
wire add_2_a_rdy;	wire [31:0] add_2_b;	wire [31:0] add_2;		wire add_2_vld;

//	由于是先检测wgt_req_part和fin_req_part都是1之后再给mac_req，因此这里的乘法器结构是合理的
//	乘法器例化部分
assign	mac_req = wgt_req_part && fin_req_part;
mul mul_inst0 (
    .aclk                	(clk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(fc_calc_ing        ),
    .s_axis_a_tready     	(wgt_req_part 		),
    .s_axis_a_tdata      	(fc_wgt_0          	),
    .s_axis_b_tvalid     	(fc_calc_ing        ),
    .s_axis_b_tready     	(fin_req_part 		),
    .s_axis_b_tdata      	(fc_fin_0          	),
    .m_axis_result_tvalid	(mul_0_vld       	),
    .m_axis_result_tready	(add_0_a_0       	),
    .m_axis_result_tdata 	(mul_0           	)
);
mul mul_inst1 (
    .aclk                	(clk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(fc_calc_ing         ),
	
    .s_axis_a_tdata      	(fc_wgt_1          	),
    .s_axis_b_tvalid     	(fc_calc_ing         ),
	
    .s_axis_b_tdata      	(fc_fin_1          	),
    .m_axis_result_tvalid	(mul_1_vld       	),
    .m_axis_result_tready	(add_0_b_0       	),
    .m_axis_result_tdata 	(mul_1           	)
);
mul mul_inst2 (
    .aclk                	(clk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(fc_calc_ing        ),
	
    .s_axis_a_tdata      	(fc_wgt_2          	),
    .s_axis_b_tvalid     	(fc_calc_ing        ),
	
    .s_axis_b_tdata      	(fc_fin_2          	),
    .m_axis_result_tvalid	(mul_2_vld       	),
    .m_axis_result_tready	(add_0_a_1       	),
    .m_axis_result_tdata 	(mul_2           	)
);
mul mul_inst3 (
    .aclk                	(clk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(fc_calc_ing        	),

    .s_axis_a_tdata      	(fc_wgt_3          	),
    .s_axis_b_tvalid     	(fc_calc_ing       	),
	
    .s_axis_b_tdata      	(fc_fin_3           ),
    .m_axis_result_tvalid	(mul_3_vld       	),
    .m_axis_result_tready	(add_0_b_1       	),
    .m_axis_result_tdata 	(mul_3           	)
);

//	第0级加法器部分
add add_0_inst0 	(
    .aclk                	(clk    	   	),
    .aresetn             	(rst_n      	),
    .s_axis_a_tvalid     	(mul_0_vld  	),
    .s_axis_a_tready     	(add_0_a_0  	),
    .s_axis_a_tdata      	(mul_0      	),
    .s_axis_b_tvalid     	(mul_1_vld  	),
    .s_axis_b_tready     	(add_0_b_0  	),
    .s_axis_b_tdata      	(mul_1      	),
    .m_axis_result_tvalid	(add_0_0_vld	),
    .m_axis_result_tready	(add_1_a_0  	),
    .m_axis_result_tdata 	(add_0_0    	)
);
add add_0_inst1 	(
    .aclk                	(clk    	   	),
    .aresetn             	(rst_n      	),
    .s_axis_a_tvalid     	(mul_2_vld  	),
    .s_axis_a_tready     	(add_0_a_1  	),
    .s_axis_a_tdata      	(mul_2      	),
    .s_axis_b_tvalid     	(mul_3_vld  	),
    .s_axis_b_tready     	(add_0_b_1  	),
    .s_axis_b_tdata      	(mul_3      	),
    .m_axis_result_tvalid	(add_0_1_vld	),
    .m_axis_result_tready	(add_1_b_0  	),
    .m_axis_result_tdata 	(add_0_1    	)
);

//	第1级加法器部分
add add_1_inst0 	(
    .aclk                	(clk        	),
    .aresetn             	(rst_n       	),
    .s_axis_a_tvalid     	(add_0_0_vld 	),
    .s_axis_a_tready     	(add_1_a_0   	),
    .s_axis_a_tdata      	(add_0_0     	),
    .s_axis_b_tvalid     	(add_0_1_vld 	),
    .s_axis_b_tready     	(add_1_b_0   	),
    .s_axis_b_tdata      	(add_0_1     	),
    .m_axis_result_tvalid	(add_1_0_vld 	),
    .m_axis_result_tready	(add_2_a_rdy   	),
    .m_axis_result_tdata 	(add_1_0     	)
);

//	第2级加法器部分
assign	add_2_b =	(add_2_vld == 0)	?	fc_bias	:				//	最后一级加法器还没有输出结果之前
					(real_fin_last)	?	fc_bias : add_2;		//	新通道的第一次累加运算
					
add add_2_inst0 	(
    .aclk                	(clk         	),
    .aresetn             	(rst_n        	),
    .s_axis_a_tvalid     	(add_1_0_vld  	),
    .s_axis_a_tready     	(add_2_a_rdy   	),
    .s_axis_a_tdata      	(add_1_0      	),
    .s_axis_b_tvalid     	(1'b1		  	),
    .s_axis_b_tready     	(		    	),
    .s_axis_b_tdata      	(add_2_b      	),
    .m_axis_result_tvalid	(add_2_vld  	),
    .m_axis_result_tready	(1'b1	    	),
    .m_axis_result_tdata 	(add_2      	)
);

//	对最后一级加法器输出的缓存，同时生成一些关键指示信号
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		real_fout_idx <= 12'd0;
		real_fin_idx <= 12'd0;
	end
	else if (real_fin_last && add_2_vld)			//	假如当前输出通道的最后一个数据处理完了
	begin
		real_fout_idx <= real_fout_idx + 12'd1;
		real_fin_idx <= 12'd0;
	end
	else if (add_2_vld)
	begin
		real_fout_idx <= real_fout_idx;
		real_fin_idx <= real_fin_idx + 12'd1;
	end
end

//	输出当前通道的特征图数据
assign	real_fin_last = real_fin_idx == (fin_div4_len - 12'd1);

always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fc_fout <= 32'd0;
		fc_fout_vld <= 1'd0;
	end
	else if (real_fin_last && add_2_vld)
	begin
		fc_fout <= add_2;
		fc_fout_vld <= 1'd1;
	end
	else
	begin
		fc_fout <= fc_fout;
		fc_fout_vld <= 1'd0;
	end
end

endmodule