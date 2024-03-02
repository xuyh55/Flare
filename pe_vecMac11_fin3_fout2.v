/*
	时间：			2023.10.22
	功能：			实现输出并行度为2输入并行度为3的处理阵列
	
	数据类型：		单精度浮点
	版本：			1.0
	
	时序：			① (fin_req && wgt_req) -> (vecMac11_wgt_ok && vecMac11_fin_ok && vecMac11_bias_ok) -> conv0_calc_ing
	
	功能限制部分：	① 	
	
	可改进的方向：	① 
	
	修改：			① 
	
	修改意图：		① 
*/
module pe_vecMac11_fin3_fout2 (
	input						clk				,
	input						rst_n			,
	
	//	控制接口
	input							conv0_calc_ing			,		//	表明此时正在计算过程中		
	input	 	 [5:0]				proc_fout_chnl			,		//	当前正在处理fout_chnl和fout_chnl+1输出特征通道的数据,因为输出通道并行度为2
	input	 	 [5:0]				proc_fout_row			,		//	当前正在处理输出特征图的哪一行,有效值是0~54
	input	 	 [5:0]				proc_fout_col			,		//	当前正在处理输出特征图的哪一列,有效值是0~54
	input		 [3:0]				proc_win_row			,		//	当前正在处理卷积窗的哪一行
	
	output	reg	 [5:0]				real_proc_fout_chnl		,		//	由于数据从输入到输出需要一段时间，因此用这组信号表示输出数据有效时对应的坐标
	output	reg  [5:0]				real_proc_fout_row		,		//	
	output	reg	 [5:0]				real_proc_fout_col		,		//	
	output	reg	 [3:0]				real_proc_win_row		,		//	
	
	output							real_proc_col_last 	    ,		//	根据mac_done生成实际的处理坐标指示信号
	output                          real_proc_win_row_last  ,		
	output                          real_proc_row_last 	    ,		
	
	//	缓存接口
	//input							vecMac11_bias_ok		,		//	偏置准备好了
	input			[31:0]			vecMac11_bias_0			,		//	因为输出通道并行度为2，所以这里需要两个偏置数据
	input			[31:0]			vecMac11_bias_1			,		
	
	//input		 					vecMac11_wgt_ok			,		//	计算所需要的权重数据都准备好了
	input			[31:0]			wgt_fout0_fin0_0		,
	input			[31:0]			wgt_fout0_fin0_1		,
	input			[31:0]			wgt_fout0_fin0_2		,
	input			[31:0]			wgt_fout0_fin0_3		,
	input			[31:0]			wgt_fout0_fin0_4		,
	input			[31:0]			wgt_fout0_fin0_5		,
	input			[31:0]			wgt_fout0_fin0_6		,
	input	   		[31:0]			wgt_fout0_fin0_7		,
	input	  		[31:0]			wgt_fout0_fin0_8		,
	input	  		[31:0]			wgt_fout0_fin0_9		,
	input	  		[31:0]			wgt_fout0_fin0_10		,
	
	input	    	[31:0]			wgt_fout0_fin1_0		,
	input	    	[31:0]			wgt_fout0_fin1_1		,
	input	    	[31:0]			wgt_fout0_fin1_2		,
	input	    	[31:0]			wgt_fout0_fin1_3		,
	input	    	[31:0]			wgt_fout0_fin1_4		,
	input	    	[31:0]			wgt_fout0_fin1_5		,
	input	    	[31:0]			wgt_fout0_fin1_6		,
	input	    	[31:0]			wgt_fout0_fin1_7		,
	input	    	[31:0]			wgt_fout0_fin1_8		,
	input	    	[31:0]			wgt_fout0_fin1_9		,
	input	    	[31:0]			wgt_fout0_fin1_10		,
	
	input	    	[31:0]			wgt_fout0_fin2_0		,
	input	    	[31:0]			wgt_fout0_fin2_1		,
	input	    	[31:0]			wgt_fout0_fin2_2		,
	input	    	[31:0]			wgt_fout0_fin2_3		,
	input	    	[31:0]			wgt_fout0_fin2_4		,
	input	    	[31:0]			wgt_fout0_fin2_5		,
	input	    	[31:0]			wgt_fout0_fin2_6		,
	input			[31:0]			wgt_fout0_fin2_7		,
	input			[31:0]			wgt_fout0_fin2_8		,
	input			[31:0]			wgt_fout0_fin2_9		,
	input			[31:0]			wgt_fout0_fin2_10		,
	
	input			[31:0]			wgt_fout1_fin0_0		,
	input			[31:0]			wgt_fout1_fin0_1		,
	input			[31:0]			wgt_fout1_fin0_2		,
	input			[31:0]			wgt_fout1_fin0_3		,
	input			[31:0]			wgt_fout1_fin0_4		,
	input			[31:0]			wgt_fout1_fin0_5		,
	input			[31:0]			wgt_fout1_fin0_6		,
	input	   		[31:0]			wgt_fout1_fin0_7		,
	input	  		[31:0]			wgt_fout1_fin0_8		,
	input	  		[31:0]			wgt_fout1_fin0_9		,
	input	  		[31:0]			wgt_fout1_fin0_10		,
	
	input	    	[31:0]			wgt_fout1_fin1_0		,
	input	    	[31:0]			wgt_fout1_fin1_1		,
	input	    	[31:0]			wgt_fout1_fin1_2		,
	input	    	[31:0]			wgt_fout1_fin1_3		,
	input	    	[31:0]			wgt_fout1_fin1_4		,
	input	    	[31:0]			wgt_fout1_fin1_5		,
	input	    	[31:0]			wgt_fout1_fin1_6		,
	input	    	[31:0]			wgt_fout1_fin1_7		,
	input	    	[31:0]			wgt_fout1_fin1_8		,
	input	    	[31:0]			wgt_fout1_fin1_9		,
	input	    	[31:0]			wgt_fout1_fin1_10		,
	
	input	    	[31:0]			wgt_fout1_fin2_0		,
	input	    	[31:0]			wgt_fout1_fin2_1		,
	input	    	[31:0]			wgt_fout1_fin2_2		,
	input	    	[31:0]			wgt_fout1_fin2_3		,
	input	    	[31:0]			wgt_fout1_fin2_4		,
	input	    	[31:0]			wgt_fout1_fin2_5		,
	input	    	[31:0]			wgt_fout1_fin2_6		,
	input	  		[31:0]			wgt_fout1_fin2_7		,
	input	  		[31:0]			wgt_fout1_fin2_8		,
	input	  		[31:0]			wgt_fout1_fin2_9		,
	input	  		[31:0]			wgt_fout1_fin2_10		,
	
	//input							vecMac11_fin_ok			,		//	计算所需要的特征图数据都准备好了
	input			[31:0]			fin_ch0_0				,
	input			[31:0]			fin_ch0_1				,
	input			[31:0]			fin_ch0_2				,
	input			[31:0]			fin_ch0_3				,
	input			[31:0]			fin_ch0_4				,
	input			[31:0]			fin_ch0_5				,
	input			[31:0]			fin_ch0_6				,
	input			[31:0]			fin_ch0_7				,
	input			[31:0]			fin_ch0_8				,
	input			[31:0]			fin_ch0_9				,
	input			[31:0]			fin_ch0_10				,
	
	input			[31:0]			fin_ch1_0				,
	input			[31:0]			fin_ch1_1				,
	input			[31:0]			fin_ch1_2				,
	input			[31:0]			fin_ch1_3				,
	input			[31:0]			fin_ch1_4				,
	input			[31:0]			fin_ch1_5				,
	input			[31:0]			fin_ch1_6				,
	input			[31:0]			fin_ch1_7				,
	input			[31:0]			fin_ch1_8				,
	input			[31:0]			fin_ch1_9				,
	input			[31:0]			fin_ch1_10				,
	
	input			[31:0]			fin_ch2_0				,
	input			[31:0]			fin_ch2_1				,
	input			[31:0]			fin_ch2_2				,
	input			[31:0]			fin_ch2_3				,
	input			[31:0]			fin_ch2_4				,
	input			[31:0]			fin_ch2_5				,
	input			[31:0]			fin_ch2_6				,
	input			[31:0]			fin_ch2_7				,
	input			[31:0]			fin_ch2_8				,
	input			[31:0]			fin_ch2_9				,
	input			[31:0]			fin_ch2_10				,
	
	output	reg 					fout_ch_vld				,	//	每次输出两个通道的数据
	output	reg		[31:0]			fout_ch0				,		
	output	reg		[31:0]			fout_ch1						
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

wire				mac_req 				;	//	开始vecMac11的计算
wire				fin_req 				;
wire				wgt_req 				;	//	vecMac11需要权重数据
wire				mac_done				;	//	vecMac11计算结束

wire	        	fout_ch0_empty  		;	//	输出通道0的fifo缓存
wire	        	fout_ch0_full   		;
wire 	        	fout_ch_rd	     		;
wire	[31:0]  	fout_ch0_dout   		;

wire	        	fout_ch1_empty  		;	//	输出通道1的fifo缓存
wire	        	fout_ch1_full   		;
//wire 	        	fout_ch1_rd     		;	
wire	[31:0]  	fout_ch1_dout   		;

//	如果vecMac11可以开始计算了，就把数据准备好的标志作为计算请求
assign	mac_req = (fin_req && wgt_req)	?	conv0_calc_ing	:	1'b0;

//	wgt[0][0][0][:] .* fin[0][0][0:10]
wire [31:0]	dout_pe_fout0_fin0;
vecMac11 pe_fout0_fin0(
	.aclk		(clk					),
	.rst_n		(rst_n					),
			
	.mac_req	(mac_req    			),
	.fin_req	(fin_req				),
	.wgt_req	(wgt_req				),
	.mac_done	(mac_done				),
		
	.fin_0		(fin_ch0_0			),
	.fin_1		(fin_ch0_1			),
	.fin_2		(fin_ch0_2			),
	.fin_3		(fin_ch0_3			),
	.fin_4		(fin_ch0_4			),
	.fin_5		(fin_ch0_5			),
	.fin_6		(fin_ch0_6			),
	.fin_7		(fin_ch0_7			),
	.fin_8		(fin_ch0_8			),
	.fin_9		(fin_ch0_9			),
	.fin_10		(fin_ch0_10			),

	.wgt_0		(wgt_fout0_fin0_0		),
	.wgt_1		(wgt_fout0_fin0_1		),
	.wgt_2		(wgt_fout0_fin0_2		),
	.wgt_3		(wgt_fout0_fin0_3		),
	.wgt_4		(wgt_fout0_fin0_4		),
	.wgt_5		(wgt_fout0_fin0_5		),
	.wgt_6		(wgt_fout0_fin0_6		),
	.wgt_7		(wgt_fout0_fin0_7		),
	.wgt_8		(wgt_fout0_fin0_8		),
	.wgt_9		(wgt_fout0_fin0_9		),
	.wgt_10		(wgt_fout0_fin0_10		),

	.mac_data	(dout_pe_fout0_fin0		)
);

//	wgt[0][1][0][:] .* fin[1][0][0:10]
wire [31:0]	dout_pe_fout0_fin1;
vecMac11 pe_fout0_fin1(
	.aclk		(clk					),
	.rst_n		(rst_n					),
			
	.mac_req	(mac_req    			),
		
	.fin_0		(fin_ch1_0			),
	.fin_1		(fin_ch1_1			),
	.fin_2		(fin_ch1_2			),
	.fin_3		(fin_ch1_3			),
	.fin_4		(fin_ch1_4			),
	.fin_5		(fin_ch1_5			),
	.fin_6		(fin_ch1_6			),
	.fin_7		(fin_ch1_7			),
	.fin_8		(fin_ch1_8			),
	.fin_9		(fin_ch1_9			),
	.fin_10		(fin_ch1_10			),

	.wgt_0		(wgt_fout0_fin1_0		),
	.wgt_1		(wgt_fout0_fin1_1		),
	.wgt_2		(wgt_fout0_fin1_2		),
	.wgt_3		(wgt_fout0_fin1_3		),
	.wgt_4		(wgt_fout0_fin1_4		),
	.wgt_5		(wgt_fout0_fin1_5		),
	.wgt_6		(wgt_fout0_fin1_6		),
	.wgt_7		(wgt_fout0_fin1_7		),
	.wgt_8		(wgt_fout0_fin1_8		),
	.wgt_9		(wgt_fout0_fin1_9		),
	.wgt_10		(wgt_fout0_fin1_10		),

	.mac_data	(dout_pe_fout0_fin1		)
);

//	wgt[0][2][0][:] .* fin[2][0][0:10]
wire [31:0]	dout_pe_fout0_fin2;
vecMac11 pe_fout0_fin2(
	.aclk		(clk					),
	.rst_n		(rst_n					),
			
	.mac_req	(mac_req    			),
		
	.fin_0		(fin_ch2_0			),
	.fin_1		(fin_ch2_1			),
	.fin_2		(fin_ch2_2			),
	.fin_3		(fin_ch2_3			),
	.fin_4		(fin_ch2_4			),
	.fin_5		(fin_ch2_5			),
	.fin_6		(fin_ch2_6			),
	.fin_7		(fin_ch2_7			),
	.fin_8		(fin_ch2_8			),
	.fin_9		(fin_ch2_9			),
	.fin_10		(fin_ch2_10			),

	.wgt_0		(wgt_fout0_fin2_0		),
	.wgt_1		(wgt_fout0_fin2_1		),
	.wgt_2		(wgt_fout0_fin2_2		),
	.wgt_3		(wgt_fout0_fin2_3		),
	.wgt_4		(wgt_fout0_fin2_4		),
	.wgt_5		(wgt_fout0_fin2_5		),
	.wgt_6		(wgt_fout0_fin2_6		),
	.wgt_7		(wgt_fout0_fin2_7		),
	.wgt_8		(wgt_fout0_fin2_8		),
	.wgt_9		(wgt_fout0_fin2_9		),
	.wgt_10		(wgt_fout0_fin2_10		),

	.mac_data	(dout_pe_fout0_fin2		)
);

//	wgt[1][0][0][:] .* fin[0][0][0:10]
wire [31:0]	dout_pe_fout1_fin0;
vecMac11 pe_fout1_fin0(
	.aclk		(clk					),
	.rst_n		(rst_n					),
			
	.mac_req	(mac_req    			),
	
	.fin_0		(fin_ch0_0			),
	.fin_1		(fin_ch0_1			),
	.fin_2		(fin_ch0_2			),
	.fin_3		(fin_ch0_3			),
	.fin_4		(fin_ch0_4			),
	.fin_5		(fin_ch0_5			),
	.fin_6		(fin_ch0_6			),
	.fin_7		(fin_ch0_7			),
	.fin_8		(fin_ch0_8			),
	.fin_9		(fin_ch0_9			),
	.fin_10		(fin_ch0_10			),

	.wgt_0		(wgt_fout1_fin0_0		),
	.wgt_1		(wgt_fout1_fin0_1		),
	.wgt_2		(wgt_fout1_fin0_2		),
	.wgt_3		(wgt_fout1_fin0_3		),
	.wgt_4		(wgt_fout1_fin0_4		),
	.wgt_5		(wgt_fout1_fin0_5		),
	.wgt_6		(wgt_fout1_fin0_6		),
	.wgt_7		(wgt_fout1_fin0_7		),
	.wgt_8		(wgt_fout1_fin0_8		),
	.wgt_9		(wgt_fout1_fin0_9		),
	.wgt_10		(wgt_fout1_fin0_10		),

	.mac_data	(dout_pe_fout1_fin0		)
);

//	wgt[1][1][0][:] .* fin[1][0][0:10]
wire [31:0]	dout_pe_fout1_fin1;
vecMac11 pe_fout1_fin1(
	.aclk		(clk					),
	.rst_n		(rst_n					),
			
	.mac_req	(mac_req    			),
		
	.fin_0		(fin_ch1_0			),
	.fin_1		(fin_ch1_1			),
	.fin_2		(fin_ch1_2			),
	.fin_3		(fin_ch1_3			),
	.fin_4		(fin_ch1_4			),
	.fin_5		(fin_ch1_5			),
	.fin_6		(fin_ch1_6			),
	.fin_7		(fin_ch1_7			),
	.fin_8		(fin_ch1_8			),
	.fin_9		(fin_ch1_9			),
	.fin_10		(fin_ch1_10			),

	.wgt_0		(wgt_fout1_fin1_0		),
	.wgt_1		(wgt_fout1_fin1_1		),
	.wgt_2		(wgt_fout1_fin1_2		),
	.wgt_3		(wgt_fout1_fin1_3		),
	.wgt_4		(wgt_fout1_fin1_4		),
	.wgt_5		(wgt_fout1_fin1_5		),
	.wgt_6		(wgt_fout1_fin1_6		),
	.wgt_7		(wgt_fout1_fin1_7		),
	.wgt_8		(wgt_fout1_fin1_8		),
	.wgt_9		(wgt_fout1_fin1_9		),
	.wgt_10		(wgt_fout1_fin1_10		),

	.mac_data	(dout_pe_fout1_fin1		)
);

//	wgt[1][2][0][:] .* fin[2][0][0:10]
wire [31:0]	dout_pe_fout1_fin2;
vecMac11 pe_fout1_fin2(
	.aclk		(clk					),
	.rst_n		(rst_n					),
			
	.mac_req	(mac_req    			),
		
	.fin_0		(fin_ch2_0			),
	.fin_1		(fin_ch2_1			),
	.fin_2		(fin_ch2_2			),
	.fin_3		(fin_ch2_3			),
	.fin_4		(fin_ch2_4			),
	.fin_5		(fin_ch2_5			),
	.fin_6		(fin_ch2_6			),
	.fin_7		(fin_ch2_7			),
	.fin_8		(fin_ch2_8			),
	.fin_9		(fin_ch2_9			),
	.fin_10		(fin_ch2_10			),

	.wgt_0		(wgt_fout1_fin2_0		),
	.wgt_1		(wgt_fout1_fin2_1		),
	.wgt_2		(wgt_fout1_fin2_2		),
	.wgt_3		(wgt_fout1_fin2_3		),
	.wgt_4		(wgt_fout1_fin2_4		),
	.wgt_5		(wgt_fout1_fin2_5		),
	.wgt_6		(wgt_fout1_fin2_6		),
	.wgt_7		(wgt_fout1_fin2_7		),
	.wgt_8		(wgt_fout1_fin2_8		),
	.wgt_9		(wgt_fout1_fin2_9		),
	.wgt_10		(wgt_fout1_fin2_10		),

	.mac_data	(dout_pe_fout1_fin2		)
);

//	由于并行度是3 * 2，因此还需要额外的6个加法器
//	输出通道0的处理部分
wire [31:0]		fout0_add_0;				//	通道0输出值的加法结果第一部分
wire  			fout0_add_0_vld;
add add_inst0 	(
    .aclk                	(clk  	     			),
    .aresetn             	(rst_n      			),
    .s_axis_a_tvalid     	(mac_done	  			),
    .s_axis_a_tready     	(			  			),
    .s_axis_a_tdata      	(dout_pe_fout0_fin0    	),
    .s_axis_b_tvalid     	(mac_done	  			),
    .s_axis_b_tready     	(			  			),
    .s_axis_b_tdata      	(dout_pe_fout0_fin1    	),
    .m_axis_result_tvalid	(fout0_add_0_vld		),
    .m_axis_result_tready	(1'b1				  	),
    .m_axis_result_tdata 	(fout0_add_0  			)
);

reg [31:0]		dout_pe_fout0_fin2_r;		//	需要对dout_pe_fout0_fin2打一拍
reg 			dout_pe_fout0_fin2_r_vld;
wire [31:0]		fout0_add_1;				//	通道0输出值的加法结果第二部分
wire  			fout0_add_1_vld;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		dout_pe_fout0_fin2_r <= 32'd0;
		dout_pe_fout0_fin2_r_vld <= 1'b0;
	end
	else
	begin
		dout_pe_fout0_fin2_r <= dout_pe_fout0_fin2;
		dout_pe_fout0_fin2_r_vld <= mac_done;
	end
end
add add_inst1 	(
    .aclk                	(clk	       				),
    .aresetn             	(rst_n      				),
    .s_axis_a_tvalid     	(fout0_add_0_vld			),
    .s_axis_a_tready     	(			  				),
    .s_axis_a_tdata      	(fout0_add_0	    		),
    .s_axis_b_tvalid     	(dout_pe_fout0_fin2_r_vld	),
    .s_axis_b_tready     	(			  				),
    .s_axis_b_tdata      	(dout_pe_fout0_fin2_r    	),
    .m_axis_result_tvalid	(fout0_add_1_vld			),
    .m_axis_result_tready	(1'b1					  	),
    .m_axis_result_tdata 	(fout0_add_1	  			)
);

wire [31:0]		adder2_a;
wire [31:0]		fout0_add_2;				//	通道0输出值的加法结果最后部分
wire  			fout0_add_2_vld;
assign	adder2_a = (real_proc_win_row == 0) && (real_proc_fout_col <= 6'd53)	?	vecMac11_bias_0	:	fout_ch0_dout;	//	如果是窗口的第一行，表明需要偏置参与计算
add add_inst2 	(
    .aclk                	(clk	       				),
    .aresetn             	(rst_n      				),
    .s_axis_a_tvalid     	(fout0_add_1_vld			),
    .s_axis_a_tready     	(			  				),
    .s_axis_a_tdata      	(adder2_a		    		),
    .s_axis_b_tvalid     	(fout0_add_1_vld			),
    .s_axis_b_tready     	(			  				),
    .s_axis_b_tdata      	(fout0_add_1		    	),
    .m_axis_result_tvalid	(fout0_add_2_vld			),
    .m_axis_result_tready	(1'b1					  	),
    .m_axis_result_tdata 	(fout0_add_2	  			)
);

//	fifo的作用是对最后一级加法器的输出进行缓存，因为real_proc_win_row在0~10之间的数据需要累加
assign	fout_ch_rd = (real_proc_win_row > 0) || (real_proc_fout_col == 6'd53) || real_proc_col_last;		//	很明显1~10行需要从fifo中读数据，后一个条件则是让地址提两个时钟准备好，因为一个时钟生成地址，一个时钟拿到数据
fifo_dw32_dp64 fout_fifo_ch0 (
    .clk  	(clk            	),
    .rst  	(!rst_n         	),
    .din  	(fout0_add_2    	),
    .wr_en	(fout0_add_2_vld	),
    .rd_en	(fout_ch_rd	    	),
    .dout 	(fout_ch0_dout  	),
    .full 	(fout_ch0_full  	),
    .empty	(fout_ch0_empty 	)
);

//	输出通道1的处理部分
wire [31:0]		fout1_add_3;				//	通道1输出值的加法结果第一部分
wire  			fout1_add_3_vld;
add add_inst3 	(
    .aclk                	(clk  	     			),
    .aresetn             	(rst_n      			),
    .s_axis_a_tvalid     	(mac_done	  			),
    .s_axis_a_tready     	(			  			),
    .s_axis_a_tdata      	(dout_pe_fout1_fin0    	),
    .s_axis_b_tvalid     	(mac_done	  			),
    .s_axis_b_tready     	(			  			),
    .s_axis_b_tdata      	(dout_pe_fout1_fin1    	),
    .m_axis_result_tvalid	(fout1_add_3_vld		),
    .m_axis_result_tready	(1'b1				  	),
    .m_axis_result_tdata 	(fout1_add_3 			)
);

reg [31:0]		dout_pe_fout1_fin2_r;		//	需要对dout_pe_fout1_fin2打一拍
reg 			dout_pe_fout1_fin2_r_vld;
wire [31:0]		fout1_add_4;				//	通道1输出值的加法结果第二部分
wire  			fout1_add_4_vld;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		dout_pe_fout1_fin2_r <= 32'd0;
		dout_pe_fout1_fin2_r_vld <= 1'b0;
	end
	else
	begin
		dout_pe_fout1_fin2_r <= dout_pe_fout1_fin2;
		dout_pe_fout1_fin2_r_vld <= mac_done;
	end
end
add add_inst4 	(
    .aclk                	(clk	       				),
    .aresetn             	(rst_n      				),
    .s_axis_a_tvalid     	(fout1_add_3_vld			),
    .s_axis_a_tready     	(			  				),
    .s_axis_a_tdata      	(fout1_add_3	    		),
    .s_axis_b_tvalid     	(dout_pe_fout1_fin2_r_vld	),
    .s_axis_b_tready     	(			  				),
    .s_axis_b_tdata      	(dout_pe_fout1_fin2_r    	),
    .m_axis_result_tvalid	(fout1_add_4_vld			),
    .m_axis_result_tready	(1'b1					  	),
    .m_axis_result_tdata 	(fout1_add_4	  			)
);

wire [31:0]		adder5_a;
wire [31:0]		fout1_add_5;				//	通道1输出值的加法结果最后部分
wire  			fout1_add_5_vld;
assign	adder5_a = (real_proc_win_row == 0) && (real_proc_fout_col <= 6'd53)	?	vecMac11_bias_1	:	fout_ch1_dout;	//	如果是窗口的第一行，表明需要偏置参与计算
add add_inst5 	(
    .aclk                	(clk	       				),
    .aresetn             	(rst_n      				),
    .s_axis_a_tvalid     	(fout1_add_4_vld			),
    .s_axis_a_tready     	(			  				),
    .s_axis_a_tdata      	(adder5_a		    		),
    .s_axis_b_tvalid     	(fout1_add_4_vld			),
    .s_axis_b_tready     	(			  				),
    .s_axis_b_tdata      	(fout1_add_4		    	),
    .m_axis_result_tvalid	(fout1_add_5_vld			),
    .m_axis_result_tready	(1'b1					  	),
    .m_axis_result_tdata 	(fout1_add_5	  			)
);

//	fifo的作用是对最后一级加法器的输出进行缓存，因为real_proc_win_row在0~10之间的数据需要累加
fifo_dw32_dp64 fout_fifo_ch1 (
    .clk  	(clk            	),
    .rst  	(!rst_n         	),
    .din  	(fout1_add_5    	),
    .wr_en	(fout1_add_5_vld	),
    .rd_en	(fout_ch_rd    		),
    .dout 	(fout_ch1_dout  	),
    .full 	(fout_ch1_full  	),
    .empty	(fout_ch1_empty 	)
);	

//	根据最后一级加法器的有效信号生成实际的处理坐标
assign real_proc_col_last 	= real_proc_fout_col == CONV0_OW - 1;
assign real_proc_win_row_last = real_proc_win_row == CONV0_KH - 1;
assign real_proc_row_last 	= real_proc_fout_row == CONV0_OH - 1;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		real_proc_fout_chnl	<= 6'd0;
		real_proc_fout_row	<= 6'd0;			
		real_proc_win_row	<= 4'd0;
		real_proc_fout_col	<= 6'd0;
	end
	else if (fout1_add_5_vld)														//	理论上fout1_add_2_vld和fout0_add_2_vld应该是完全同步的，如果不是这样的话代码会出错
	begin
		if (real_proc_row_last && real_proc_win_row_last && real_proc_col_last)		//	如果是在处理输出通道的最后一行且最后一个数据，那么下一个数据通道肯定要加1，而且行计数清零
		begin
			real_proc_fout_chnl	<= real_proc_fout_chnl + 6'd1;
			real_proc_fout_row	<= 6'd0;			
			real_proc_win_row	<= 4'd0;
			real_proc_fout_col	<= 6'd0;
		end
		else if (real_proc_win_row_last && real_proc_col_last)						//	如果是在卷积窗的最后一行且最后一个数据，那么下一行卷积窗肯定是第一行开始,而且输出通道的行要加1
		begin
			real_proc_fout_chnl	<= real_proc_fout_chnl;
			real_proc_fout_row	<= real_proc_fout_row + 6'd1;
			real_proc_win_row <= 4'd0;
			real_proc_fout_col <= 6'd0;
		end
		else if (real_proc_col_last)												//	如果处理到某一行的最后一个数，那么下一个数肯定是从0开始
		begin
			real_proc_fout_chnl	<= real_proc_fout_chnl;
			real_proc_fout_row	<= real_proc_fout_row;			
			real_proc_win_row <= real_proc_win_row + 4'd1;
			real_proc_fout_col <= 6'd0;
		end
		else 
		begin
			real_proc_fout_chnl	<= real_proc_fout_chnl;
			real_proc_fout_row	<= real_proc_fout_row;			
			real_proc_win_row <= real_proc_win_row;
			real_proc_fout_col <= real_proc_fout_col + 6'd1;
		end
	end
end

//	拿到激活层之后的处理结果
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fout_ch_vld		<= 1'd0;
		fout_ch0		<= 32'd0;
		fout_ch1		<= 32'd0;
	end
	else if (real_proc_win_row_last && fout1_add_5_vld)	//	如果在窗口的最后一行，那么说明可以输出数据了
	begin
		fout_ch_vld	<= 1'd1;
		if (fout0_add_2[31])							//	relu激活
			fout_ch0 <= 32'd0;
		else
			fout_ch0 <= fout0_add_2;
		if (fout1_add_5[31])
			fout_ch1 <= 32'd0;
		else 
			fout_ch1 <= fout1_add_5;
	end
end

endmodule