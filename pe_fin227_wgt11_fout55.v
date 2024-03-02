/*
	时间：			2023.10.04
	功能：			实现长度为227的fin向量与长度为11的wgt向量卷积，输出结果是长度为55的向量，应用于AlexNet的conv0
	
	数据类型：		单精度浮点
	版本：			1.0
	
	时序：			① 
	
	功能限制部分：	① 	
	
	可改进的方向：	① 
	
	修改：			① 
	
	修改意图：		① 
*/
module pe_fin227_wgt11_fout55 (
	input						clk				,
	input						rst_n			,
	
	//	控制接口
	output						pe_fin_row_en	,	//	可以发起一次新的特征图输入行处理
	output						fin_req			,	//	进行一次mac所需的数据请求信号,由于mac之间是完全并行的，因此不会出现有的mac算完了但是有的Mac没算完吧
	output						wgt_req			,	//	如果fea和wgt端口都是高电平则可以开始计算
	input						pe_fin_row_req	,	//	开始处理输入特征图新的一行
	input						pe_fout_row_req	,	//	开始处理输出特征图新的一行
	output						pe_row_done		,	//	输出特征图新的一行计算完毕
	
	//	缓存接口
	input			[31:0]		wgt_0			,
	input			[31:0]		wgt_1			,
	input			[31:0]		wgt_2			,
	input			[31:0]		wgt_3			,
	input			[31:0]		wgt_4			,
	input			[31:0]		wgt_5			,
	input			[31:0]		wgt_6			,
	input			[31:0]		wgt_7			,
	input			[31:0]		wgt_8			,
	input			[31:0]		wgt_9			,
	input			[31:0]		wgt_10			,
	
	input			[31:0]		fin_0			,
	input			[31:0]		fin_1			,
	input			[31:0]		fin_1			,
	input			[31:0]		fin_2			,
	input			[31:0]		fin_3			,
	input			[31:0]		fin_4			,
	input			[31:0]		fin_5			,
	input			[31:0]		fin_6			,
	input			[31:0]		fin_7			,
	input			[31:0]		fin_8			,
	input			[31:0]		fin_9			,
	input			[31:0]		fin_10			,
	input			[31:0]		fin_11			,
	input			[31:0]		fin_12			,
	input			[31:0]		fin_13			,
	input			[31:0]		fin_14			,
	input			[31:0]		fin_15			,
	input			[31:0]		fin_16			,
	input			[31:0]		fin_17			,
	input			[31:0]		fin_18			,
	input			[31:0]		fin_19			,
	input			[31:0]		fin_20			,
	input			[31:0]		fin_21			,
	input			[31:0]		fin_22			,
	input			[31:0]		fin_23			,
	input			[31:0]		fin_24			,
	input			[31:0]		fin_25			,
	input			[31:0]		fin_26			,
	input			[31:0]		fin_27			,
	input			[31:0]		fin_28			,
	input			[31:0]		fin_29			,
	input			[31:0]		fin_30			,
	input			[31:0]		fin_31			,
	input			[31:0]		fin_32			,
	input			[31:0]		fin_33			,
	input			[31:0]		fin_34			,
	input			[31:0]		fin_35			,
	input			[31:0]		fin_36			,
	input			[31:0]		fin_37			,
	input			[31:0]		fin_38			,
	input			[31:0]		fin_39			,
	input			[31:0]		fin_40			,
	input			[31:0]		fin_41			,
	input			[31:0]		fin_42			,
	input			[31:0]		fin_43			,
	input			[31:0]		fin_44			,
	input			[31:0]		fin_45			,
	input			[31:0]		fin_46			,
	input			[31:0]		fin_47			,
	input			[31:0]		fin_48			,
	input			[31:0]		fin_49			,
	input			[31:0]		fin_50			,
	input			[31:0]		fin_51			,
	input			[31:0]		fin_52			,
	input			[31:0]		fin_53			,
	input			[31:0]		fin_54			,
	input			[31:0]		fin_55			,
	input			[31:0]		fin_56			,
	input			[31:0]		fin_57			,
	input			[31:0]		fin_58			,
	input			[31:0]		fin_59			,
	input			[31:0]		fin_60			,
	input			[31:0]		fin_61			,
	input			[31:0]		fin_62			,
	input			[31:0]		fin_63			,
	input			[31:0]		fin_64			,
	input			[31:0]		fin_65			,
	input			[31:0]		fin_66			,
	input			[31:0]		fin_67			,
	input			[31:0]		fin_68			,
	input			[31:0]		fin_69			,
	input			[31:0]		fin_70			,
	input			[31:0]		fin_71			,
	input			[31:0]		fin_72			,
	input			[31:0]		fin_73			,
	input			[31:0]		fin_74			,
	input			[31:0]		fin_75			,
	input			[31:0]		fin_76			,
	input			[31:0]		fin_77			,
	input			[31:0]		fin_78			,
	input			[31:0]		fin_79			,
	input			[31:0]		fin_80			,
	input			[31:0]		fin_81			,
	input			[31:0]		fin_82			,
	input			[31:0]		fin_83			,
	input			[31:0]		fin_84			,
	input			[31:0]		fin_85			,
	input			[31:0]		fin_86			,
	input			[31:0]		fin_87			,
	input			[31:0]		fin_88			,
	input			[31:0]		fin_89			,
	input			[31:0]		fin_90			,
	input			[31:0]		fin_91			,
	input			[31:0]		fin_92			,
	input			[31:0]		fin_93			,
	input			[31:0]		fin_94			,
	input			[31:0]		fin_95			,
	input			[31:0]		fin_96			,
	input			[31:0]		fin_97			,
	input			[31:0]		fin_98			,
	input			[31:0]		fin_99			,
	input			[31:0]		fin_100			,
	input			[31:0]		fin_101			,
	input			[31:0]		fin_102			,
	input			[31:0]		fin_103			,
	input			[31:0]		fin_104			,
	input			[31:0]		fin_105			,
	input			[31:0]		fin_106			,
	input			[31:0]		fin_107			,
	input			[31:0]		fin_108			,
	input			[31:0]		fin_109			,
	input			[31:0]		fin_110			,
	input			[31:0]		fin_111			,
	input			[31:0]		fin_112			,
	input			[31:0]		fin_113			,
	input			[31:0]		fin_114			,
	input			[31:0]		fin_115			,
	input			[31:0]		fin_116			,
	input			[31:0]		fin_117			,
	input			[31:0]		fin_118			,
	input			[31:0]		fin_119			,
	input			[31:0]		fin_120			,
	input			[31:0]		fin_121			,
	input			[31:0]		fin_122			,
	input			[31:0]		fin_123			,
	input			[31:0]		fin_124			,
	input			[31:0]		fin_125			,
	input			[31:0]		fin_126			,
	input			[31:0]		fin_127			,
	input			[31:0]		fin_128			,
	input			[31:0]		fin_129			,
	input			[31:0]		fin_130			,
	input			[31:0]		fin_131			,
	input			[31:0]		fin_132			,
	input			[31:0]		fin_133			,
	input			[31:0]		fin_134			,
	input			[31:0]		fin_135			,
	input			[31:0]		fin_136			,
	input			[31:0]		fin_137			,
	input			[31:0]		fin_138			,
	input			[31:0]		fin_139			,
	input			[31:0]		fin_140			,
	input			[31:0]		fin_141			,
	input			[31:0]		fin_142			,
	input			[31:0]		fin_143			,
	input			[31:0]		fin_144			,
	input			[31:0]		fin_145			,
	input			[31:0]		fin_146			,
	input			[31:0]		fin_147			,
	input			[31:0]		fin_148			,
	input			[31:0]		fin_149			,
	input			[31:0]		fin_150			,
	input			[31:0]		fin_151			,
	input			[31:0]		fin_152			,
	input			[31:0]		fin_153			,
	input			[31:0]		fin_154			,
	input			[31:0]		fin_155			,
	input			[31:0]		fin_156			,
	input			[31:0]		fin_157			,
	input			[31:0]		fin_158			,
	input			[31:0]		fin_159			,
	input			[31:0]		fin_160			,
	input			[31:0]		fin_161			,
	input			[31:0]		fin_162			,
	input			[31:0]		fin_163			,
	input			[31:0]		fin_164			,
	input			[31:0]		fin_165			,
	input			[31:0]		fin_166			,
	input			[31:0]		fin_167			,
	input			[31:0]		fin_168			,
	input			[31:0]		fin_169			,
	input			[31:0]		fin_170			,
	input			[31:0]		fin_171			,
	input			[31:0]		fin_172			,
	input			[31:0]		fin_173			,
	input			[31:0]		fin_174			,
	input			[31:0]		fin_175			,
	input			[31:0]		fin_176			,
	input			[31:0]		fin_177			,
	input			[31:0]		fin_178			,
	input			[31:0]		fin_179			,
	input			[31:0]		fin_180			,
	input			[31:0]		fin_181			,
	input			[31:0]		fin_182			,
	input			[31:0]		fin_183			,
	input			[31:0]		fin_184			,
	input			[31:0]		fin_185			,
	input			[31:0]		fin_186			,
	input			[31:0]		fin_187			,
	input			[31:0]		fin_188			,
	input			[31:0]		fin_189			,
	input			[31:0]		fin_190			,
	input			[31:0]		fin_191			,
	input			[31:0]		fin_192			,
	input			[31:0]		fin_193			,
	input			[31:0]		fin_194			,
	input			[31:0]		fin_195			,
	input			[31:0]		fin_196			,
	input			[31:0]		fin_197			,
	input			[31:0]		fin_198			,
	input			[31:0]		fin_199			,
	input			[31:0]		fin_200			,
	input			[31:0]		fin_201			,
	input			[31:0]		fin_202			,
	input			[31:0]		fin_203			,
	input			[31:0]		fin_204			,
	input			[31:0]		fin_205			,
	input			[31:0]		fin_206			,
	input			[31:0]		fin_207			,
	input			[31:0]		fin_208			,
	input			[31:0]		fin_209			,
	input			[31:0]		fin_210			,
	input			[31:0]		fin_211			,
	input			[31:0]		fin_212			,
	input			[31:0]		fin_213			,
	input			[31:0]		fin_214			,
	input			[31:0]		fin_215			,
	input			[31:0]		fin_216			,
	input			[31:0]		fin_217			,
	input			[31:0]		fin_218			,
	input			[31:0]		fin_219			,
	input			[31:0]		fin_220			,
	input			[31:0]		fin_221			,
	input			[31:0]		fin_222			,
	input			[31:0]		fin_223			,
	input			[31:0]		fin_224			,
	input			[31:0]		fin_225			,
	input			[31:0]		fin_226			,
	
	output	reg		[31:0]		fout_0			,
	output	reg		[31:0]		fout_1			,
	output	reg		[31:0]		fout_2			,
	output	reg		[31:0]		fout_3			,
	output	reg		[31:0]		fout_4			,
	output	reg		[31:0]		fout_5			,
	output	reg		[31:0]		fout_6			,
	output	reg		[31:0]		fout_7			,
	output	reg		[31:0]		fout_8			,
	output	reg		[31:0]		fout_9			,
	output	reg		[31:0]		fout_10			,
	output	reg		[31:0]		fout_11			,
	output	reg		[31:0]		fout_12			,
	output	reg		[31:0]		fout_13			,
	output	reg		[31:0]		fout_14			,
	output	reg		[31:0]		fout_15			,
	output	reg		[31:0]		fout_16			,
	output	reg		[31:0]		fout_17			,
	output	reg		[31:0]		fout_18			,
	output	reg		[31:0]		fout_19			,
	output	reg		[31:0]		fout_20			,
	output	reg		[31:0]		fout_21			,
	output	reg		[31:0]		fout_22			,
	output	reg		[31:0]		fout_23			,
	output	reg		[31:0]		fout_24			,
	output	reg		[31:0]		fout_25			,
	output	reg		[31:0]		fout_26			,
	output	reg		[31:0]		fout_27			,
	output	reg		[31:0]		fout_28			,
	output	reg		[31:0]		fout_29			,
	output	reg		[31:0]		fout_30			,
	output	reg		[31:0]		fout_31			,
	output	reg		[31:0]		fout_32			,
	output	reg		[31:0]		fout_33			,
	output	reg		[31:0]		fout_34			,
	output	reg		[31:0]		fout_35			,
	output	reg		[31:0]		fout_36			,
	output	reg		[31:0]		fout_37			,
	output	reg		[31:0]		fout_38			,
	output	reg		[31:0]		fout_39			,
	output	reg		[31:0]		fout_40			,
	output	reg		[31:0]		fout_41			,
	output	reg		[31:0]		fout_42			,
	output	reg		[31:0]		fout_43			,
	output	reg		[31:0]		fout_44			,
	output	reg		[31:0]		fout_45			,
	output	reg		[31:0]		fout_46			,
	output	reg		[31:0]		fout_47			,
	output	reg		[31:0]		fout_48			,
	output	reg		[31:0]		fout_49			,
	output	reg		[31:0]		fout_50			,
	output	reg		[31:0]		fout_51			,
	output	reg		[31:0]		fout_52			,
	output	reg		[31:0]		fout_53			,
	output	reg		[31:0]		fout_54			
);

//	变量定义区
wire [31:0] fout_inst0;     wire [31:0] fout_inst1;     wire [31:0] fout_inst2;     wire [31:0] fout_inst3;     wire [31:0] fout_inst4;

wire [31:0] fin_inst0_0;		wire [31:0] fin_inst0_1;		wire [31:0] fin_inst0_2;		wire [31:0] fin_inst0_3;		wire [31:0] fin_inst0_4;		wire [31:0] fin_inst0_5;		wire [31:0] fin_inst0_6;		wire [31:0] fin_inst0_7;		wire [31:0] fin_inst0_8;		wire [31:0] fin_inst0_9;		wire [31:0] fin_inst0_10;		
wire [31:0] fin_inst1_0;		wire [31:0] fin_inst1_1;		wire [31:0] fin_inst1_2;		wire [31:0] fin_inst1_3;		wire [31:0] fin_inst1_4;		wire [31:0] fin_inst1_5;		wire [31:0] fin_inst1_6;		wire [31:0] fin_inst1_7;		wire [31:0] fin_inst1_8;		wire [31:0] fin_inst1_9;		wire [31:0] fin_inst1_10;		
wire [31:0] fin_inst2_0;		wire [31:0] fin_inst2_1;		wire [31:0] fin_inst2_2;		wire [31:0] fin_inst2_3;		wire [31:0] fin_inst2_4;		wire [31:0] fin_inst2_5;		wire [31:0] fin_inst2_6;		wire [31:0] fin_inst2_7;		wire [31:0] fin_inst2_8;		wire [31:0] fin_inst2_9;		wire [31:0] fin_inst2_10;		
wire [31:0] fin_inst3_0;		wire [31:0] fin_inst3_1;		wire [31:0] fin_inst3_2;		wire [31:0] fin_inst3_3;		wire [31:0] fin_inst3_4;		wire [31:0] fin_inst3_5;		wire [31:0] fin_inst3_6;		wire [31:0] fin_inst3_7;		wire [31:0] fin_inst3_8;		wire [31:0] fin_inst3_9;		wire [31:0] fin_inst3_10;		
wire [31:0] fin_inst4_0;		wire [31:0] fin_inst4_1;		wire [31:0] fin_inst4_2;		wire [31:0] fin_inst4_3;		wire [31:0] fin_inst4_4;		wire [31:0] fin_inst4_5;		wire [31:0] fin_inst4_6;		wire [31:0] fin_inst4_7;		wire [31:0] fin_inst4_8;		wire [31:0] fin_inst4_9;		wire [31:0] fin_inst4_10;		

wire	mac_done;		//	由于mac是并行运算的，因此应该可以保证所有的Mac都可以在同一时刻运算完毕
wire	mac_req;		//	让pe_fin_row_req启动第一次计算，然后后续计算由fin_wgt_req发起
wire	fin_wgt_req;	//	感觉在FPGA上这个信号应该是除复位外一直为高电平的

//	检测pe_fout_row_req和pe_fin_row_req上升沿
reg		pe_fout_row_req_r;		reg		pe_fin_row_req_r;
wire	pe_fout_row_req_pos;	wire	pe_fin_row_req_pos;
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
	begin
		pe_fout_row_req_r <= 1'b0;
		pe_fin_row_req_r <= 1'b0;
	end
	else
	begin
		pe_fout_row_req_r <= pe_fout_row_req;
		pe_fin_row_req_r <= pe_fin_row_req;
	end
end
assign	pe_fout_row_req_pos = pe_fout_row_req && (!pe_fout_row_req_r);
assign	pe_fin_row_req_pos = pe_fin_row_req && (!pe_fin_row_req_r);

//	用于指vecMac11运行了多少次
reg [3:0]	sel;	
always @(posedge clk or negedge rst_n)
begin
	if (!rst_n)
		sel <= 4'd0;
	//	这样写的目的是让pe_fin_row_req启动第一次计算，然后后续计算由fin_wgt_req发起
	else if (pe_fin_row_req_pos)
		sel <= 4'd1;		//	pe_fin_row_req_pos为高电平的时刻sel为0，但是下一个时刻为1
	else if ((sel >= 4'd1) && (sel < 4'd10) && fin_wgt_req)
		sel <= sel + 4'd1;	//	这么写的目的主要是为了让sel信号在11次计算之后自动清零
	else
		sel <= 4'd0;	
end

//	如果sel为0，说明接下来可以处理第一个数
assign	pe_fin_row_en = sel == 4'd0;
//	由于时序是先准备好了数据再去进行运算，因此第一次运算之后的计算由fin_wgt_req发起
assign	fin_wgt_req = fin_req && wgt_req;
assign	mac_req = (sel == 4'd0)	?	pe_fin_row_req_pos	:	fin_wgt_req;

//	根据cnt译码出当前计算所需的fea，这种数据安排的目的是保证每个时刻每个fea只会参与一个计算，避免扇出数变大
assign	fin_inst0_0		=	(sel == 4'd0)	?	fin_0	:	(sel == 4'd1)	?	fin_4	:	(sel == 4'd2)	?	fin_8	:	(sel == 4'd3)	?	fin_12	:	(sel == 4'd4)	?	fin_16	:	(sel == 4'd5)	?	fin_20	:	(sel == 4'd6)	?	fin_24	:	(sel == 4'd7)	?	fin_28	:	(sel == 4'd8)	?	fin_32	:	(sel == 4'd9)	?	fin_36	:	fin_40;
assign	fin_inst0_1		=	(sel == 4'd0)	?	fin_1	:	(sel == 4'd1)	?	fin_5	:	(sel == 4'd2)	?	fin_9	:	(sel == 4'd3)	?	fin_13	:	(sel == 4'd4)	?	fin_17	:	(sel == 4'd5)	?	fin_21	:	(sel == 4'd6)	?	fin_25	:	(sel == 4'd7)	?	fin_29	:	(sel == 4'd8)	?	fin_33	:	(sel == 4'd9)	?	fin_37	:	fin_41;
assign	fin_inst0_2		=	(sel == 4'd0)	?	fin_2	:	(sel == 4'd1)	?	fin_6	:	(sel == 4'd2)	?	fin_10	:	(sel == 4'd3)	?	fin_14	:	(sel == 4'd4)	?	fin_18	:	(sel == 4'd5)	?	fin_22	:	(sel == 4'd6)	?	fin_26	:	(sel == 4'd7)	?	fin_30	:	(sel == 4'd8)	?	fin_34	:	(sel == 4'd9)	?	fin_38	:	fin_42;
assign	fin_inst0_3		=	(sel == 4'd0)	?	fin_3	:	(sel == 4'd1)	?	fin_7	:	(sel == 4'd2)	?	fin_11	:	(sel == 4'd3)	?	fin_15	:	(sel == 4'd4)	?	fin_19	:	(sel == 4'd5)	?	fin_23	:	(sel == 4'd6)	?	fin_27	:	(sel == 4'd7)	?	fin_31	:	(sel == 4'd8)	?	fin_35	:	(sel == 4'd9)	?	fin_39	:	fin_43;
assign	fin_inst0_4		=	(sel == 4'd0)	?	fin_4	:	(sel == 4'd1)	?	fin_8	:	(sel == 4'd2)	?	fin_12	:	(sel == 4'd3)	?	fin_16	:	(sel == 4'd4)	?	fin_20	:	(sel == 4'd5)	?	fin_24	:	(sel == 4'd6)	?	fin_28	:	(sel == 4'd7)	?	fin_32	:	(sel == 4'd8)	?	fin_36	:	(sel == 4'd9)	?	fin_40	:	fin_44;
assign	fin_inst0_5		=	(sel == 4'd0)	?	fin_5	:	(sel == 4'd1)	?	fin_9	:	(sel == 4'd2)	?	fin_13	:	(sel == 4'd3)	?	fin_17	:	(sel == 4'd4)	?	fin_21	:	(sel == 4'd5)	?	fin_25	:	(sel == 4'd6)	?	fin_29	:	(sel == 4'd7)	?	fin_33	:	(sel == 4'd8)	?	fin_37	:	(sel == 4'd9)	?	fin_41	:	fin_45;
assign	fin_inst0_6		=	(sel == 4'd0)	?	fin_6	:	(sel == 4'd1)	?	fin_10	:	(sel == 4'd2)	?	fin_14	:	(sel == 4'd3)	?	fin_18	:	(sel == 4'd4)	?	fin_22	:	(sel == 4'd5)	?	fin_26	:	(sel == 4'd6)	?	fin_30	:	(sel == 4'd7)	?	fin_34	:	(sel == 4'd8)	?	fin_38	:	(sel == 4'd9)	?	fin_42	:	fin_46;
assign	fin_inst0_7		=	(sel == 4'd0)	?	fin_7	:	(sel == 4'd1)	?	fin_11	:	(sel == 4'd2)	?	fin_15	:	(sel == 4'd3)	?	fin_19	:	(sel == 4'd4)	?	fin_23	:	(sel == 4'd5)	?	fin_27	:	(sel == 4'd6)	?	fin_31	:	(sel == 4'd7)	?	fin_35	:	(sel == 4'd8)	?	fin_39	:	(sel == 4'd9)	?	fin_43	:	fin_47;
assign	fin_inst0_8		=	(sel == 4'd0)	?	fin_8	:	(sel == 4'd1)	?	fin_12	:	(sel == 4'd2)	?	fin_16	:	(sel == 4'd3)	?	fin_20	:	(sel == 4'd4)	?	fin_24	:	(sel == 4'd5)	?	fin_28	:	(sel == 4'd6)	?	fin_32	:	(sel == 4'd7)	?	fin_36	:	(sel == 4'd8)	?	fin_40	:	(sel == 4'd9)	?	fin_44	:	fin_48;
assign	fin_inst0_9		=	(sel == 4'd0)	?	fin_9	:	(sel == 4'd1)	?	fin_13	:	(sel == 4'd2)	?	fin_17	:	(sel == 4'd3)	?	fin_21	:	(sel == 4'd4)	?	fin_25	:	(sel == 4'd5)	?	fin_29	:	(sel == 4'd6)	?	fin_33	:	(sel == 4'd7)	?	fin_37	:	(sel == 4'd8)	?	fin_41	:	(sel == 4'd9)	?	fin_45	:	fin_49;
assign	fin_inst0_10	=	(sel == 4'd0)	?	fin_10	:	(sel == 4'd1)	?	fin_14	:	(sel == 4'd2)	?	fin_18	:	(sel == 4'd3)	?	fin_22	:	(sel == 4'd4)	?	fin_26	:	(sel == 4'd5)	?	fin_30	:	(sel == 4'd6)	?	fin_34	:	(sel == 4'd7)	?	fin_38	:	(sel == 4'd8)	?	fin_42	:	(sel == 4'd9)	?	fin_46	:	fin_50;

assign	fin_inst1_0		=	(sel == 4'd0)	?	fin_44	:	(sel == 4'd1)	?	fin_48	:	(sel == 4'd2)	?	fin_52	:	(sel == 4'd3)	?	fin_56	:	(sel == 4'd4)	?	fin_60	:	(sel == 4'd5)	?	fin_64	:	(sel == 4'd6)	?	fin_68	:	(sel == 4'd7)	?	fin_72	:	(sel == 4'd8)	?	fin_76	:	(sel == 4'd9)	?	fin_80	:	fin_84;
assign	fin_inst1_1		=	(sel == 4'd0)	?	fin_45	:	(sel == 4'd1)	?	fin_49	:	(sel == 4'd2)	?	fin_53	:	(sel == 4'd3)	?	fin_57	:	(sel == 4'd4)	?	fin_61	:	(sel == 4'd5)	?	fin_65	:	(sel == 4'd6)	?	fin_69	:	(sel == 4'd7)	?	fin_73	:	(sel == 4'd8)	?	fin_77	:	(sel == 4'd9)	?	fin_81	:	fin_85;
assign	fin_inst1_2		=	(sel == 4'd0)	?	fin_46	:	(sel == 4'd1)	?	fin_50	:	(sel == 4'd2)	?	fin_54	:	(sel == 4'd3)	?	fin_58	:	(sel == 4'd4)	?	fin_62	:	(sel == 4'd5)	?	fin_66	:	(sel == 4'd6)	?	fin_70	:	(sel == 4'd7)	?	fin_74	:	(sel == 4'd8)	?	fin_78	:	(sel == 4'd9)	?	fin_82	:	fin_86;
assign	fin_inst1_3		=	(sel == 4'd0)	?	fin_47	:	(sel == 4'd1)	?	fin_51	:	(sel == 4'd2)	?	fin_55	:	(sel == 4'd3)	?	fin_59	:	(sel == 4'd4)	?	fin_63	:	(sel == 4'd5)	?	fin_67	:	(sel == 4'd6)	?	fin_71	:	(sel == 4'd7)	?	fin_75	:	(sel == 4'd8)	?	fin_79	:	(sel == 4'd9)	?	fin_83	:	fin_87;
assign	fin_inst1_4		=	(sel == 4'd0)	?	fin_48	:	(sel == 4'd1)	?	fin_52	:	(sel == 4'd2)	?	fin_56	:	(sel == 4'd3)	?	fin_60	:	(sel == 4'd4)	?	fin_64	:	(sel == 4'd5)	?	fin_68	:	(sel == 4'd6)	?	fin_72	:	(sel == 4'd7)	?	fin_76	:	(sel == 4'd8)	?	fin_80	:	(sel == 4'd9)	?	fin_84	:	fin_88;
assign	fin_inst1_5		=	(sel == 4'd0)	?	fin_49	:	(sel == 4'd1)	?	fin_53	:	(sel == 4'd2)	?	fin_57	:	(sel == 4'd3)	?	fin_61	:	(sel == 4'd4)	?	fin_65	:	(sel == 4'd5)	?	fin_69	:	(sel == 4'd6)	?	fin_73	:	(sel == 4'd7)	?	fin_77	:	(sel == 4'd8)	?	fin_81	:	(sel == 4'd9)	?	fin_85	:	fin_89;
assign	fin_inst1_6		=	(sel == 4'd0)	?	fin_50	:	(sel == 4'd1)	?	fin_54	:	(sel == 4'd2)	?	fin_58	:	(sel == 4'd3)	?	fin_62	:	(sel == 4'd4)	?	fin_66	:	(sel == 4'd5)	?	fin_70	:	(sel == 4'd6)	?	fin_74	:	(sel == 4'd7)	?	fin_78	:	(sel == 4'd8)	?	fin_82	:	(sel == 4'd9)	?	fin_86	:	fin_90;
assign	fin_inst1_7		=	(sel == 4'd0)	?	fin_51	:	(sel == 4'd1)	?	fin_55	:	(sel == 4'd2)	?	fin_59	:	(sel == 4'd3)	?	fin_63	:	(sel == 4'd4)	?	fin_67	:	(sel == 4'd5)	?	fin_71	:	(sel == 4'd6)	?	fin_75	:	(sel == 4'd7)	?	fin_79	:	(sel == 4'd8)	?	fin_83	:	(sel == 4'd9)	?	fin_87	:	fin_91;
assign	fin_inst1_8		=	(sel == 4'd0)	?	fin_52	:	(sel == 4'd1)	?	fin_56	:	(sel == 4'd2)	?	fin_60	:	(sel == 4'd3)	?	fin_64	:	(sel == 4'd4)	?	fin_68	:	(sel == 4'd5)	?	fin_72	:	(sel == 4'd6)	?	fin_76	:	(sel == 4'd7)	?	fin_80	:	(sel == 4'd8)	?	fin_84	:	(sel == 4'd9)	?	fin_88	:	fin_92;
assign	fin_inst1_9		=	(sel == 4'd0)	?	fin_53	:	(sel == 4'd1)	?	fin_57	:	(sel == 4'd2)	?	fin_61	:	(sel == 4'd3)	?	fin_65	:	(sel == 4'd4)	?	fin_69	:	(sel == 4'd5)	?	fin_73	:	(sel == 4'd6)	?	fin_77	:	(sel == 4'd7)	?	fin_81	:	(sel == 4'd8)	?	fin_85	:	(sel == 4'd9)	?	fin_89	:	fin_93;
assign	fin_inst1_10	=	(sel == 4'd0)	?	fin_54	:	(sel == 4'd1)	?	fin_58	:	(sel == 4'd2)	?	fin_62	:	(sel == 4'd3)	?	fin_66	:	(sel == 4'd4)	?	fin_70	:	(sel == 4'd5)	?	fin_74	:	(sel == 4'd6)	?	fin_78	:	(sel == 4'd7)	?	fin_82	:	(sel == 4'd8)	?	fin_86	:	(sel == 4'd9)	?	fin_90	:	fin_94;

assign	fin_inst2_0		=	(sel == 4'd0)	?	fin_88	:	(sel == 4'd1)	?	fin_92	:	(sel == 4'd2)	?	fin_96	:	(sel == 4'd3)	?	fin_100	:	(sel == 4'd4)	?	fin_104	:	(sel == 4'd5)	?	fin_108	:	(sel == 4'd6)	?	fin_112	:	(sel == 4'd7)	?	fin_116	:	(sel == 4'd8)	?	fin_120	:	(sel == 4'd9)	?	fin_124	:	fin_128;
assign	fin_inst2_1		=	(sel == 4'd0)	?	fin_89	:	(sel == 4'd1)	?	fin_93	:	(sel == 4'd2)	?	fin_97	:	(sel == 4'd3)	?	fin_101	:	(sel == 4'd4)	?	fin_105	:	(sel == 4'd5)	?	fin_109	:	(sel == 4'd6)	?	fin_113	:	(sel == 4'd7)	?	fin_117	:	(sel == 4'd8)	?	fin_121	:	(sel == 4'd9)	?	fin_125	:	fin_129;
assign	fin_inst2_2		=	(sel == 4'd0)	?	fin_90	:	(sel == 4'd1)	?	fin_94	:	(sel == 4'd2)	?	fin_98	:	(sel == 4'd3)	?	fin_102	:	(sel == 4'd4)	?	fin_106	:	(sel == 4'd5)	?	fin_110	:	(sel == 4'd6)	?	fin_114	:	(sel == 4'd7)	?	fin_118	:	(sel == 4'd8)	?	fin_122	:	(sel == 4'd9)	?	fin_126	:	fin_130;
assign	fin_inst2_3		=	(sel == 4'd0)	?	fin_91	:	(sel == 4'd1)	?	fin_95	:	(sel == 4'd2)	?	fin_99	:	(sel == 4'd3)	?	fin_103	:	(sel == 4'd4)	?	fin_107	:	(sel == 4'd5)	?	fin_111	:	(sel == 4'd6)	?	fin_115	:	(sel == 4'd7)	?	fin_119	:	(sel == 4'd8)	?	fin_123	:	(sel == 4'd9)	?	fin_127	:	fin_131;
assign	fin_inst2_4		=	(sel == 4'd0)	?	fin_92	:	(sel == 4'd1)	?	fin_96	:	(sel == 4'd2)	?	fin_100	:	(sel == 4'd3)	?	fin_104	:	(sel == 4'd4)	?	fin_108	:	(sel == 4'd5)	?	fin_112	:	(sel == 4'd6)	?	fin_116	:	(sel == 4'd7)	?	fin_120	:	(sel == 4'd8)	?	fin_124	:	(sel == 4'd9)	?	fin_128	:	fin_132;
assign	fin_inst2_5		=	(sel == 4'd0)	?	fin_93	:	(sel == 4'd1)	?	fin_97	:	(sel == 4'd2)	?	fin_101	:	(sel == 4'd3)	?	fin_105	:	(sel == 4'd4)	?	fin_109	:	(sel == 4'd5)	?	fin_113	:	(sel == 4'd6)	?	fin_117	:	(sel == 4'd7)	?	fin_121	:	(sel == 4'd8)	?	fin_125	:	(sel == 4'd9)	?	fin_129	:	fin_133;
assign	fin_inst2_6		=	(sel == 4'd0)	?	fin_94	:	(sel == 4'd1)	?	fin_98	:	(sel == 4'd2)	?	fin_102	:	(sel == 4'd3)	?	fin_106	:	(sel == 4'd4)	?	fin_110	:	(sel == 4'd5)	?	fin_114	:	(sel == 4'd6)	?	fin_118	:	(sel == 4'd7)	?	fin_122	:	(sel == 4'd8)	?	fin_126	:	(sel == 4'd9)	?	fin_130	:	fin_134;
assign	fin_inst2_7		=	(sel == 4'd0)	?	fin_95	:	(sel == 4'd1)	?	fin_99	:	(sel == 4'd2)	?	fin_103	:	(sel == 4'd3)	?	fin_107	:	(sel == 4'd4)	?	fin_111	:	(sel == 4'd5)	?	fin_115	:	(sel == 4'd6)	?	fin_119	:	(sel == 4'd7)	?	fin_123	:	(sel == 4'd8)	?	fin_127	:	(sel == 4'd9)	?	fin_131	:	fin_135;
assign	fin_inst2_8		=	(sel == 4'd0)	?	fin_96	:	(sel == 4'd1)	?	fin_100	:	(sel == 4'd2)	?	fin_104	:	(sel == 4'd3)	?	fin_108	:	(sel == 4'd4)	?	fin_112	:	(sel == 4'd5)	?	fin_116	:	(sel == 4'd6)	?	fin_120	:	(sel == 4'd7)	?	fin_124	:	(sel == 4'd8)	?	fin_128	:	(sel == 4'd9)	?	fin_132	:	fin_136;
assign	fin_inst2_9		=	(sel == 4'd0)	?	fin_97	:	(sel == 4'd1)	?	fin_101	:	(sel == 4'd2)	?	fin_105	:	(sel == 4'd3)	?	fin_109	:	(sel == 4'd4)	?	fin_113	:	(sel == 4'd5)	?	fin_117	:	(sel == 4'd6)	?	fin_121	:	(sel == 4'd7)	?	fin_125	:	(sel == 4'd8)	?	fin_129	:	(sel == 4'd9)	?	fin_133	:	fin_137;
assign	fin_inst2_10	=	(sel == 4'd0)	?	fin_98	:	(sel == 4'd1)	?	fin_102	:	(sel == 4'd2)	?	fin_106	:	(sel == 4'd3)	?	fin_110	:	(sel == 4'd4)	?	fin_114	:	(sel == 4'd5)	?	fin_118	:	(sel == 4'd6)	?	fin_122	:	(sel == 4'd7)	?	fin_126	:	(sel == 4'd8)	?	fin_130	:	(sel == 4'd9)	?	fin_134	:	fin_138;

assign	fin_inst3_0		=	(sel == 4'd0)	?	fin_132	:	(sel == 4'd1)	?	fin_136	:	(sel == 4'd2)	?	fin_140	:	(sel == 4'd3)	?	fin_144	:	(sel == 4'd4)	?	fin_148	:	(sel == 4'd5)	?	fin_152	:	(sel == 4'd6)	?	fin_156	:	(sel == 4'd7)	?	fin_160	:	(sel == 4'd8)	?	fin_164	:	(sel == 4'd9)	?	fin_168	:	fin_172;
assign	fin_inst3_1		=	(sel == 4'd0)	?	fin_133	:	(sel == 4'd1)	?	fin_137	:	(sel == 4'd2)	?	fin_141	:	(sel == 4'd3)	?	fin_145	:	(sel == 4'd4)	?	fin_149	:	(sel == 4'd5)	?	fin_153	:	(sel == 4'd6)	?	fin_157	:	(sel == 4'd7)	?	fin_161	:	(sel == 4'd8)	?	fin_165	:	(sel == 4'd9)	?	fin_169	:	fin_173;
assign	fin_inst3_2		=	(sel == 4'd0)	?	fin_134	:	(sel == 4'd1)	?	fin_138	:	(sel == 4'd2)	?	fin_142	:	(sel == 4'd3)	?	fin_146	:	(sel == 4'd4)	?	fin_150	:	(sel == 4'd5)	?	fin_154	:	(sel == 4'd6)	?	fin_158	:	(sel == 4'd7)	?	fin_162	:	(sel == 4'd8)	?	fin_166	:	(sel == 4'd9)	?	fin_170	:	fin_174;
assign	fin_inst3_3		=	(sel == 4'd0)	?	fin_135	:	(sel == 4'd1)	?	fin_139	:	(sel == 4'd2)	?	fin_143	:	(sel == 4'd3)	?	fin_147	:	(sel == 4'd4)	?	fin_151	:	(sel == 4'd5)	?	fin_155	:	(sel == 4'd6)	?	fin_159	:	(sel == 4'd7)	?	fin_163	:	(sel == 4'd8)	?	fin_167	:	(sel == 4'd9)	?	fin_171	:	fin_175;
assign	fin_inst3_4		=	(sel == 4'd0)	?	fin_136	:	(sel == 4'd1)	?	fin_140	:	(sel == 4'd2)	?	fin_144	:	(sel == 4'd3)	?	fin_148	:	(sel == 4'd4)	?	fin_152	:	(sel == 4'd5)	?	fin_156	:	(sel == 4'd6)	?	fin_160	:	(sel == 4'd7)	?	fin_164	:	(sel == 4'd8)	?	fin_168	:	(sel == 4'd9)	?	fin_172	:	fin_176;
assign	fin_inst3_5		=	(sel == 4'd0)	?	fin_137	:	(sel == 4'd1)	?	fin_141	:	(sel == 4'd2)	?	fin_145	:	(sel == 4'd3)	?	fin_149	:	(sel == 4'd4)	?	fin_153	:	(sel == 4'd5)	?	fin_157	:	(sel == 4'd6)	?	fin_161	:	(sel == 4'd7)	?	fin_165	:	(sel == 4'd8)	?	fin_169	:	(sel == 4'd9)	?	fin_173	:	fin_177;
assign	fin_inst3_6		=	(sel == 4'd0)	?	fin_138	:	(sel == 4'd1)	?	fin_142	:	(sel == 4'd2)	?	fin_146	:	(sel == 4'd3)	?	fin_150	:	(sel == 4'd4)	?	fin_154	:	(sel == 4'd5)	?	fin_158	:	(sel == 4'd6)	?	fin_162	:	(sel == 4'd7)	?	fin_166	:	(sel == 4'd8)	?	fin_170	:	(sel == 4'd9)	?	fin_174	:	fin_178;
assign	fin_inst3_7		=	(sel == 4'd0)	?	fin_139	:	(sel == 4'd1)	?	fin_143	:	(sel == 4'd2)	?	fin_147	:	(sel == 4'd3)	?	fin_151	:	(sel == 4'd4)	?	fin_155	:	(sel == 4'd5)	?	fin_159	:	(sel == 4'd6)	?	fin_163	:	(sel == 4'd7)	?	fin_167	:	(sel == 4'd8)	?	fin_171	:	(sel == 4'd9)	?	fin_175	:	fin_179;
assign	fin_inst3_8		=	(sel == 4'd0)	?	fin_140	:	(sel == 4'd1)	?	fin_144	:	(sel == 4'd2)	?	fin_148	:	(sel == 4'd3)	?	fin_152	:	(sel == 4'd4)	?	fin_156	:	(sel == 4'd5)	?	fin_160	:	(sel == 4'd6)	?	fin_164	:	(sel == 4'd7)	?	fin_168	:	(sel == 4'd8)	?	fin_172	:	(sel == 4'd9)	?	fin_176	:	fin_180;
assign	fin_inst3_9		=	(sel == 4'd0)	?	fin_141	:	(sel == 4'd1)	?	fin_145	:	(sel == 4'd2)	?	fin_149	:	(sel == 4'd3)	?	fin_153	:	(sel == 4'd4)	?	fin_157	:	(sel == 4'd5)	?	fin_161	:	(sel == 4'd6)	?	fin_165	:	(sel == 4'd7)	?	fin_169	:	(sel == 4'd8)	?	fin_173	:	(sel == 4'd9)	?	fin_177	:	fin_181;
assign	fin_inst3_10	=	(sel == 4'd0)	?	fin_142	:	(sel == 4'd1)	?	fin_146	:	(sel == 4'd2)	?	fin_150	:	(sel == 4'd3)	?	fin_154	:	(sel == 4'd4)	?	fin_158	:	(sel == 4'd5)	?	fin_162	:	(sel == 4'd6)	?	fin_166	:	(sel == 4'd7)	?	fin_170	:	(sel == 4'd8)	?	fin_174	:	(sel == 4'd9)	?	fin_178	:	fin_182;

assign	fin_inst4_0		=	(sel == 4'd0)	?	fin_176	:	(sel == 4'd1)	?	fin_180	:	(sel == 4'd2)	?	fin_184	:	(sel == 4'd3)	?	fin_188	:	(sel == 4'd4)	?	fin_192	:	(sel == 4'd5)	?	fin_196	:	(sel == 4'd6)	?	fin_200	:	(sel == 4'd7)	?	fin_204	:	(sel == 4'd8)	?	fin_208	:	(sel == 4'd9)	?	fin_212	:	fin_216;
assign	fin_inst4_1		=	(sel == 4'd0)	?	fin_177	:	(sel == 4'd1)	?	fin_181	:	(sel == 4'd2)	?	fin_185	:	(sel == 4'd3)	?	fin_189	:	(sel == 4'd4)	?	fin_193	:	(sel == 4'd5)	?	fin_197	:	(sel == 4'd6)	?	fin_201	:	(sel == 4'd7)	?	fin_205	:	(sel == 4'd8)	?	fin_209	:	(sel == 4'd9)	?	fin_213	:	fin_217;
assign	fin_inst4_2		=	(sel == 4'd0)	?	fin_178	:	(sel == 4'd1)	?	fin_182	:	(sel == 4'd2)	?	fin_186	:	(sel == 4'd3)	?	fin_190	:	(sel == 4'd4)	?	fin_194	:	(sel == 4'd5)	?	fin_198	:	(sel == 4'd6)	?	fin_202	:	(sel == 4'd7)	?	fin_206	:	(sel == 4'd8)	?	fin_210	:	(sel == 4'd9)	?	fin_214	:	fin_218;
assign	fin_inst4_3		=	(sel == 4'd0)	?	fin_179	:	(sel == 4'd1)	?	fin_183	:	(sel == 4'd2)	?	fin_187	:	(sel == 4'd3)	?	fin_191	:	(sel == 4'd4)	?	fin_195	:	(sel == 4'd5)	?	fin_199	:	(sel == 4'd6)	?	fin_203	:	(sel == 4'd7)	?	fin_207	:	(sel == 4'd8)	?	fin_211	:	(sel == 4'd9)	?	fin_215	:	fin_219;
assign	fin_inst4_4		=	(sel == 4'd0)	?	fin_180	:	(sel == 4'd1)	?	fin_184	:	(sel == 4'd2)	?	fin_188	:	(sel == 4'd3)	?	fin_192	:	(sel == 4'd4)	?	fin_196	:	(sel == 4'd5)	?	fin_200	:	(sel == 4'd6)	?	fin_204	:	(sel == 4'd7)	?	fin_208	:	(sel == 4'd8)	?	fin_212	:	(sel == 4'd9)	?	fin_216	:	fin_220;
assign	fin_inst4_5		=	(sel == 4'd0)	?	fin_181	:	(sel == 4'd1)	?	fin_185	:	(sel == 4'd2)	?	fin_189	:	(sel == 4'd3)	?	fin_193	:	(sel == 4'd4)	?	fin_197	:	(sel == 4'd5)	?	fin_201	:	(sel == 4'd6)	?	fin_205	:	(sel == 4'd7)	?	fin_209	:	(sel == 4'd8)	?	fin_213	:	(sel == 4'd9)	?	fin_217	:	fin_221;
assign	fin_inst4_6		=	(sel == 4'd0)	?	fin_182	:	(sel == 4'd1)	?	fin_186	:	(sel == 4'd2)	?	fin_190	:	(sel == 4'd3)	?	fin_194	:	(sel == 4'd4)	?	fin_198	:	(sel == 4'd5)	?	fin_202	:	(sel == 4'd6)	?	fin_206	:	(sel == 4'd7)	?	fin_210	:	(sel == 4'd8)	?	fin_214	:	(sel == 4'd9)	?	fin_218	:	fin_222;
assign	fin_inst4_7		=	(sel == 4'd0)	?	fin_183	:	(sel == 4'd1)	?	fin_187	:	(sel == 4'd2)	?	fin_191	:	(sel == 4'd3)	?	fin_195	:	(sel == 4'd4)	?	fin_199	:	(sel == 4'd5)	?	fin_203	:	(sel == 4'd6)	?	fin_207	:	(sel == 4'd7)	?	fin_211	:	(sel == 4'd8)	?	fin_215	:	(sel == 4'd9)	?	fin_219	:	fin_223;
assign	fin_inst4_8		=	(sel == 4'd0)	?	fin_184	:	(sel == 4'd1)	?	fin_188	:	(sel == 4'd2)	?	fin_192	:	(sel == 4'd3)	?	fin_196	:	(sel == 4'd4)	?	fin_200	:	(sel == 4'd5)	?	fin_204	:	(sel == 4'd6)	?	fin_208	:	(sel == 4'd7)	?	fin_212	:	(sel == 4'd8)	?	fin_216	:	(sel == 4'd9)	?	fin_220	:	fin_224;
assign	fin_inst4_9		=	(sel == 4'd0)	?	fin_185	:	(sel == 4'd1)	?	fin_189	:	(sel == 4'd2)	?	fin_193	:	(sel == 4'd3)	?	fin_197	:	(sel == 4'd4)	?	fin_201	:	(sel == 4'd5)	?	fin_205	:	(sel == 4'd6)	?	fin_209	:	(sel == 4'd7)	?	fin_213	:	(sel == 4'd8)	?	fin_217	:	(sel == 4'd9)	?	fin_221	:	fin_225;
assign	fin_inst4_10	=	(sel == 4'd0)	?	fin_186	:	(sel == 4'd1)	?	fin_190	:	(sel == 4'd2)	?	fin_194	:	(sel == 4'd3)	?	fin_198	:	(sel == 4'd4)	?	fin_202	:	(sel == 4'd5)	?	fin_206	:	(sel == 4'd6)	?	fin_210	:	(sel == 4'd7)	?	fin_214	:	(sel == 4'd8)	?	fin_218	:	(sel == 4'd9)	?	fin_222	:	fin_226;

//	输出特征图的行向量是55个，一次并行执行5个vecMac11模块，那么意味着需要11次运行才能得到一行输出特征向量
vecMac11 U0(
	.aclk		(clk			),
	.rst_n		(rst_n			),
	
	.mac_req	(mac_req    	),
	.fin_req	(fin_req		),
	.wgt_req	(wgt_req		),
	.mac_done	(mac_done		),

	.fin_0		(fin_inst0_0	),
	.fin_1		(fin_inst0_1	),
	.fin_2		(fin_inst0_2	),
	.fin_3		(fin_inst0_3	),
	.fin_4		(fin_inst0_4	),
	.fin_5		(fin_inst0_5	),
	.fin_6		(fin_inst0_6	),
	.fin_7		(fin_inst0_7	),
	.fin_8		(fin_inst0_8	),
	.fin_9		(fin_inst0_9	),
	.fin_10		(fin_inst0_10	),

	.wgt_0		(wgt_0			),
	.wgt_1		(wgt_1			),
	.wgt_2		(wgt_2			),
	.wgt_3		(wgt_3			),
	.wgt_4		(wgt_4			),
	.wgt_5		(wgt_5			),
	.wgt_6		(wgt_6			),
	.wgt_7		(wgt_7			),
	.wgt_8		(wgt_8			),
	.wgt_9		(wgt_9			),
	.wgt_10		(wgt_10			),

	.mac_data	(fout_inst0	)
);

vecMac11 U1(
	.aclk		(clk			),
	.rst_n		(rst_n			),
	
	.mac_req	(mac_req    	),
	.fin_req	(				),
	.wgt_req	(				),
	.mac_done	(				),

	.fin_0		(fin_inst1_0	),
	.fin_1		(fin_inst1_1	),
	.fin_2		(fin_inst1_2	),
	.fin_3		(fin_inst1_3	),
	.fin_4		(fin_inst1_4	),
	.fin_5		(fin_inst1_5	),
	.fin_6		(fin_inst1_6	),
	.fin_7		(fin_inst1_7	),
	.fin_8		(fin_inst1_8	),
	.fin_9		(fin_inst1_9	),
	.fin_10		(fin_inst1_10	),

	.wgt_0		(wgt_0			),
	.wgt_1		(wgt_1			),
	.wgt_2		(wgt_2			),
	.wgt_3		(wgt_3			),
	.wgt_4		(wgt_4			),
	.wgt_5		(wgt_5			),
	.wgt_6		(wgt_6			),
	.wgt_7		(wgt_7			),
	.wgt_8		(wgt_8			),
	.wgt_9		(wgt_9			),
	.wgt_10		(wgt_10			),

	.mac_data	(fout_inst1	)
);

vecMac11 U2(
	.aclk		(clk			),
	.rst_n		(rst_n			),
	
	.mac_req	(mac_req    	),
	.fin_req	(				),
	.wgt_req	(				),
	.mac_done	(				),

	.fin_0		(fin_inst2_0	),
	.fin_1		(fin_inst2_1	),
	.fin_2		(fin_inst2_2	),
	.fin_3		(fin_inst2_3	),
	.fin_4		(fin_inst2_4	),
	.fin_5		(fin_inst2_5	),
	.fin_6		(fin_inst2_6	),
	.fin_7		(fin_inst2_7	),
	.fin_8		(fin_inst2_8	),
	.fin_9		(fin_inst2_9	),
	.fin_10		(fin_inst2_10	),

	.wgt_0		(wgt_0			),
	.wgt_1		(wgt_1			),
	.wgt_2		(wgt_2			),
	.wgt_3		(wgt_3			),
	.wgt_4		(wgt_4			),
	.wgt_5		(wgt_5			),
	.wgt_6		(wgt_6			),
	.wgt_7		(wgt_7			),
	.wgt_8		(wgt_8			),
	.wgt_9		(wgt_9			),
	.wgt_10		(wgt_10			),

	.mac_data	(fout_inst2	)
);

vecMac11 U3(
	.aclk		(clk			),
	.rst_n		(rst_n			),
	
	.mac_req	(mac_req    	),
	.fin_req	(				),
	.wgt_req	(				),
	.mac_done	(				),

	.fin_0		(fin_inst3_0	),
	.fin_1		(fin_inst3_1	),
	.fin_2		(fin_inst3_2	),
	.fin_3		(fin_inst3_3	),
	.fin_4		(fin_inst3_4	),
	.fin_5		(fin_inst3_5	),
	.fin_6		(fin_inst3_6	),
	.fin_7		(fin_inst3_7	),
	.fin_8		(fin_inst3_8	),
	.fin_9		(fin_inst3_9	),
	.fin_10		(fin_inst3_10	),

	.wgt_0		(wgt_0			),
	.wgt_1		(wgt_1			),
	.wgt_2		(wgt_2			),
	.wgt_3		(wgt_3			),
	.wgt_4		(wgt_4			),
	.wgt_5		(wgt_5			),
	.wgt_6		(wgt_6			),
	.wgt_7		(wgt_7			),
	.wgt_8		(wgt_8			),
	.wgt_9		(wgt_9			),
	.wgt_10		(wgt_10			),

	.mac_data	(fout_inst3	)
);

vecMac11 U4(
	.aclk		(clk			),
	.rst_n		(rst_n			),
	
	.mac_req	(mac_req    	),
	.fin_req	(				),
	.wgt_req	(				),
	.mac_done	(				),

	.fin_0		(fin_inst4_0	),
	.fin_1		(fin_inst4_1	),
	.fin_2		(fin_inst4_2	),
	.fin_3		(fin_inst4_3	),
	.fin_4		(fin_inst4_4	),
	.fin_5		(fin_inst4_5	),
	.fin_6		(fin_inst4_6	),
	.fin_7		(fin_inst4_7	),
	.fin_8		(fin_inst4_8	),
	.fin_9		(fin_inst4_9	),
	.fin_10		(fin_inst4_10	),

	.wgt_0		(wgt_0			),
	.wgt_1		(wgt_1			),
	.wgt_2		(wgt_2			),
	.wgt_3		(wgt_3			),
	.wgt_4		(wgt_4			),
	.wgt_5		(wgt_5			),
	.wgt_6		(wgt_6			),
	.wgt_7		(wgt_7			),
	.wgt_8		(wgt_8			),
	.wgt_9		(wgt_9			),
	.wgt_10		(wgt_10			),

	.mac_data	(fout_inst4	)
);

endmodule