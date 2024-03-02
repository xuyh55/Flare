
/*
	时间：			2023.10.05
	功能：			实现长度为61的向量点乘
	
	数据类型：		单精度浮点
	版本：			1.0
	
	时序：			① 200MHz时钟
	
	功能限制部分：	① 	
	
	可改进的方向：	① 
	
	修改：			① 
	
	修改意图：		① 
*/

module vecMac61	(
	input								aclk		,
	input								rst_n		,

	input								mac_req		,
	output								fin_req		,
	output								wgt_req		,
	output reg							mac_done	,

	input		[31:0]					fin_0		,
	input		[31:0]					fin_1		,
	input		[31:0]					fin_2		,
	input		[31:0]					fin_3		,
	input		[31:0]					fin_4		,
	input		[31:0]					fin_5		,
	input		[31:0]					fin_6		,
	input		[31:0]					fin_7		,
	input		[31:0]					fin_8		,
	input		[31:0]					fin_9		,
	input		[31:0]					fin_10		,
	input		[31:0]					fin_11		,
	input		[31:0]					fin_12		,
	input		[31:0]					fin_13		,
	input		[31:0]					fin_14		,
	input		[31:0]					fin_15		,
	input		[31:0]					fin_16		,
	input		[31:0]					fin_17		,
	input		[31:0]					fin_18		,
	input		[31:0]					fin_19		,
	input		[31:0]					fin_20		,
	input		[31:0]					fin_21		,
	input		[31:0]					fin_22		,
	input		[31:0]					fin_23		,
	input		[31:0]					fin_24		,
	input		[31:0]					fin_25		,
	input		[31:0]					fin_26		,
	input		[31:0]					fin_27		,
	input		[31:0]					fin_28		,
	input		[31:0]					fin_29		,
	input		[31:0]					fin_30		,
	input		[31:0]					fin_31		,
	input		[31:0]					fin_32		,
	input		[31:0]					fin_33		,
	input		[31:0]					fin_34		,
	input		[31:0]					fin_35		,
	input		[31:0]					fin_36		,
	input		[31:0]					fin_37		,
	input		[31:0]					fin_38		,
	input		[31:0]					fin_39		,
	input		[31:0]					fin_40		,
	input		[31:0]					fin_41		,
	input		[31:0]					fin_42		,
	input		[31:0]					fin_43		,
	input		[31:0]					fin_44		,
	input		[31:0]					fin_45		,
	input		[31:0]					fin_46		,
	input		[31:0]					fin_47		,
	input		[31:0]					fin_48		,
	input		[31:0]					fin_49		,
	input		[31:0]					fin_50		,
	input		[31:0]					fin_51		,
	input		[31:0]					fin_52		,
	input		[31:0]					fin_53		,
	input		[31:0]					fin_54		,
	input		[31:0]					fin_55		,
	input		[31:0]					fin_56		,
	input		[31:0]					fin_57		,
	input		[31:0]					fin_58		,
	input		[31:0]					fin_59		,
	input		[31:0]					fin_60		,

	input		[31:0]					wgt_0		,
	input		[31:0]					wgt_1		,
	input		[31:0]					wgt_2		,
	input		[31:0]					wgt_3		,
	input		[31:0]					wgt_4		,
	input		[31:0]					wgt_5		,
	input		[31:0]					wgt_6		,
	input		[31:0]					wgt_7		,
	input		[31:0]					wgt_8		,
	input		[31:0]					wgt_9		,
	input		[31:0]					wgt_10		,
	input		[31:0]					wgt_11		,
	input		[31:0]					wgt_12		,
	input		[31:0]					wgt_13		,
	input		[31:0]					wgt_14		,
	input		[31:0]					wgt_15		,
	input		[31:0]					wgt_16		,
	input		[31:0]					wgt_17		,
	input		[31:0]					wgt_18		,
	input		[31:0]					wgt_19		,
	input		[31:0]					wgt_20		,
	input		[31:0]					wgt_21		,
	input		[31:0]					wgt_22		,
	input		[31:0]					wgt_23		,
	input		[31:0]					wgt_24		,
	input		[31:0]					wgt_25		,
	input		[31:0]					wgt_26		,
	input		[31:0]					wgt_27		,
	input		[31:0]					wgt_28		,
	input		[31:0]					wgt_29		,
	input		[31:0]					wgt_30		,
	input		[31:0]					wgt_31		,
	input		[31:0]					wgt_32		,
	input		[31:0]					wgt_33		,
	input		[31:0]					wgt_34		,
	input		[31:0]					wgt_35		,
	input		[31:0]					wgt_36		,
	input		[31:0]					wgt_37		,
	input		[31:0]					wgt_38		,
	input		[31:0]					wgt_39		,
	input		[31:0]					wgt_40		,
	input		[31:0]					wgt_41		,
	input		[31:0]					wgt_42		,
	input		[31:0]					wgt_43		,
	input		[31:0]					wgt_44		,
	input		[31:0]					wgt_45		,
	input		[31:0]					wgt_46		,
	input		[31:0]					wgt_47		,
	input		[31:0]					wgt_48		,
	input		[31:0]					wgt_49		,
	input		[31:0]					wgt_50		,
	input		[31:0]					wgt_51		,
	input		[31:0]					wgt_52		,
	input		[31:0]					wgt_53		,
	input		[31:0]					wgt_54		,
	input		[31:0]					wgt_55		,
	input		[31:0]					wgt_56		,
	input		[31:0]					wgt_57		,
	input		[31:0]					wgt_58		,
	input		[31:0]					wgt_59		,
	input		[31:0]					wgt_60		,

	output	reg	[31:0]					mac_data		
);

//	乘法器部分
wire [60:0] wgt_req_part;		wire [60:0] fin_req_part;	
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
wire [31:0] mul_11;		wire mul_11_vld;
wire [31:0] mul_12;		wire mul_12_vld;
wire [31:0] mul_13;		wire mul_13_vld;
wire [31:0] mul_14;		wire mul_14_vld;
wire [31:0] mul_15;		wire mul_15_vld;
wire [31:0] mul_16;		wire mul_16_vld;
wire [31:0] mul_17;		wire mul_17_vld;
wire [31:0] mul_18;		wire mul_18_vld;
wire [31:0] mul_19;		wire mul_19_vld;
wire [31:0] mul_20;		wire mul_20_vld;
wire [31:0] mul_21;		wire mul_21_vld;
wire [31:0] mul_22;		wire mul_22_vld;
wire [31:0] mul_23;		wire mul_23_vld;
wire [31:0] mul_24;		wire mul_24_vld;
wire [31:0] mul_25;		wire mul_25_vld;
wire [31:0] mul_26;		wire mul_26_vld;
wire [31:0] mul_27;		wire mul_27_vld;
wire [31:0] mul_28;		wire mul_28_vld;
wire [31:0] mul_29;		wire mul_29_vld;
wire [31:0] mul_30;		wire mul_30_vld;
wire [31:0] mul_31;		wire mul_31_vld;
wire [31:0] mul_32;		wire mul_32_vld;
wire [31:0] mul_33;		wire mul_33_vld;
wire [31:0] mul_34;		wire mul_34_vld;
wire [31:0] mul_35;		wire mul_35_vld;
wire [31:0] mul_36;		wire mul_36_vld;
wire [31:0] mul_37;		wire mul_37_vld;
wire [31:0] mul_38;		wire mul_38_vld;
wire [31:0] mul_39;		wire mul_39_vld;
wire [31:0] mul_40;		wire mul_40_vld;
wire [31:0] mul_41;		wire mul_41_vld;
wire [31:0] mul_42;		wire mul_42_vld;
wire [31:0] mul_43;		wire mul_43_vld;
wire [31:0] mul_44;		wire mul_44_vld;
wire [31:0] mul_45;		wire mul_45_vld;
wire [31:0] mul_46;		wire mul_46_vld;
wire [31:0] mul_47;		wire mul_47_vld;
wire [31:0] mul_48;		wire mul_48_vld;
wire [31:0] mul_49;		wire mul_49_vld;
wire [31:0] mul_50;		wire mul_50_vld;
wire [31:0] mul_51;		wire mul_51_vld;
wire [31:0] mul_52;		wire mul_52_vld;
wire [31:0] mul_53;		wire mul_53_vld;
wire [31:0] mul_54;		wire mul_54_vld;
wire [31:0] mul_55;		wire mul_55_vld;
wire [31:0] mul_56;		wire mul_56_vld;
wire [31:0] mul_57;		wire mul_57_vld;
wire [31:0] mul_58;		wire mul_58_vld;
wire [31:0] mul_59;		wire mul_59_vld;
wire [31:0] mul_60;		wire mul_60_vld;
//	 第0级加法器部分
wire add_0_a_0;		wire add_0_b_0;		wire [31:0] add_0_0;		wire add_0_0_vld;
wire add_0_a_1;		wire add_0_b_1;		wire [31:0] add_0_1;		wire add_0_1_vld;
wire add_0_a_2;		wire add_0_b_2;		wire [31:0] add_0_2;		wire add_0_2_vld;
wire add_0_a_3;		wire add_0_b_3;		wire [31:0] add_0_3;		wire add_0_3_vld;
wire add_0_a_4;		wire add_0_b_4;		wire [31:0] add_0_4;		wire add_0_4_vld;
wire add_0_a_5;		wire add_0_b_5;		wire [31:0] add_0_5;		wire add_0_5_vld;
wire add_0_a_6;		wire add_0_b_6;		wire [31:0] add_0_6;		wire add_0_6_vld;
wire add_0_a_7;		wire add_0_b_7;		wire [31:0] add_0_7;		wire add_0_7_vld;
wire add_0_a_8;		wire add_0_b_8;		wire [31:0] add_0_8;		wire add_0_8_vld;
wire add_0_a_9;		wire add_0_b_9;		wire [31:0] add_0_9;		wire add_0_9_vld;
wire add_0_a_10;		wire add_0_b_10;		wire [31:0] add_0_10;		wire add_0_10_vld;
wire add_0_a_11;		wire add_0_b_11;		wire [31:0] add_0_11;		wire add_0_11_vld;
wire add_0_a_12;		wire add_0_b_12;		wire [31:0] add_0_12;		wire add_0_12_vld;
wire add_0_a_13;		wire add_0_b_13;		wire [31:0] add_0_13;		wire add_0_13_vld;
wire add_0_a_14;		wire add_0_b_14;		wire [31:0] add_0_14;		wire add_0_14_vld;
wire add_0_a_15;		wire add_0_b_15;		wire [31:0] add_0_15;		wire add_0_15_vld;
wire add_0_a_16;		wire add_0_b_16;		wire [31:0] add_0_16;		wire add_0_16_vld;
wire add_0_a_17;		wire add_0_b_17;		wire [31:0] add_0_17;		wire add_0_17_vld;
wire add_0_a_18;		wire add_0_b_18;		wire [31:0] add_0_18;		wire add_0_18_vld;
wire add_0_a_19;		wire add_0_b_19;		wire [31:0] add_0_19;		wire add_0_19_vld;
wire add_0_a_20;		wire add_0_b_20;		wire [31:0] add_0_20;		wire add_0_20_vld;
wire add_0_a_21;		wire add_0_b_21;		wire [31:0] add_0_21;		wire add_0_21_vld;
wire add_0_a_22;		wire add_0_b_22;		wire [31:0] add_0_22;		wire add_0_22_vld;
wire add_0_a_23;		wire add_0_b_23;		wire [31:0] add_0_23;		wire add_0_23_vld;
wire add_0_a_24;		wire add_0_b_24;		wire [31:0] add_0_24;		wire add_0_24_vld;
wire add_0_a_25;		wire add_0_b_25;		wire [31:0] add_0_25;		wire add_0_25_vld;
wire add_0_a_26;		wire add_0_b_26;		wire [31:0] add_0_26;		wire add_0_26_vld;
wire add_0_a_27;		wire add_0_b_27;		wire [31:0] add_0_27;		wire add_0_27_vld;
wire add_0_a_28;		wire add_0_b_28;		wire [31:0] add_0_28;		wire add_0_28_vld;
wire add_0_a_29;		wire add_0_b_29;		wire [31:0] add_0_29;		wire add_0_29_vld;
//	 第1级加法器部分
wire add_1_a_0;		wire add_1_b_0;		wire [31:0] add_1_0;		wire add_1_0_vld;
wire add_1_a_1;		wire add_1_b_1;		wire [31:0] add_1_1;		wire add_1_1_vld;
wire add_1_a_2;		wire add_1_b_2;		wire [31:0] add_1_2;		wire add_1_2_vld;
wire add_1_a_3;		wire add_1_b_3;		wire [31:0] add_1_3;		wire add_1_3_vld;
wire add_1_a_4;		wire add_1_b_4;		wire [31:0] add_1_4;		wire add_1_4_vld;
wire add_1_a_5;		wire add_1_b_5;		wire [31:0] add_1_5;		wire add_1_5_vld;
wire add_1_a_6;		wire add_1_b_6;		wire [31:0] add_1_6;		wire add_1_6_vld;
wire add_1_a_7;		wire add_1_b_7;		wire [31:0] add_1_7;		wire add_1_7_vld;
wire add_1_a_8;		wire add_1_b_8;		wire [31:0] add_1_8;		wire add_1_8_vld;
wire add_1_a_9;		wire add_1_b_9;		wire [31:0] add_1_9;		wire add_1_9_vld;
wire add_1_a_10;		wire add_1_b_10;		wire [31:0] add_1_10;		wire add_1_10_vld;
wire add_1_a_11;		wire add_1_b_11;		wire [31:0] add_1_11;		wire add_1_11_vld;
wire add_1_a_12;		wire add_1_b_12;		wire [31:0] add_1_12;		wire add_1_12_vld;
wire add_1_a_13;		wire add_1_b_13;		wire [31:0] add_1_13;		wire add_1_13_vld;
wire add_1_a_14;		wire add_1_b_14;		wire [31:0] add_1_14;		wire add_1_14_vld;
//	 第2级加法器部分
wire add_2_a_0;		wire add_2_b_0;		wire [31:0] add_2_0;		wire add_2_0_vld;
wire add_2_a_1;		wire add_2_b_1;		wire [31:0] add_2_1;		wire add_2_1_vld;
wire add_2_a_2;		wire add_2_b_2;		wire [31:0] add_2_2;		wire add_2_2_vld;
wire add_2_a_3;		wire add_2_b_3;		wire [31:0] add_2_3;		wire add_2_3_vld;
wire add_2_a_4;		wire add_2_b_4;		wire [31:0] add_2_4;		wire add_2_4_vld;
wire add_2_a_5;		wire add_2_b_5;		wire [31:0] add_2_5;		wire add_2_5_vld;
wire add_2_a_6;		wire add_2_b_6;		wire [31:0] add_2_6;		wire add_2_6_vld;
wire add_2_a_7;		wire add_2_b_7;		wire [31:0] add_2_7;		wire add_2_7_vld;
//	 第3级加法器部分
wire add_3_a_0;		wire add_3_b_0;		wire [31:0] add_3_0;		wire add_3_0_vld;
wire add_3_a_1;		wire add_3_b_1;		wire [31:0] add_3_1;		wire add_3_1_vld;
wire add_3_a_2;		wire add_3_b_2;		wire [31:0] add_3_2;		wire add_3_2_vld;
wire add_3_a_3;		wire add_3_b_3;		wire [31:0] add_3_3;		wire add_3_3_vld;
//	 第4级加法器部分
wire add_4_a_0;		wire add_4_b_0;		wire [31:0] add_4_0;		wire add_4_0_vld;
wire add_4_a_1;		wire add_4_b_1;		wire [31:0] add_4_1;		wire add_4_1_vld;
//	 第5级加法器部分
wire add_5_a_0;		wire add_5_b_0;		wire [31:0] add_5_0;		wire add_5_0_vld;

//	乘法器例化部分
mul mul_inst0 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[0]	),
	.s_axis_a_tdata			(wgt_0				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[0]	),
	.s_axis_b_tdata			(fin_0				),

	.m_axis_result_tvalid	(mul_0_vld			),
	.m_axis_result_tready	(add_0_a_0			),
	.m_axis_result_tdata	(mul_0				)
);

mul mul_inst1 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[1]	),
	.s_axis_a_tdata			(wgt_1				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[1]	),
	.s_axis_b_tdata			(fin_1				),

	.m_axis_result_tvalid	(mul_1_vld			),
	.m_axis_result_tready	(add_0_b_0			),
	.m_axis_result_tdata	(mul_1				)
);

mul mul_inst2 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[2]	),
	.s_axis_a_tdata			(wgt_2				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[2]	),
	.s_axis_b_tdata			(fin_2				),

	.m_axis_result_tvalid	(mul_2_vld			),
	.m_axis_result_tready	(add_0_a_1			),
	.m_axis_result_tdata	(mul_2				)
);

mul mul_inst3 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[3]	),
	.s_axis_a_tdata			(wgt_3				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[3]	),
	.s_axis_b_tdata			(fin_3				),

	.m_axis_result_tvalid	(mul_3_vld			),
	.m_axis_result_tready	(add_0_b_1			),
	.m_axis_result_tdata	(mul_3				)
);

mul mul_inst4 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[4]	),
	.s_axis_a_tdata			(wgt_4				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[4]	),
	.s_axis_b_tdata			(fin_4				),

	.m_axis_result_tvalid	(mul_4_vld			),
	.m_axis_result_tready	(add_0_a_2			),
	.m_axis_result_tdata	(mul_4				)
);

mul mul_inst5 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[5]	),
	.s_axis_a_tdata			(wgt_5				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[5]	),
	.s_axis_b_tdata			(fin_5				),

	.m_axis_result_tvalid	(mul_5_vld			),
	.m_axis_result_tready	(add_0_b_2			),
	.m_axis_result_tdata	(mul_5				)
);

mul mul_inst6 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[6]	),
	.s_axis_a_tdata			(wgt_6				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[6]	),
	.s_axis_b_tdata			(fin_6				),

	.m_axis_result_tvalid	(mul_6_vld			),
	.m_axis_result_tready	(add_0_a_3			),
	.m_axis_result_tdata	(mul_6				)
);

mul mul_inst7 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[7]	),
	.s_axis_a_tdata			(wgt_7				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[7]	),
	.s_axis_b_tdata			(fin_7				),

	.m_axis_result_tvalid	(mul_7_vld			),
	.m_axis_result_tready	(add_0_b_3			),
	.m_axis_result_tdata	(mul_7				)
);

mul mul_inst8 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[8]	),
	.s_axis_a_tdata			(wgt_8				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[8]	),
	.s_axis_b_tdata			(fin_8				),

	.m_axis_result_tvalid	(mul_8_vld			),
	.m_axis_result_tready	(add_0_a_4			),
	.m_axis_result_tdata	(mul_8				)
);

mul mul_inst9 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[9]	),
	.s_axis_a_tdata			(wgt_9				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[9]	),
	.s_axis_b_tdata			(fin_9				),

	.m_axis_result_tvalid	(mul_9_vld			),
	.m_axis_result_tready	(add_0_b_4			),
	.m_axis_result_tdata	(mul_9				)
);

mul mul_inst10 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[10]	),
	.s_axis_a_tdata			(wgt_10				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[10]	),
	.s_axis_b_tdata			(fin_10				),

	.m_axis_result_tvalid	(mul_10_vld			),
	.m_axis_result_tready	(add_0_a_5			),
	.m_axis_result_tdata	(mul_10				)
);

mul mul_inst11 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[11]	),
	.s_axis_a_tdata			(wgt_11				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[11]	),
	.s_axis_b_tdata			(fin_11				),

	.m_axis_result_tvalid	(mul_11_vld			),
	.m_axis_result_tready	(add_0_b_5			),
	.m_axis_result_tdata	(mul_11				)
);

mul mul_inst12 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[12]	),
	.s_axis_a_tdata			(wgt_12				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[12]	),
	.s_axis_b_tdata			(fin_12				),

	.m_axis_result_tvalid	(mul_12_vld			),
	.m_axis_result_tready	(add_0_a_6			),
	.m_axis_result_tdata	(mul_12				)
);

mul mul_inst13 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[13]	),
	.s_axis_a_tdata			(wgt_13				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[13]	),
	.s_axis_b_tdata			(fin_13				),

	.m_axis_result_tvalid	(mul_13_vld			),
	.m_axis_result_tready	(add_0_b_6			),
	.m_axis_result_tdata	(mul_13				)
);

mul mul_inst14 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[14]	),
	.s_axis_a_tdata			(wgt_14				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[14]	),
	.s_axis_b_tdata			(fin_14				),

	.m_axis_result_tvalid	(mul_14_vld			),
	.m_axis_result_tready	(add_0_a_7			),
	.m_axis_result_tdata	(mul_14				)
);

mul mul_inst15 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[15]	),
	.s_axis_a_tdata			(wgt_15				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[15]	),
	.s_axis_b_tdata			(fin_15				),

	.m_axis_result_tvalid	(mul_15_vld			),
	.m_axis_result_tready	(add_0_b_7			),
	.m_axis_result_tdata	(mul_15				)
);

mul mul_inst16 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[16]	),
	.s_axis_a_tdata			(wgt_16				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[16]	),
	.s_axis_b_tdata			(fin_16				),

	.m_axis_result_tvalid	(mul_16_vld			),
	.m_axis_result_tready	(add_0_a_8			),
	.m_axis_result_tdata	(mul_16				)
);

mul mul_inst17 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[17]	),
	.s_axis_a_tdata			(wgt_17				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[17]	),
	.s_axis_b_tdata			(fin_17				),

	.m_axis_result_tvalid	(mul_17_vld			),
	.m_axis_result_tready	(add_0_b_8			),
	.m_axis_result_tdata	(mul_17				)
);

mul mul_inst18 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[18]	),
	.s_axis_a_tdata			(wgt_18				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[18]	),
	.s_axis_b_tdata			(fin_18				),

	.m_axis_result_tvalid	(mul_18_vld			),
	.m_axis_result_tready	(add_0_a_9			),
	.m_axis_result_tdata	(mul_18				)
);

mul mul_inst19 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[19]	),
	.s_axis_a_tdata			(wgt_19				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[19]	),
	.s_axis_b_tdata			(fin_19				),

	.m_axis_result_tvalid	(mul_19_vld			),
	.m_axis_result_tready	(add_0_b_9			),
	.m_axis_result_tdata	(mul_19				)
);

mul mul_inst20 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[20]	),
	.s_axis_a_tdata			(wgt_20				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[20]	),
	.s_axis_b_tdata			(fin_20				),

	.m_axis_result_tvalid	(mul_20_vld			),
	.m_axis_result_tready	(add_0_a_10			),
	.m_axis_result_tdata	(mul_20				)
);

mul mul_inst21 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[21]	),
	.s_axis_a_tdata			(wgt_21				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[21]	),
	.s_axis_b_tdata			(fin_21				),

	.m_axis_result_tvalid	(mul_21_vld			),
	.m_axis_result_tready	(add_0_b_10			),
	.m_axis_result_tdata	(mul_21				)
);

mul mul_inst22 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[22]	),
	.s_axis_a_tdata			(wgt_22				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[22]	),
	.s_axis_b_tdata			(fin_22				),

	.m_axis_result_tvalid	(mul_22_vld			),
	.m_axis_result_tready	(add_0_a_11			),
	.m_axis_result_tdata	(mul_22				)
);

mul mul_inst23 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[23]	),
	.s_axis_a_tdata			(wgt_23				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[23]	),
	.s_axis_b_tdata			(fin_23				),

	.m_axis_result_tvalid	(mul_23_vld			),
	.m_axis_result_tready	(add_0_b_11			),
	.m_axis_result_tdata	(mul_23				)
);

mul mul_inst24 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[24]	),
	.s_axis_a_tdata			(wgt_24				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[24]	),
	.s_axis_b_tdata			(fin_24				),

	.m_axis_result_tvalid	(mul_24_vld			),
	.m_axis_result_tready	(add_0_a_12			),
	.m_axis_result_tdata	(mul_24				)
);

mul mul_inst25 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[25]	),
	.s_axis_a_tdata			(wgt_25				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[25]	),
	.s_axis_b_tdata			(fin_25				),

	.m_axis_result_tvalid	(mul_25_vld			),
	.m_axis_result_tready	(add_0_b_12			),
	.m_axis_result_tdata	(mul_25				)
);

mul mul_inst26 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[26]	),
	.s_axis_a_tdata			(wgt_26				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[26]	),
	.s_axis_b_tdata			(fin_26				),

	.m_axis_result_tvalid	(mul_26_vld			),
	.m_axis_result_tready	(add_0_a_13			),
	.m_axis_result_tdata	(mul_26				)
);

mul mul_inst27 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[27]	),
	.s_axis_a_tdata			(wgt_27				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[27]	),
	.s_axis_b_tdata			(fin_27				),

	.m_axis_result_tvalid	(mul_27_vld			),
	.m_axis_result_tready	(add_0_b_13			),
	.m_axis_result_tdata	(mul_27				)
);

mul mul_inst28 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[28]	),
	.s_axis_a_tdata			(wgt_28				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[28]	),
	.s_axis_b_tdata			(fin_28				),

	.m_axis_result_tvalid	(mul_28_vld			),
	.m_axis_result_tready	(add_0_a_14			),
	.m_axis_result_tdata	(mul_28				)
);

mul mul_inst29 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[29]	),
	.s_axis_a_tdata			(wgt_29				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[29]	),
	.s_axis_b_tdata			(fin_29				),

	.m_axis_result_tvalid	(mul_29_vld			),
	.m_axis_result_tready	(add_0_b_14			),
	.m_axis_result_tdata	(mul_29				)
);

mul mul_inst30 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[30]	),
	.s_axis_a_tdata			(wgt_30				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[30]	),
	.s_axis_b_tdata			(fin_30				),

	.m_axis_result_tvalid	(mul_30_vld			),
	.m_axis_result_tready	(add_0_a_15			),
	.m_axis_result_tdata	(mul_30				)
);

mul mul_inst31 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[31]	),
	.s_axis_a_tdata			(wgt_31				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[31]	),
	.s_axis_b_tdata			(fin_31				),

	.m_axis_result_tvalid	(mul_31_vld			),
	.m_axis_result_tready	(add_0_b_15			),
	.m_axis_result_tdata	(mul_31				)
);

mul mul_inst32 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[32]	),
	.s_axis_a_tdata			(wgt_32				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[32]	),
	.s_axis_b_tdata			(fin_32				),

	.m_axis_result_tvalid	(mul_32_vld			),
	.m_axis_result_tready	(add_0_a_16			),
	.m_axis_result_tdata	(mul_32				)
);

mul mul_inst33 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[33]	),
	.s_axis_a_tdata			(wgt_33				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[33]	),
	.s_axis_b_tdata			(fin_33				),

	.m_axis_result_tvalid	(mul_33_vld			),
	.m_axis_result_tready	(add_0_b_16			),
	.m_axis_result_tdata	(mul_33				)
);

mul mul_inst34 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[34]	),
	.s_axis_a_tdata			(wgt_34				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[34]	),
	.s_axis_b_tdata			(fin_34				),

	.m_axis_result_tvalid	(mul_34_vld			),
	.m_axis_result_tready	(add_0_a_17			),
	.m_axis_result_tdata	(mul_34				)
);

mul mul_inst35 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[35]	),
	.s_axis_a_tdata			(wgt_35				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[35]	),
	.s_axis_b_tdata			(fin_35				),

	.m_axis_result_tvalid	(mul_35_vld			),
	.m_axis_result_tready	(add_0_b_17			),
	.m_axis_result_tdata	(mul_35				)
);

mul mul_inst36 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[36]	),
	.s_axis_a_tdata			(wgt_36				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[36]	),
	.s_axis_b_tdata			(fin_36				),

	.m_axis_result_tvalid	(mul_36_vld			),
	.m_axis_result_tready	(add_0_a_18			),
	.m_axis_result_tdata	(mul_36				)
);

mul mul_inst37 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[37]	),
	.s_axis_a_tdata			(wgt_37				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[37]	),
	.s_axis_b_tdata			(fin_37				),

	.m_axis_result_tvalid	(mul_37_vld			),
	.m_axis_result_tready	(add_0_b_18			),
	.m_axis_result_tdata	(mul_37				)
);

mul mul_inst38 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[38]	),
	.s_axis_a_tdata			(wgt_38				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[38]	),
	.s_axis_b_tdata			(fin_38				),

	.m_axis_result_tvalid	(mul_38_vld			),
	.m_axis_result_tready	(add_0_a_19			),
	.m_axis_result_tdata	(mul_38				)
);

mul mul_inst39 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[39]	),
	.s_axis_a_tdata			(wgt_39				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[39]	),
	.s_axis_b_tdata			(fin_39				),

	.m_axis_result_tvalid	(mul_39_vld			),
	.m_axis_result_tready	(add_0_b_19			),
	.m_axis_result_tdata	(mul_39				)
);

mul mul_inst40 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[40]	),
	.s_axis_a_tdata			(wgt_40				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[40]	),
	.s_axis_b_tdata			(fin_40				),

	.m_axis_result_tvalid	(mul_40_vld			),
	.m_axis_result_tready	(add_0_a_20			),
	.m_axis_result_tdata	(mul_40				)
);

mul mul_inst41 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[41]	),
	.s_axis_a_tdata			(wgt_41				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[41]	),
	.s_axis_b_tdata			(fin_41				),

	.m_axis_result_tvalid	(mul_41_vld			),
	.m_axis_result_tready	(add_0_b_20			),
	.m_axis_result_tdata	(mul_41				)
);

mul mul_inst42 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[42]	),
	.s_axis_a_tdata			(wgt_42				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[42]	),
	.s_axis_b_tdata			(fin_42				),

	.m_axis_result_tvalid	(mul_42_vld			),
	.m_axis_result_tready	(add_0_a_21			),
	.m_axis_result_tdata	(mul_42				)
);

mul mul_inst43 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[43]	),
	.s_axis_a_tdata			(wgt_43				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[43]	),
	.s_axis_b_tdata			(fin_43				),

	.m_axis_result_tvalid	(mul_43_vld			),
	.m_axis_result_tready	(add_0_b_21			),
	.m_axis_result_tdata	(mul_43				)
);

mul mul_inst44 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[44]	),
	.s_axis_a_tdata			(wgt_44				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[44]	),
	.s_axis_b_tdata			(fin_44				),

	.m_axis_result_tvalid	(mul_44_vld			),
	.m_axis_result_tready	(add_0_a_22			),
	.m_axis_result_tdata	(mul_44				)
);

mul mul_inst45 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[45]	),
	.s_axis_a_tdata			(wgt_45				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[45]	),
	.s_axis_b_tdata			(fin_45				),

	.m_axis_result_tvalid	(mul_45_vld			),
	.m_axis_result_tready	(add_0_b_22			),
	.m_axis_result_tdata	(mul_45				)
);

mul mul_inst46 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[46]	),
	.s_axis_a_tdata			(wgt_46				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[46]	),
	.s_axis_b_tdata			(fin_46				),

	.m_axis_result_tvalid	(mul_46_vld			),
	.m_axis_result_tready	(add_0_a_23			),
	.m_axis_result_tdata	(mul_46				)
);

mul mul_inst47 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[47]	),
	.s_axis_a_tdata			(wgt_47				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[47]	),
	.s_axis_b_tdata			(fin_47				),

	.m_axis_result_tvalid	(mul_47_vld			),
	.m_axis_result_tready	(add_0_b_23			),
	.m_axis_result_tdata	(mul_47				)
);

mul mul_inst48 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[48]	),
	.s_axis_a_tdata			(wgt_48				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[48]	),
	.s_axis_b_tdata			(fin_48				),

	.m_axis_result_tvalid	(mul_48_vld			),
	.m_axis_result_tready	(add_0_a_24			),
	.m_axis_result_tdata	(mul_48				)
);

mul mul_inst49 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[49]	),
	.s_axis_a_tdata			(wgt_49				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[49]	),
	.s_axis_b_tdata			(fin_49				),

	.m_axis_result_tvalid	(mul_49_vld			),
	.m_axis_result_tready	(add_0_b_24			),
	.m_axis_result_tdata	(mul_49				)
);

mul mul_inst50 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[50]	),
	.s_axis_a_tdata			(wgt_50				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[50]	),
	.s_axis_b_tdata			(fin_50				),

	.m_axis_result_tvalid	(mul_50_vld			),
	.m_axis_result_tready	(add_0_a_25			),
	.m_axis_result_tdata	(mul_50				)
);

mul mul_inst51 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[51]	),
	.s_axis_a_tdata			(wgt_51				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[51]	),
	.s_axis_b_tdata			(fin_51				),

	.m_axis_result_tvalid	(mul_51_vld			),
	.m_axis_result_tready	(add_0_b_25			),
	.m_axis_result_tdata	(mul_51				)
);

mul mul_inst52 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[52]	),
	.s_axis_a_tdata			(wgt_52				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[52]	),
	.s_axis_b_tdata			(fin_52				),

	.m_axis_result_tvalid	(mul_52_vld			),
	.m_axis_result_tready	(add_0_a_26			),
	.m_axis_result_tdata	(mul_52				)
);

mul mul_inst53 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[53]	),
	.s_axis_a_tdata			(wgt_53				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[53]	),
	.s_axis_b_tdata			(fin_53				),

	.m_axis_result_tvalid	(mul_53_vld			),
	.m_axis_result_tready	(add_0_b_26			),
	.m_axis_result_tdata	(mul_53				)
);

mul mul_inst54 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[54]	),
	.s_axis_a_tdata			(wgt_54				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[54]	),
	.s_axis_b_tdata			(fin_54				),

	.m_axis_result_tvalid	(mul_54_vld			),
	.m_axis_result_tready	(add_0_a_27			),
	.m_axis_result_tdata	(mul_54				)
);

mul mul_inst55 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[55]	),
	.s_axis_a_tdata			(wgt_55				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[55]	),
	.s_axis_b_tdata			(fin_55				),

	.m_axis_result_tvalid	(mul_55_vld			),
	.m_axis_result_tready	(add_0_b_27			),
	.m_axis_result_tdata	(mul_55				)
);

mul mul_inst56 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[56]	),
	.s_axis_a_tdata			(wgt_56				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[56]	),
	.s_axis_b_tdata			(fin_56				),

	.m_axis_result_tvalid	(mul_56_vld			),
	.m_axis_result_tready	(add_0_a_28			),
	.m_axis_result_tdata	(mul_56				)
);

mul mul_inst57 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[57]	),
	.s_axis_a_tdata			(wgt_57				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[57]	),
	.s_axis_b_tdata			(fin_57				),

	.m_axis_result_tvalid	(mul_57_vld			),
	.m_axis_result_tready	(add_0_b_28			),
	.m_axis_result_tdata	(mul_57				)
);

mul mul_inst58 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[58]	),
	.s_axis_a_tdata			(wgt_58				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[58]	),
	.s_axis_b_tdata			(fin_58				),

	.m_axis_result_tvalid	(mul_58_vld			),
	.m_axis_result_tready	(add_0_a_29			),
	.m_axis_result_tdata	(mul_58				)
);

mul mul_inst59 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[59]	),
	.s_axis_a_tdata			(wgt_59				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[59]	),
	.s_axis_b_tdata			(fin_59				),

	.m_axis_result_tvalid	(mul_59_vld			),
	.m_axis_result_tready	(add_0_b_29			),
	.m_axis_result_tdata	(mul_59				)
);

mul mul_inst60 (
	.aclk					(aclk				),
	.aresetn				(rst_n				),

	.s_axis_a_tvalid		(mac_req			),
	.s_axis_a_tready		(wgt_req_part[60]	),
	.s_axis_a_tdata			(wgt_60				),

	.s_axis_b_tvalid		(mac_req			),
	.s_axis_b_tready		(fin_req_part[60]	),
	.s_axis_b_tdata			(fin_60				),

	.m_axis_result_tvalid	(mul_60_vld			),
	// 要注意手最后一个乘法器的m_axis_result_tready信号是add_2_b_7 
	.m_axis_result_tready	(add_2_b_7			),
	.m_axis_result_tdata	(mul_60				)
);

assign wgt_req = &wgt_req_part;
assign fin_req = &fin_req_part;

//	打两拍
reg [31:0]	mul_60_r1,mul_60_r2;
reg  		mul_60_vld_r1,mul_60_vld_r2;
always @(posedge aclk or negedge rst_n)
begin
	if (!rst_n)
	begin
		mul_60_r1 <= 32'd0;
        mul_60_r2 <= 32'd0;
		mul_60_vld_r1 <= 1'b0;
        mul_60_vld_r2 <= 1'b0;
	end
	else 
	begin
		mul_60_r1 <= mul_60;
        mul_60_r2 <= mul_60_r1;
		mul_60_vld_r1 <= mul_60_vld;
        mul_60_vld_r2 <= mul_60_vld_r1;
	end
end

//	第0级加法器部分
add add_0_inst0 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_0_vld		),
	.s_axis_a_tready		(add_0_a_0		),
	.s_axis_a_tdata			(mul_0			),

	.s_axis_b_tvalid		(mul_1_vld		),
	.s_axis_b_tready		(add_0_b_0		),
	.s_axis_b_tdata			(mul_1			),

	.m_axis_result_tvalid	(add_0_0_vld	),
	.m_axis_result_tready	(add_1_a_0		),
	.m_axis_result_tdata	(add_0_0		)
);

add add_0_inst1 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_2_vld		),
	.s_axis_a_tready		(add_0_a_1		),
	.s_axis_a_tdata			(mul_2			),

	.s_axis_b_tvalid		(mul_3_vld		),
	.s_axis_b_tready		(add_0_b_1		),
	.s_axis_b_tdata			(mul_3			),

	.m_axis_result_tvalid	(add_0_1_vld	),
	.m_axis_result_tready	(add_1_b_0		),
	.m_axis_result_tdata	(add_0_1		)
);

add add_0_inst2 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_4_vld		),
	.s_axis_a_tready		(add_0_a_2		),
	.s_axis_a_tdata			(mul_4			),

	.s_axis_b_tvalid		(mul_5_vld		),
	.s_axis_b_tready		(add_0_b_2		),
	.s_axis_b_tdata			(mul_5			),

	.m_axis_result_tvalid	(add_0_2_vld	),
	.m_axis_result_tready	(add_1_a_1		),
	.m_axis_result_tdata	(add_0_2		)
);

add add_0_inst3 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_6_vld		),
	.s_axis_a_tready		(add_0_a_3		),
	.s_axis_a_tdata			(mul_6			),

	.s_axis_b_tvalid		(mul_7_vld		),
	.s_axis_b_tready		(add_0_b_3		),
	.s_axis_b_tdata			(mul_7			),

	.m_axis_result_tvalid	(add_0_3_vld	),
	.m_axis_result_tready	(add_1_b_1		),
	.m_axis_result_tdata	(add_0_3		)
);

add add_0_inst4 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_8_vld		),
	.s_axis_a_tready		(add_0_a_4		),
	.s_axis_a_tdata			(mul_8			),

	.s_axis_b_tvalid		(mul_9_vld		),
	.s_axis_b_tready		(add_0_b_4		),
	.s_axis_b_tdata			(mul_9			),

	.m_axis_result_tvalid	(add_0_4_vld	),
	.m_axis_result_tready	(add_1_a_2		),
	.m_axis_result_tdata	(add_0_4		)
);

add add_0_inst5 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_10_vld		),
	.s_axis_a_tready		(add_0_a_5		),
	.s_axis_a_tdata			(mul_10			),

	.s_axis_b_tvalid		(mul_11_vld		),
	.s_axis_b_tready		(add_0_b_5		),
	.s_axis_b_tdata			(mul_11			),

	.m_axis_result_tvalid	(add_0_5_vld	),
	.m_axis_result_tready	(add_1_b_2		),
	.m_axis_result_tdata	(add_0_5		)
);

add add_0_inst6 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_12_vld		),
	.s_axis_a_tready		(add_0_a_6		),
	.s_axis_a_tdata			(mul_12			),

	.s_axis_b_tvalid		(mul_13_vld		),
	.s_axis_b_tready		(add_0_b_6		),
	.s_axis_b_tdata			(mul_13			),

	.m_axis_result_tvalid	(add_0_6_vld	),
	.m_axis_result_tready	(add_1_a_3		),
	.m_axis_result_tdata	(add_0_6		)
);

add add_0_inst7 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_14_vld		),
	.s_axis_a_tready		(add_0_a_7		),
	.s_axis_a_tdata			(mul_14			),

	.s_axis_b_tvalid		(mul_15_vld		),
	.s_axis_b_tready		(add_0_b_7		),
	.s_axis_b_tdata			(mul_15			),

	.m_axis_result_tvalid	(add_0_7_vld	),
	.m_axis_result_tready	(add_1_b_3		),
	.m_axis_result_tdata	(add_0_7		)
);

add add_0_inst8 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_16_vld		),
	.s_axis_a_tready		(add_0_a_8		),
	.s_axis_a_tdata			(mul_16			),

	.s_axis_b_tvalid		(mul_17_vld		),
	.s_axis_b_tready		(add_0_b_8		),
	.s_axis_b_tdata			(mul_17			),

	.m_axis_result_tvalid	(add_0_8_vld	),
	.m_axis_result_tready	(add_1_a_4		),
	.m_axis_result_tdata	(add_0_8		)
);

add add_0_inst9 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_18_vld		),
	.s_axis_a_tready		(add_0_a_9		),
	.s_axis_a_tdata			(mul_18			),

	.s_axis_b_tvalid		(mul_19_vld		),
	.s_axis_b_tready		(add_0_b_9		),
	.s_axis_b_tdata			(mul_19			),

	.m_axis_result_tvalid	(add_0_9_vld	),
	.m_axis_result_tready	(add_1_b_4		),
	.m_axis_result_tdata	(add_0_9		)
);

add add_0_inst10 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_20_vld		),
	.s_axis_a_tready		(add_0_a_10		),
	.s_axis_a_tdata			(mul_20			),

	.s_axis_b_tvalid		(mul_21_vld		),
	.s_axis_b_tready		(add_0_b_10		),
	.s_axis_b_tdata			(mul_21			),

	.m_axis_result_tvalid	(add_0_10_vld	),
	.m_axis_result_tready	(add_1_a_5		),
	.m_axis_result_tdata	(add_0_10		)
);

add add_0_inst11 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_22_vld		),
	.s_axis_a_tready		(add_0_a_11		),
	.s_axis_a_tdata			(mul_22			),

	.s_axis_b_tvalid		(mul_23_vld		),
	.s_axis_b_tready		(add_0_b_11		),
	.s_axis_b_tdata			(mul_23			),

	.m_axis_result_tvalid	(add_0_11_vld	),
	.m_axis_result_tready	(add_1_b_5		),
	.m_axis_result_tdata	(add_0_11		)
);

add add_0_inst12 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_24_vld		),
	.s_axis_a_tready		(add_0_a_12		),
	.s_axis_a_tdata			(mul_24			),

	.s_axis_b_tvalid		(mul_25_vld		),
	.s_axis_b_tready		(add_0_b_12		),
	.s_axis_b_tdata			(mul_25			),

	.m_axis_result_tvalid	(add_0_12_vld	),
	.m_axis_result_tready	(add_1_a_6		),
	.m_axis_result_tdata	(add_0_12		)
);

add add_0_inst13 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_26_vld		),
	.s_axis_a_tready		(add_0_a_13		),
	.s_axis_a_tdata			(mul_26			),

	.s_axis_b_tvalid		(mul_27_vld		),
	.s_axis_b_tready		(add_0_b_13		),
	.s_axis_b_tdata			(mul_27			),

	.m_axis_result_tvalid	(add_0_13_vld	),
	.m_axis_result_tready	(add_1_b_6		),
	.m_axis_result_tdata	(add_0_13		)
);

add add_0_inst14 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_28_vld		),
	.s_axis_a_tready		(add_0_a_14		),
	.s_axis_a_tdata			(mul_28			),

	.s_axis_b_tvalid		(mul_29_vld		),
	.s_axis_b_tready		(add_0_b_14		),
	.s_axis_b_tdata			(mul_29			),

	.m_axis_result_tvalid	(add_0_14_vld	),
	.m_axis_result_tready	(add_1_a_7		),
	.m_axis_result_tdata	(add_0_14		)
);

add add_0_inst15 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_30_vld		),
	.s_axis_a_tready		(add_0_a_15		),
	.s_axis_a_tdata			(mul_30			),

	.s_axis_b_tvalid		(mul_31_vld		),
	.s_axis_b_tready		(add_0_b_15		),
	.s_axis_b_tdata			(mul_31			),

	.m_axis_result_tvalid	(add_0_15_vld	),
	.m_axis_result_tready	(add_1_b_7		),
	.m_axis_result_tdata	(add_0_15		)
);

add add_0_inst16 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_32_vld		),
	.s_axis_a_tready		(add_0_a_16		),
	.s_axis_a_tdata			(mul_32			),

	.s_axis_b_tvalid		(mul_33_vld		),
	.s_axis_b_tready		(add_0_b_16		),
	.s_axis_b_tdata			(mul_33			),

	.m_axis_result_tvalid	(add_0_16_vld	),
	.m_axis_result_tready	(add_1_a_8		),
	.m_axis_result_tdata	(add_0_16		)
);

add add_0_inst17 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_34_vld		),
	.s_axis_a_tready		(add_0_a_17		),
	.s_axis_a_tdata			(mul_34			),

	.s_axis_b_tvalid		(mul_35_vld		),
	.s_axis_b_tready		(add_0_b_17		),
	.s_axis_b_tdata			(mul_35			),

	.m_axis_result_tvalid	(add_0_17_vld	),
	.m_axis_result_tready	(add_1_b_8		),
	.m_axis_result_tdata	(add_0_17		)
);

add add_0_inst18 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_36_vld		),
	.s_axis_a_tready		(add_0_a_18		),
	.s_axis_a_tdata			(mul_36			),

	.s_axis_b_tvalid		(mul_37_vld		),
	.s_axis_b_tready		(add_0_b_18		),
	.s_axis_b_tdata			(mul_37			),

	.m_axis_result_tvalid	(add_0_18_vld	),
	.m_axis_result_tready	(add_1_a_9		),
	.m_axis_result_tdata	(add_0_18		)
);

add add_0_inst19 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_38_vld		),
	.s_axis_a_tready		(add_0_a_19		),
	.s_axis_a_tdata			(mul_38			),

	.s_axis_b_tvalid		(mul_39_vld		),
	.s_axis_b_tready		(add_0_b_19		),
	.s_axis_b_tdata			(mul_39			),

	.m_axis_result_tvalid	(add_0_19_vld	),
	.m_axis_result_tready	(add_1_b_9		),
	.m_axis_result_tdata	(add_0_19		)
);

add add_0_inst20 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_40_vld		),
	.s_axis_a_tready		(add_0_a_20		),
	.s_axis_a_tdata			(mul_40			),

	.s_axis_b_tvalid		(mul_41_vld		),
	.s_axis_b_tready		(add_0_b_20		),
	.s_axis_b_tdata			(mul_41			),

	.m_axis_result_tvalid	(add_0_20_vld	),
	.m_axis_result_tready	(add_1_a_10		),
	.m_axis_result_tdata	(add_0_20		)
);

add add_0_inst21 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_42_vld		),
	.s_axis_a_tready		(add_0_a_21		),
	.s_axis_a_tdata			(mul_42			),

	.s_axis_b_tvalid		(mul_43_vld		),
	.s_axis_b_tready		(add_0_b_21		),
	.s_axis_b_tdata			(mul_43			),

	.m_axis_result_tvalid	(add_0_21_vld	),
	.m_axis_result_tready	(add_1_b_10		),
	.m_axis_result_tdata	(add_0_21		)
);

add add_0_inst22 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_44_vld		),
	.s_axis_a_tready		(add_0_a_22		),
	.s_axis_a_tdata			(mul_44			),

	.s_axis_b_tvalid		(mul_45_vld		),
	.s_axis_b_tready		(add_0_b_22		),
	.s_axis_b_tdata			(mul_45			),

	.m_axis_result_tvalid	(add_0_22_vld	),
	.m_axis_result_tready	(add_1_a_11		),
	.m_axis_result_tdata	(add_0_22		)
);

add add_0_inst23 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_46_vld		),
	.s_axis_a_tready		(add_0_a_23		),
	.s_axis_a_tdata			(mul_46			),

	.s_axis_b_tvalid		(mul_47_vld		),
	.s_axis_b_tready		(add_0_b_23		),
	.s_axis_b_tdata			(mul_47			),

	.m_axis_result_tvalid	(add_0_23_vld	),
	.m_axis_result_tready	(add_1_b_11		),
	.m_axis_result_tdata	(add_0_23		)
);

add add_0_inst24 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_48_vld		),
	.s_axis_a_tready		(add_0_a_24		),
	.s_axis_a_tdata			(mul_48			),

	.s_axis_b_tvalid		(mul_49_vld		),
	.s_axis_b_tready		(add_0_b_24		),
	.s_axis_b_tdata			(mul_49			),

	.m_axis_result_tvalid	(add_0_24_vld	),
	.m_axis_result_tready	(add_1_a_12		),
	.m_axis_result_tdata	(add_0_24		)
);

add add_0_inst25 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_50_vld		),
	.s_axis_a_tready		(add_0_a_25		),
	.s_axis_a_tdata			(mul_50			),

	.s_axis_b_tvalid		(mul_51_vld		),
	.s_axis_b_tready		(add_0_b_25		),
	.s_axis_b_tdata			(mul_51			),

	.m_axis_result_tvalid	(add_0_25_vld	),
	.m_axis_result_tready	(add_1_b_12		),
	.m_axis_result_tdata	(add_0_25		)
);

add add_0_inst26 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_52_vld		),
	.s_axis_a_tready		(add_0_a_26		),
	.s_axis_a_tdata			(mul_52			),

	.s_axis_b_tvalid		(mul_53_vld		),
	.s_axis_b_tready		(add_0_b_26		),
	.s_axis_b_tdata			(mul_53			),

	.m_axis_result_tvalid	(add_0_26_vld	),
	.m_axis_result_tready	(add_1_a_13		),
	.m_axis_result_tdata	(add_0_26		)
);

add add_0_inst27 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_54_vld		),
	.s_axis_a_tready		(add_0_a_27		),
	.s_axis_a_tdata			(mul_54			),

	.s_axis_b_tvalid		(mul_55_vld		),
	.s_axis_b_tready		(add_0_b_27		),
	.s_axis_b_tdata			(mul_55			),

	.m_axis_result_tvalid	(add_0_27_vld	),
	.m_axis_result_tready	(add_1_b_13		),
	.m_axis_result_tdata	(add_0_27		)
);

add add_0_inst28 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_56_vld		),
	.s_axis_a_tready		(add_0_a_28		),
	.s_axis_a_tdata			(mul_56			),

	.s_axis_b_tvalid		(mul_57_vld		),
	.s_axis_b_tready		(add_0_b_28		),
	.s_axis_b_tdata			(mul_57			),

	.m_axis_result_tvalid	(add_0_28_vld	),
	.m_axis_result_tready	(add_1_a_14		),
	.m_axis_result_tdata	(add_0_28		)
);

add add_0_inst29 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(mul_58_vld		),
	.s_axis_a_tready		(add_0_a_29		),
	.s_axis_a_tdata			(mul_58			),

	.s_axis_b_tvalid		(mul_59_vld		),
	.s_axis_b_tready		(add_0_b_29		),
	.s_axis_b_tdata			(mul_59			),

	.m_axis_result_tvalid	(add_0_29_vld	),
	.m_axis_result_tready	(add_1_b_14		),
	.m_axis_result_tdata	(add_0_29		)
);

//	第1级加法器部分
add add_1_inst0 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_0_vld	),
	.s_axis_a_tready		(add_1_a_0		),
	.s_axis_a_tdata			(add_0_0		),

	.s_axis_b_tvalid		(add_0_1_vld	),
	.s_axis_b_tready		(add_1_b_0		),
	.s_axis_b_tdata			(add_0_1		),

	.m_axis_result_tvalid	(add_1_0_vld	),
	.m_axis_result_tready	(add_2_a_0		),
	.m_axis_result_tdata	(add_1_0		)
);

add add_1_inst1 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_2_vld	),
	.s_axis_a_tready		(add_1_a_1		),
	.s_axis_a_tdata			(add_0_2		),

	.s_axis_b_tvalid		(add_0_3_vld	),
	.s_axis_b_tready		(add_1_b_1		),
	.s_axis_b_tdata			(add_0_3		),

	.m_axis_result_tvalid	(add_1_1_vld	),
	.m_axis_result_tready	(add_2_b_0		),
	.m_axis_result_tdata	(add_1_1		)
);

add add_1_inst2 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_4_vld	),
	.s_axis_a_tready		(add_1_a_2		),
	.s_axis_a_tdata			(add_0_4		),

	.s_axis_b_tvalid		(add_0_5_vld	),
	.s_axis_b_tready		(add_1_b_2		),
	.s_axis_b_tdata			(add_0_5		),

	.m_axis_result_tvalid	(add_1_2_vld	),
	.m_axis_result_tready	(add_2_a_1		),
	.m_axis_result_tdata	(add_1_2		)
);

add add_1_inst3 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_6_vld	),
	.s_axis_a_tready		(add_1_a_3		),
	.s_axis_a_tdata			(add_0_6		),

	.s_axis_b_tvalid		(add_0_7_vld	),
	.s_axis_b_tready		(add_1_b_3		),
	.s_axis_b_tdata			(add_0_7		),

	.m_axis_result_tvalid	(add_1_3_vld	),
	.m_axis_result_tready	(add_2_b_1		),
	.m_axis_result_tdata	(add_1_3		)
);

add add_1_inst4 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_8_vld	),
	.s_axis_a_tready		(add_1_a_4		),
	.s_axis_a_tdata			(add_0_8		),

	.s_axis_b_tvalid		(add_0_9_vld	),
	.s_axis_b_tready		(add_1_b_4		),
	.s_axis_b_tdata			(add_0_9		),

	.m_axis_result_tvalid	(add_1_4_vld	),
	.m_axis_result_tready	(add_2_a_2		),
	.m_axis_result_tdata	(add_1_4		)
);

add add_1_inst5 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_10_vld	),
	.s_axis_a_tready		(add_1_a_5		),
	.s_axis_a_tdata			(add_0_10		),

	.s_axis_b_tvalid		(add_0_11_vld	),
	.s_axis_b_tready		(add_1_b_5		),
	.s_axis_b_tdata			(add_0_11		),

	.m_axis_result_tvalid	(add_1_5_vld	),
	.m_axis_result_tready	(add_2_b_2		),
	.m_axis_result_tdata	(add_1_5		)
);

add add_1_inst6 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_12_vld	),
	.s_axis_a_tready		(add_1_a_6		),
	.s_axis_a_tdata			(add_0_12		),

	.s_axis_b_tvalid		(add_0_13_vld	),
	.s_axis_b_tready		(add_1_b_6		),
	.s_axis_b_tdata			(add_0_13		),

	.m_axis_result_tvalid	(add_1_6_vld	),
	.m_axis_result_tready	(add_2_a_3		),
	.m_axis_result_tdata	(add_1_6		)
);

add add_1_inst7 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_14_vld	),
	.s_axis_a_tready		(add_1_a_7		),
	.s_axis_a_tdata			(add_0_14		),

	.s_axis_b_tvalid		(add_0_15_vld	),
	.s_axis_b_tready		(add_1_b_7		),
	.s_axis_b_tdata			(add_0_15		),

	.m_axis_result_tvalid	(add_1_7_vld	),
	.m_axis_result_tready	(add_2_b_3		),
	.m_axis_result_tdata	(add_1_7		)
);

add add_1_inst8 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_16_vld	),
	.s_axis_a_tready		(add_1_a_8		),
	.s_axis_a_tdata			(add_0_16		),

	.s_axis_b_tvalid		(add_0_17_vld	),
	.s_axis_b_tready		(add_1_b_8		),
	.s_axis_b_tdata			(add_0_17		),

	.m_axis_result_tvalid	(add_1_8_vld	),
	.m_axis_result_tready	(add_2_a_4		),
	.m_axis_result_tdata	(add_1_8		)
);

add add_1_inst9 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_18_vld	),
	.s_axis_a_tready		(add_1_a_9		),
	.s_axis_a_tdata			(add_0_18		),

	.s_axis_b_tvalid		(add_0_19_vld	),
	.s_axis_b_tready		(add_1_b_9		),
	.s_axis_b_tdata			(add_0_19		),

	.m_axis_result_tvalid	(add_1_9_vld	),
	.m_axis_result_tready	(add_2_b_4		),
	.m_axis_result_tdata	(add_1_9		)
);

add add_1_inst10 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_20_vld	),
	.s_axis_a_tready		(add_1_a_10		),
	.s_axis_a_tdata			(add_0_20		),

	.s_axis_b_tvalid		(add_0_21_vld	),
	.s_axis_b_tready		(add_1_b_10		),
	.s_axis_b_tdata			(add_0_21		),

	.m_axis_result_tvalid	(add_1_10_vld	),
	.m_axis_result_tready	(add_2_a_5		),
	.m_axis_result_tdata	(add_1_10		)
);

add add_1_inst11 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_22_vld	),
	.s_axis_a_tready		(add_1_a_11		),
	.s_axis_a_tdata			(add_0_22		),

	.s_axis_b_tvalid		(add_0_23_vld	),
	.s_axis_b_tready		(add_1_b_11		),
	.s_axis_b_tdata			(add_0_23		),

	.m_axis_result_tvalid	(add_1_11_vld	),
	.m_axis_result_tready	(add_2_b_5		),
	.m_axis_result_tdata	(add_1_11		)
);

add add_1_inst12 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_24_vld	),
	.s_axis_a_tready		(add_1_a_12		),
	.s_axis_a_tdata			(add_0_24		),

	.s_axis_b_tvalid		(add_0_25_vld	),
	.s_axis_b_tready		(add_1_b_12		),
	.s_axis_b_tdata			(add_0_25		),

	.m_axis_result_tvalid	(add_1_12_vld	),
	.m_axis_result_tready	(add_2_a_6		),
	.m_axis_result_tdata	(add_1_12		)
);

add add_1_inst13 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_26_vld	),
	.s_axis_a_tready		(add_1_a_13		),
	.s_axis_a_tdata			(add_0_26		),

	.s_axis_b_tvalid		(add_0_27_vld	),
	.s_axis_b_tready		(add_1_b_13		),
	.s_axis_b_tdata			(add_0_27		),

	.m_axis_result_tvalid	(add_1_13_vld	),
	.m_axis_result_tready	(add_2_b_6		),
	.m_axis_result_tdata	(add_1_13		)
);

add add_1_inst14 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_0_28_vld	),
	.s_axis_a_tready		(add_1_a_14		),
	.s_axis_a_tdata			(add_0_28		),

	.s_axis_b_tvalid		(add_0_29_vld	),
	.s_axis_b_tready		(add_1_b_14		),
	.s_axis_b_tdata			(add_0_29		),

	.m_axis_result_tvalid	(add_1_14_vld	),
	.m_axis_result_tready	(add_2_a_7		),
	.m_axis_result_tdata	(add_1_14		)
);

//	第2级加法器部分
add add_2_inst0 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_1_0_vld	),
	.s_axis_a_tready		(add_2_a_0		),
	.s_axis_a_tdata			(add_1_0		),

	.s_axis_b_tvalid		(add_1_1_vld	),
	.s_axis_b_tready		(add_2_b_0		),
	.s_axis_b_tdata			(add_1_1		),

	.m_axis_result_tvalid	(add_2_0_vld	),
	.m_axis_result_tready	(add_3_a_0		),
	.m_axis_result_tdata	(add_2_0		)
);

add add_2_inst1 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_1_2_vld	),
	.s_axis_a_tready		(add_2_a_1		),
	.s_axis_a_tdata			(add_1_2		),

	.s_axis_b_tvalid		(add_1_3_vld	),
	.s_axis_b_tready		(add_2_b_1		),
	.s_axis_b_tdata			(add_1_3		),

	.m_axis_result_tvalid	(add_2_1_vld	),
	.m_axis_result_tready	(add_3_b_0		),
	.m_axis_result_tdata	(add_2_1		)
);

add add_2_inst2 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_1_4_vld	),
	.s_axis_a_tready		(add_2_a_2		),
	.s_axis_a_tdata			(add_1_4		),

	.s_axis_b_tvalid		(add_1_5_vld	),
	.s_axis_b_tready		(add_2_b_2		),
	.s_axis_b_tdata			(add_1_5		),

	.m_axis_result_tvalid	(add_2_2_vld	),
	.m_axis_result_tready	(add_3_a_1		),
	.m_axis_result_tdata	(add_2_2		)
);

add add_2_inst3 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_1_6_vld	),
	.s_axis_a_tready		(add_2_a_3		),
	.s_axis_a_tdata			(add_1_6		),

	.s_axis_b_tvalid		(add_1_7_vld	),
	.s_axis_b_tready		(add_2_b_3		),
	.s_axis_b_tdata			(add_1_7		),

	.m_axis_result_tvalid	(add_2_3_vld	),
	.m_axis_result_tready	(add_3_b_1		),
	.m_axis_result_tdata	(add_2_3		)
);

add add_2_inst4 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_1_8_vld	),
	.s_axis_a_tready		(add_2_a_4		),
	.s_axis_a_tdata			(add_1_8		),

	.s_axis_b_tvalid		(add_1_9_vld	),
	.s_axis_b_tready		(add_2_b_4		),
	.s_axis_b_tdata			(add_1_9		),

	.m_axis_result_tvalid	(add_2_4_vld	),
	.m_axis_result_tready	(add_3_a_2		),
	.m_axis_result_tdata	(add_2_4		)
);

add add_2_inst5 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_1_10_vld	),
	.s_axis_a_tready		(add_2_a_5		),
	.s_axis_a_tdata			(add_1_10		),

	.s_axis_b_tvalid		(add_1_11_vld	),
	.s_axis_b_tready		(add_2_b_5		),
	.s_axis_b_tdata			(add_1_11		),

	.m_axis_result_tvalid	(add_2_5_vld	),
	.m_axis_result_tready	(add_3_b_2		),
	.m_axis_result_tdata	(add_2_5		)
);

add add_2_inst6 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_1_12_vld	),
	.s_axis_a_tready		(add_2_a_6		),
	.s_axis_a_tdata			(add_1_12		),

	.s_axis_b_tvalid		(add_1_13_vld	),
	.s_axis_b_tready		(add_2_b_6		),
	.s_axis_b_tdata			(add_1_13		),

	.m_axis_result_tvalid	(add_2_6_vld	),
	.m_axis_result_tready	(add_3_a_3		),
	.m_axis_result_tdata	(add_2_6		)
);

add add_2_inst7 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_1_14_vld	),
	.s_axis_a_tready		(add_2_a_7		),
	.s_axis_a_tdata			(add_1_14		),

	.s_axis_b_tvalid		(mul_60_vld_r2	),
	.s_axis_b_tready		(add_2_b_7		),
	.s_axis_b_tdata			(mul_60_r2		),

	.m_axis_result_tvalid	(add_2_7_vld	),
	.m_axis_result_tready	(add_3_b_3		),
	.m_axis_result_tdata	(add_2_7		)
);
    
//	第3级加法器部分
add add_3_inst0 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_2_0_vld	),
	.s_axis_a_tready		(add_3_a_0		),
	.s_axis_a_tdata			(add_2_0		),

	.s_axis_b_tvalid		(add_2_1_vld	),
	.s_axis_b_tready		(add_3_b_0		),
	.s_axis_b_tdata			(add_2_1		),

	.m_axis_result_tvalid	(add_3_0_vld	),
	.m_axis_result_tready	(add_4_a_0		),
	.m_axis_result_tdata	(add_3_0		)
);

add add_3_inst1 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_2_2_vld	),
	.s_axis_a_tready		(add_3_a_1		),
	.s_axis_a_tdata			(add_2_2		),

	.s_axis_b_tvalid		(add_2_3_vld	),
	.s_axis_b_tready		(add_3_b_1		),
	.s_axis_b_tdata			(add_2_3		),

	.m_axis_result_tvalid	(add_3_1_vld	),
	.m_axis_result_tready	(add_4_b_0		),
	.m_axis_result_tdata	(add_3_1		)
);

add add_3_inst2 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_2_4_vld	),
	.s_axis_a_tready		(add_3_a_2		),
	.s_axis_a_tdata			(add_2_4		),

	.s_axis_b_tvalid		(add_2_5_vld	),
	.s_axis_b_tready		(add_3_b_2		),
	.s_axis_b_tdata			(add_2_5		),

	.m_axis_result_tvalid	(add_3_2_vld	),
	.m_axis_result_tready	(add_4_a_1		),
	.m_axis_result_tdata	(add_3_2		)
);

add add_3_inst3 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_2_6_vld	),
	.s_axis_a_tready		(add_3_a_3		),
	.s_axis_a_tdata			(add_2_6		),

	.s_axis_b_tvalid		(add_2_7_vld	),
	.s_axis_b_tready		(add_3_b_3		),
	.s_axis_b_tdata			(add_2_7		),

	.m_axis_result_tvalid	(add_3_3_vld	),
	.m_axis_result_tready	(add_4_b_1		),
	.m_axis_result_tdata	(add_3_3		)
);

//	第4级加法器部分
add add_4_inst0 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_3_0_vld	),
	.s_axis_a_tready		(add_4_a_0		),
	.s_axis_a_tdata			(add_3_0		),

	.s_axis_b_tvalid		(add_3_1_vld	),
	.s_axis_b_tready		(add_4_b_0		),
	.s_axis_b_tdata			(add_3_1		),

	.m_axis_result_tvalid	(add_4_0_vld	),
	.m_axis_result_tready	(add_5_a_0		),
	.m_axis_result_tdata	(add_4_0		)
);

add add_4_inst1 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_3_2_vld	),
	.s_axis_a_tready		(add_4_a_1		),
	.s_axis_a_tdata			(add_3_2		),

	.s_axis_b_tvalid		(add_3_3_vld	),
	.s_axis_b_tready		(add_4_b_1		),
	.s_axis_b_tdata			(add_3_3		),

	.m_axis_result_tvalid	(add_4_1_vld	),
	.m_axis_result_tready	(add_5_b_0		),
	.m_axis_result_tdata	(add_4_1		)
);

//	第5级加法器部分
add add_5_inst0 	(
	.aclk					(aclk			),
	.aresetn				(rst_n			),

	.s_axis_a_tvalid		(add_4_0_vld	),
	.s_axis_a_tready		(add_5_a_0		),
	.s_axis_a_tdata			(add_4_0		),

	.s_axis_b_tvalid		(add_4_1_vld	),
	.s_axis_b_tready		(add_5_b_0		),
	.s_axis_b_tdata			(add_4_1		),

	.m_axis_result_tvalid	(add_5_0_vld	),
	.m_axis_result_tready	(1'b1			),
	.m_axis_result_tdata	(add_5_0		)
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
        mac_done <= add_5_0_vld;
        mac_data <= add_5_0;
    end
end

endmodule