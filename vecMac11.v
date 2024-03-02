/*
	时间：			2023.6.05
	功能：			实现长度11的向量点积
	数据类型：		单精度浮点
	版本：			1.0
	
	时序：			① fin_req && wgt_req -> mac_req，支持ii = 1的流水线 
	
	功能限制部分：	① 要求mac_req为1时所有的fin_x和wgt_x都是有效的，换言之，只有权重和特征有效时才能给mac请求
					② 当rst_n为0，至少fin_x或者wgt_x中的一组为0
	
	可改进的方向：	① 
	
	修改：			① 
	
	
	修改意图：		① 
*/
module vecMac11	(
	input   	    	        	aclk    	,
	input   	    	        	rst_n   	,
	
	input   	    	        	mac_req 	,
	output  	    	        	fin_req 	,
	output  	    	        	wgt_req 	,
	output  	reg 	        	mac_done	,
	
	input   	    	[31:0]  	fin_0   	,
	input   	    	[31:0]  	fin_1   	,
	input   	    	[31:0]  	fin_2   	,
	input   	    	[31:0]  	fin_3   	,
	input   	    	[31:0]  	fin_4   	,
	input   	    	[31:0]  	fin_5   	,
	input   	    	[31:0]  	fin_6   	,
	input   	    	[31:0]  	fin_7   	,
	input   	    	[31:0]  	fin_8   	,
	input   	    	[31:0]  	fin_9   	,
	input   	    	[31:0]  	fin_10  	,
	
	input   	    	[31:0]  	wgt_0   	,
	input   	    	[31:0]  	wgt_1   	,
	input   	    	[31:0]  	wgt_2   	,
	input   	    	[31:0]  	wgt_3   	,
	input   	    	[31:0]  	wgt_4   	,
	input   	    	[31:0]  	wgt_5   	,
	input   	    	[31:0]  	wgt_6   	,
	input   	    	[31:0]  	wgt_7   	,
	input   	    	[31:0]  	wgt_8   	,
	input   	    	[31:0]  	wgt_9   	,
	input   	    	[31:0]  	wgt_10  	,
	
	output  	reg 	[31:0]  	mac_data	
);

//	乘法器部分
wire [10:0] wgt_req_part;		wire [10:0] fin_req_part;	

wire [31:0] mul_0;		wire mul_0_vld;
wire [31:0] mul_1;		wire mul_1_vld;
wire [31:0] mul_2;		wire mul_2_vld;
wire [31:0] mul_3;		wire mul_3_vld;
wire [31:0] mul_4;		wire mul_4_vld;
wire [31:0] mul_5;		wire mul_5_vld;
wire [31:0] mul_6;		wire mul_6_vld;
wire [31:0] mul_7;		wire mul_7_vld;
wire [31:0] mul_8;		wire mul_8_vld;
wire [31:0] mul_9;		wire mul_9_vld;
wire [31:0] mul_10;		wire mul_10_vld;

//	 第0级加法器部分
wire add_0_a_0;		wire add_0_b_0;		wire [31:0] add_0_0;		wire add_0_0_vld;
wire add_0_a_1;		wire add_0_b_1;		wire [31:0] add_0_1;		wire add_0_1_vld;
wire add_0_a_2;		wire add_0_b_2;		wire [31:0] add_0_2;		wire add_0_2_vld;
wire add_0_a_3;		wire add_0_b_3;		wire [31:0] add_0_3;		wire add_0_3_vld;
wire add_0_a_4;		wire add_0_b_4;		wire [31:0] add_0_4;		wire add_0_4_vld;

//	 第1级加法器部分
wire add_1_a_0;		wire add_1_b_0;		wire [31:0] add_1_0;		wire add_1_0_vld;
wire add_1_a_1;		wire add_1_b_1;		wire [31:0] add_1_1;		wire add_1_1_vld;
wire add_1_a_2;		wire add_1_b_2;		wire [31:0] add_1_2;		wire add_1_2_vld;
//	 第2级加法器部分
wire add_2_a_0;		wire add_2_b_0;		wire [31:0] add_2_0;		wire add_2_0_vld;
//	 第3级加法器部分
wire add_3_a_0;		wire add_3_b_0;		wire [31:0] add_3_0;		wire add_3_0_vld;


//	由于是先检测wgt_req_part和fin_req_part都是1之后再给mac_req，因此这里的乘法器结构是合理的
//	乘法器例化部分
mul mul_inst0 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[0] 	),
    .s_axis_a_tdata      	(wgt_0           	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[0] 	),
    .s_axis_b_tdata      	(fin_0           	),
    .m_axis_result_tvalid	(mul_0_vld       	),
    .m_axis_result_tready	(add_0_a_0       	),
    .m_axis_result_tdata 	(mul_0           	)
);
mul mul_inst1 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[1] 	),
    .s_axis_a_tdata      	(wgt_1           	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[1] 	),
    .s_axis_b_tdata      	(fin_1           	),
    .m_axis_result_tvalid	(mul_1_vld       	),
    .m_axis_result_tready	(add_0_b_0       	),
    .m_axis_result_tdata 	(mul_1           	)
);
mul mul_inst2 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[2] 	),
    .s_axis_a_tdata      	(wgt_2           	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[2] 	),
    .s_axis_b_tdata      	(fin_2           	),
    .m_axis_result_tvalid	(mul_2_vld       	),
    .m_axis_result_tready	(add_0_a_1       	),
    .m_axis_result_tdata 	(mul_2           	)
);
mul mul_inst3 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[3] 	),
    .s_axis_a_tdata      	(wgt_3           	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[3] 	),
    .s_axis_b_tdata      	(fin_3           	),
    .m_axis_result_tvalid	(mul_3_vld       	),
    .m_axis_result_tready	(add_0_b_1       	),
    .m_axis_result_tdata 	(mul_3           	)
);
mul mul_inst4 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[4] 	),
    .s_axis_a_tdata      	(wgt_4           	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[4] 	),
    .s_axis_b_tdata      	(fin_4           	),
    .m_axis_result_tvalid	(mul_4_vld       	),
    .m_axis_result_tready	(add_0_a_2       	),
    .m_axis_result_tdata 	(mul_4           	)
);
mul mul_inst5 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[5] 	),
    .s_axis_a_tdata      	(wgt_5           	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[5] 	),
    .s_axis_b_tdata      	(fin_5           	),
    .m_axis_result_tvalid	(mul_5_vld       	),
    .m_axis_result_tready	(add_0_b_2       	),
    .m_axis_result_tdata 	(mul_5           	)
);
mul mul_inst6 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[6] 	),
    .s_axis_a_tdata      	(wgt_6           	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[6] 	),
    .s_axis_b_tdata      	(fin_6           	),
    .m_axis_result_tvalid	(mul_6_vld       	),
    .m_axis_result_tready	(add_0_a_3       	),
    .m_axis_result_tdata 	(mul_6           	)
);
mul mul_inst7 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[7] 	),
    .s_axis_a_tdata      	(wgt_7           	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[7] 	),
    .s_axis_b_tdata      	(fin_7           	),
    .m_axis_result_tvalid	(mul_7_vld       	),
    .m_axis_result_tready	(add_0_b_3       	),
    .m_axis_result_tdata 	(mul_7           	)
);
mul mul_inst8 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[8] 	),
    .s_axis_a_tdata      	(wgt_8           	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[8] 	),
    .s_axis_b_tdata      	(fin_8           	),
    .m_axis_result_tvalid	(mul_8_vld       	),
    .m_axis_result_tready	(add_0_a_4       	),
    .m_axis_result_tdata 	(mul_8           	)
);
mul mul_inst9 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[9] 	),
    .s_axis_a_tdata      	(wgt_9           	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[9] 	),
    .s_axis_b_tdata      	(fin_9           	),
    .m_axis_result_tvalid	(mul_9_vld       	),
    .m_axis_result_tready	(add_0_b_4       	),
    .m_axis_result_tdata 	(mul_9           	)
);
mul mul_inst10 (
    .aclk                	(aclk            	),
    .aresetn             	(rst_n           	),
    .s_axis_a_tvalid     	(mac_req         	),
    .s_axis_a_tready     	(wgt_req_part[10]	),
    .s_axis_a_tdata      	(wgt_10          	),
    .s_axis_b_tvalid     	(mac_req         	),
    .s_axis_b_tready     	(fin_req_part[10]	),
    .s_axis_b_tdata      	(fin_10          	),
    .m_axis_result_tvalid	(mul_10_vld      	),
    .m_axis_result_tready	(add_1_b_2       	),
    .m_axis_result_tdata 	(mul_10          	)
);

assign wgt_req = &wgt_req_part;
assign fin_req = &fin_req_part;

//	打一拍
reg [31:0]	mul_10_r;
reg  		mul_10_vld_r;
always @(posedge aclk or negedge rst_n)
begin
	if (!rst_n)
	begin
		mul_10_r <= 32'd0;
		mul_10_vld_r <= 1'b0;
	end
	else 
	begin
		mul_10_r <= mul_10;
		mul_10_vld_r <= mul_10_vld;
	end
end

//	第0级加法器部分
add add_0_inst0 	(
    .aclk                	(aclk       	),
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
    .aclk                	(aclk       	),
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
add add_0_inst2 	(
    .aclk                	(aclk       	),
    .aresetn             	(rst_n      	),
    .s_axis_a_tvalid     	(mul_4_vld  	),
    .s_axis_a_tready     	(add_0_a_2  	),
    .s_axis_a_tdata      	(mul_4      	),
    .s_axis_b_tvalid     	(mul_5_vld  	),
    .s_axis_b_tready     	(add_0_b_2  	),
    .s_axis_b_tdata      	(mul_5      	),
    .m_axis_result_tvalid	(add_0_2_vld	),
    .m_axis_result_tready	(add_1_a_1  	),
    .m_axis_result_tdata 	(add_0_2    	)
);
add add_0_inst3 	(
    .aclk                	(aclk       	),
    .aresetn             	(rst_n      	),
    .s_axis_a_tvalid     	(mul_6_vld  	),
    .s_axis_a_tready     	(add_0_a_3  	),
    .s_axis_a_tdata      	(mul_6      	),
    .s_axis_b_tvalid     	(mul_7_vld  	),
    .s_axis_b_tready     	(add_0_b_3  	),
    .s_axis_b_tdata      	(mul_7      	),
    .m_axis_result_tvalid	(add_0_3_vld	),
    .m_axis_result_tready	(add_1_b_1  	),
    .m_axis_result_tdata 	(add_0_3    	)
);
add add_0_inst4 	(
    .aclk                	(aclk       	),
    .aresetn             	(rst_n      	),
    .s_axis_a_tvalid     	(mul_8_vld  	),
    .s_axis_a_tready     	(add_0_a_4  	),
    .s_axis_a_tdata      	(mul_8      	),
    .s_axis_b_tvalid     	(mul_9_vld  	),
    .s_axis_b_tready     	(add_0_b_4  	),
    .s_axis_b_tdata      	(mul_9      	),
    .m_axis_result_tvalid	(add_0_4_vld	),
    .m_axis_result_tready	(add_1_a_2  	),
    .m_axis_result_tdata 	(add_0_4    	)
);

//	第1级加法器部分
add add_1_inst0 	(
    .aclk                	(aclk        	),
    .aresetn             	(rst_n       	),
    .s_axis_a_tvalid     	(add_0_0_vld 	),
    .s_axis_a_tready     	(add_1_a_0   	),
    .s_axis_a_tdata      	(add_0_0     	),
    .s_axis_b_tvalid     	(add_0_1_vld 	),
    .s_axis_b_tready     	(add_1_b_0   	),
    .s_axis_b_tdata      	(add_0_1     	),
    .m_axis_result_tvalid	(add_1_0_vld 	),
    .m_axis_result_tready	(add_2_a_0   	),
    .m_axis_result_tdata 	(add_1_0     	)
);
add add_1_inst1 	(
    .aclk                	(aclk        	),
    .aresetn             	(rst_n       	),
    .s_axis_a_tvalid     	(add_0_2_vld 	),
    .s_axis_a_tready     	(add_1_a_1   	),
    .s_axis_a_tdata      	(add_0_2     	),
    .s_axis_b_tvalid     	(add_0_3_vld 	),
    .s_axis_b_tready     	(add_1_b_1   	),
    .s_axis_b_tdata      	(add_0_3     	),
    .m_axis_result_tvalid	(add_1_1_vld 	),
    .m_axis_result_tready	(add_2_b_0   	),
    .m_axis_result_tdata 	(add_1_1     	)
);
add add_1_inst2 	(
    .aclk                	(aclk        	),
    .aresetn             	(rst_n       	),
    .s_axis_a_tvalid     	(add_0_4_vld 	),
    .s_axis_a_tready     	(add_1_a_2   	),
    .s_axis_a_tdata      	(add_0_4     	),
    .s_axis_b_tvalid     	(mul_10_vld_r	),
    .s_axis_b_tready     	(add_1_b_2   	),
    .s_axis_b_tdata      	(mul_10_r    	),
    .m_axis_result_tvalid	(add_1_2_vld 	),
    .m_axis_result_tready	(add_3_b_0   	),
    .m_axis_result_tdata 	(add_1_2     	)
);

//	打一拍
reg [31:0]	add_1_2_r;
reg  		add_1_2_vld_r;
always @(posedge aclk or negedge rst_n)
begin
	if (!rst_n)
	begin
		add_1_2_r <= 32'd0;
		add_1_2_vld_r <= 1'b0;
	end
	else 
	begin
		add_1_2_r <= add_1_2;
		add_1_2_vld_r <= add_1_2_vld;
	end
end

//	第2级加法器部分
add add_2_inst0 	(
    .aclk                	(aclk         	),
    .aresetn             	(rst_n        	),
    .s_axis_a_tvalid     	(add_1_0_vld  	),
    .s_axis_a_tready     	(add_2_a_0    	),
    .s_axis_a_tdata      	(add_1_0      	),
    .s_axis_b_tvalid     	(add_1_1_vld  	),
    .s_axis_b_tready     	(add_2_b_0    	),
    .s_axis_b_tdata      	(add_1_1      	),
    .m_axis_result_tvalid	(add_2_0_vld  	),
    .m_axis_result_tready	(add_3_a_0    	),
    .m_axis_result_tdata 	(add_2_0      	)
);


//	第3级加法器部分
add add_3_inst0 	(
    .aclk                	(aclk         	),
    .aresetn             	(rst_n        	),
    .s_axis_a_tvalid     	(add_2_0_vld  	),
    .s_axis_a_tready     	(add_3_a_0    	),
    .s_axis_a_tdata      	(add_2_0      	),
    .s_axis_b_tvalid     	(add_1_2_vld_r	),
    .s_axis_b_tready     	(add_3_b_0    	),
    .s_axis_b_tdata      	(add_1_2_r    	),
    .m_axis_result_tvalid	(add_3_0_vld  	),
    .m_axis_result_tready	(1'b1         	),
    .m_axis_result_tdata 	(add_3_0      	)
);
always @(posedge aclk or negedge rst_n)
begin
    if (!rst_n)
    begin
        mac_done <= 1'b0;
        mac_data <= 32'd0;
    end
    else
    begin
        mac_done <= add_3_0_vld;
        mac_data <= add_3_0;
    end
end

endmodule