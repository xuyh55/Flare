/*
	ʱ�䣺			2023.10.22
	���ܣ�			ʵ��������ж�Ϊ2���벢�ж�Ϊ3�Ĵ�������
	
	�������ͣ�		�����ȸ���
	�汾��			1.0
	
	ʱ��			�� (fin_req && wgt_req) -> (vecMac11_wgt_ok && vecMac11_fin_ok && vecMac11_bias_ok) -> conv0_calc_ing
	
	�������Ʋ��֣�	�� 	
	
	�ɸĽ��ķ���	�� 
	
	�޸ģ�			�� 
	
	�޸���ͼ��		�� 
*/
module pe_vecMac11_fin3_fout2 (
	input						clk				,
	input						rst_n			,
	
	//	���ƽӿ�
	input							conv0_calc_ing			,		//	������ʱ���ڼ��������		
	input	 	 [5:0]				proc_fout_chnl			,		//	��ǰ���ڴ���fout_chnl��fout_chnl+1�������ͨ��������,��Ϊ���ͨ�����ж�Ϊ2
	input	 	 [5:0]				proc_fout_row			,		//	��ǰ���ڴ����������ͼ����һ��,��Чֵ��0~54
	input	 	 [5:0]				proc_fout_col			,		//	��ǰ���ڴ����������ͼ����һ��,��Чֵ��0~54
	input		 [3:0]				proc_win_row			,		//	��ǰ���ڴ�����������һ��
	
	output	reg	 [5:0]				real_proc_fout_chnl		,		//	�������ݴ����뵽�����Ҫһ��ʱ�䣬����������źű�ʾ���������Чʱ��Ӧ������
	output	reg  [5:0]				real_proc_fout_row		,		//	
	output	reg	 [5:0]				real_proc_fout_col		,		//	
	output	reg	 [3:0]				real_proc_win_row		,		//	
	
	output							real_proc_col_last 	    ,		//	����mac_done����ʵ�ʵĴ�������ָʾ�ź�
	output                          real_proc_win_row_last  ,		
	output                          real_proc_row_last 	    ,		
	
	//	����ӿ�
	//input							vecMac11_bias_ok		,		//	ƫ��׼������
	input			[31:0]			vecMac11_bias_0			,		//	��Ϊ���ͨ�����ж�Ϊ2������������Ҫ����ƫ������
	input			[31:0]			vecMac11_bias_1			,		
	
	//input		 					vecMac11_wgt_ok			,		//	��������Ҫ��Ȩ�����ݶ�׼������
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
	
	//input							vecMac11_fin_ok			,		//	��������Ҫ������ͼ���ݶ�׼������
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
	
	output	reg 					fout_ch_vld				,	//	ÿ���������ͨ��������
	output	reg		[31:0]			fout_ch0				,		
	output	reg		[31:0]			fout_ch1						
);

//	��Щ����������Էŵ�VH�ļ���
localparam	CONV0_STRIDE	= 	4	;
localparam	CONV0_KH		=	11	;
localparam	CONV0_KW		=	11	;
localparam	CONV0_IH		=	227	;
localparam	CONV0_IW		=	227	;
localparam	CONV0_IC		=	3	;
localparam	CONV0_OH		=	55	;
localparam	CONV0_OW		=	55	;
localparam	CONV0_OC		=	64	;
localparam 	CONV0_FIN_PAR	=	3	;			//	����ͨ�����ж�Ϊ3
localparam 	CONV0_FOUT_PAR	=	2	;			//	���ͨ�����ж�Ϊ3

wire				mac_req 				;	//	��ʼvecMac11�ļ���
wire				fin_req 				;
wire				wgt_req 				;	//	vecMac11��ҪȨ������
wire				mac_done				;	//	vecMac11�������

wire	        	fout_ch0_empty  		;	//	���ͨ��0��fifo����
wire	        	fout_ch0_full   		;
wire 	        	fout_ch_rd	     		;
wire	[31:0]  	fout_ch0_dout   		;

wire	        	fout_ch1_empty  		;	//	���ͨ��1��fifo����
wire	        	fout_ch1_full   		;
//wire 	        	fout_ch1_rd     		;	
wire	[31:0]  	fout_ch1_dout   		;

//	���vecMac11���Կ�ʼ�����ˣ��Ͱ�����׼���õı�־��Ϊ��������
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

//	���ڲ��ж���3 * 2����˻���Ҫ�����6���ӷ���
//	���ͨ��0�Ĵ�����
wire [31:0]		fout0_add_0;				//	ͨ��0���ֵ�ļӷ������һ����
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

reg [31:0]		dout_pe_fout0_fin2_r;		//	��Ҫ��dout_pe_fout0_fin2��һ��
reg 			dout_pe_fout0_fin2_r_vld;
wire [31:0]		fout0_add_1;				//	ͨ��0���ֵ�ļӷ�����ڶ�����
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
wire [31:0]		fout0_add_2;				//	ͨ��0���ֵ�ļӷ������󲿷�
wire  			fout0_add_2_vld;
assign	adder2_a = (real_proc_win_row == 0) && (real_proc_fout_col <= 6'd53)	?	vecMac11_bias_0	:	fout_ch0_dout;	//	����Ǵ��ڵĵ�һ�У�������Ҫƫ�ò������
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

//	fifo�������Ƕ����һ���ӷ�����������л��棬��Ϊreal_proc_win_row��0~10֮���������Ҫ�ۼ�
assign	fout_ch_rd = (real_proc_win_row > 0) || (real_proc_fout_col == 6'd53) || real_proc_col_last;		//	������1~10����Ҫ��fifo�ж����ݣ���һ�����������õ�ַ������ʱ��׼���ã���Ϊһ��ʱ�����ɵ�ַ��һ��ʱ���õ�����
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

//	���ͨ��1�Ĵ�����
wire [31:0]		fout1_add_3;				//	ͨ��1���ֵ�ļӷ������һ����
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

reg [31:0]		dout_pe_fout1_fin2_r;		//	��Ҫ��dout_pe_fout1_fin2��һ��
reg 			dout_pe_fout1_fin2_r_vld;
wire [31:0]		fout1_add_4;				//	ͨ��1���ֵ�ļӷ�����ڶ�����
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
wire [31:0]		fout1_add_5;				//	ͨ��1���ֵ�ļӷ������󲿷�
wire  			fout1_add_5_vld;
assign	adder5_a = (real_proc_win_row == 0) && (real_proc_fout_col <= 6'd53)	?	vecMac11_bias_1	:	fout_ch1_dout;	//	����Ǵ��ڵĵ�һ�У�������Ҫƫ�ò������
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

//	fifo�������Ƕ����һ���ӷ�����������л��棬��Ϊreal_proc_win_row��0~10֮���������Ҫ�ۼ�
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

//	�������һ���ӷ�������Ч�ź�����ʵ�ʵĴ�������
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
	else if (fout1_add_5_vld)														//	������fout1_add_2_vld��fout0_add_2_vldӦ������ȫͬ���ģ�������������Ļ���������
	begin
		if (real_proc_row_last && real_proc_win_row_last && real_proc_col_last)		//	������ڴ������ͨ�������һ�������һ�����ݣ���ô��һ������ͨ���϶�Ҫ��1�������м�������
		begin
			real_proc_fout_chnl	<= real_proc_fout_chnl + 6'd1;
			real_proc_fout_row	<= 6'd0;			
			real_proc_win_row	<= 4'd0;
			real_proc_fout_col	<= 6'd0;
		end
		else if (real_proc_win_row_last && real_proc_col_last)						//	������ھ���������һ�������һ�����ݣ���ô��һ�о�����϶��ǵ�һ�п�ʼ,�������ͨ������Ҫ��1
		begin
			real_proc_fout_chnl	<= real_proc_fout_chnl;
			real_proc_fout_row	<= real_proc_fout_row + 6'd1;
			real_proc_win_row <= 4'd0;
			real_proc_fout_col <= 6'd0;
		end
		else if (real_proc_col_last)												//	�������ĳһ�е����һ��������ô��һ�����϶��Ǵ�0��ʼ
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

//	�õ������֮��Ĵ�����
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		fout_ch_vld		<= 1'd0;
		fout_ch0		<= 32'd0;
		fout_ch1		<= 32'd0;
	end
	else if (real_proc_win_row_last && fout1_add_5_vld)	//	����ڴ��ڵ����һ�У���ô˵���������������
	begin
		fout_ch_vld	<= 1'd1;
		if (fout0_add_2[31])							//	relu����
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