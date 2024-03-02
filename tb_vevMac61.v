`timescale 1ns/100ps
module tb_vecMac61 ();
	
reg								aclk		;
reg								rst_n		;

wire								fin_req		;
wire								wgt_req		;

reg [31:0] fin [60:0];

initial
begin
	fin[0] = 32'h3E865E20;
	fin[1] = 32'h3E350E7D;
	fin[2] = 32'h3E238556;
	fin[3] = 32'h3E7B3318;
	fin[4] = 32'h3E97E746;
	fin[5] = 32'h3E865E20;
	fin[6] = 32'h3E5820CB;
	fin[7] = 32'h3E69A9F1;
	fin[8] = 32'h3E4697A4;
	fin[9] = 32'h3E5820CB;
	fin[10] = 32'h3E5820CB;
	fin[11] = 32'h3E8F22B3;
	fin[12] = 32'h3E4697A4;
	fin[13] = 32'h3E350E7D;
	fin[14] = 32'h3E7B3318;
	fin[15] = 32'h3E8F22B3;
	fin[16] = 32'h3E5820CB;
	fin[17] = 32'h3E350E7D;
	fin[18] = 32'h3E350E7D;
	fin[19] = 32'h3E5820CB;
	fin[20] = 32'h3E5820CB;
	fin[21] = 32'h3E69A9F1;
	fin[22] = 32'h3E8F22B3;
	fin[23] = 32'h3E5820CB;
	fin[24] = 32'h3E350E7D;
	fin[25] = 32'h3E69A9F1;
	fin[26] = 32'h3E7B3318;
	fin[27] = 32'h3E238556;
	fin[28] = 32'h3E007309;
	fin[29] = 32'h3E007309;
	fin[30] = 32'h3E4697A4;
	fin[31] = 32'h3E69A9F1;
	fin[32] = 32'h3E7B3318;
	fin[33] = 32'h3E69A9F1;
	fin[34] = 32'h3E350E7D;
	fin[35] = 32'h3E350E7D;
	fin[36] = 32'h3E69A9F1;
	fin[37] = 32'h3E5820CB;
	fin[38] = 32'h3E11FC30;
	fin[39] = 32'h3DDDD3C4;
	fin[40] = 32'h3E11FC30;
	fin[41] = 32'h3E350E7D;
	fin[42] = 32'h3E5820CB;
	fin[43] = 32'h3E7B3318;
	fin[44] = 32'h3E350E7D;
	fin[45] = 32'h3E11FC30;
	fin[46] = 32'h3E238556;
	fin[47] = 32'h3E5820CB;
	fin[48] = 32'h3E5820CB;
	fin[49] = 32'h3E11FC30;
	fin[50] = 32'h3E11FC30;
	fin[51] = 32'h3E4697A4;
	fin[52] = 32'h3E238556;
	fin[53] = 32'h3E350E7D;
	fin[54] = 32'h3E5820CB;
	fin[55] = 32'h3E11FC30;
	fin[56] = 32'h3E007309;
	fin[57] = 32'h3E238556;
	fin[58] = 32'h3E69A9F1;
	fin[59] = 32'h3E5820CB;
	fin[60] = 32'h3E11FC30;
end

reg [31:0] wgt [362:0];

initial
begin
	wgt[0] = 32'h3DF2F956;
	wgt[1] = 32'h3DC0A715;
	wgt[2] = 32'h3DC37387;
	wgt[3] = 32'h3DD7593A;
	wgt[4] = 32'h3DD2C28A;
	wgt[5] = 32'h3D89ACF2;
	wgt[6] = 32'h3D4EB546;
	wgt[7] = 32'h3D4D4F9E;
	wgt[8] = 32'h3D64A5BE;
	wgt[9] = 32'h3CB0BE90;
	wgt[10] = 32'h3D4CA5E9;
	wgt[11] = 32'h3D995BF4;
	wgt[12] = 32'h3D1F8002;
	wgt[13] = 32'h3D590055;
	wgt[14] = 32'h3D9B8E10;
	wgt[15] = 32'h3D940AE3;
	wgt[16] = 32'h3D954EC9;
	wgt[17] = 32'h3D550EEC;
	wgt[18] = 32'h3CDE1F60;
	wgt[19] = 32'h3CD29B81;
	wgt[20] = 32'hBC391EA6;
	wgt[21] = 32'h3B8847D0;
	wgt[22] = 32'h3D9A7859;
	wgt[23] = 32'h3D1ED643;
	wgt[24] = 32'h3D60FEC9;
	wgt[25] = 32'h3D649652;
	wgt[26] = 32'h3D573796;
	wgt[27] = 32'h3D4CE240;
	wgt[28] = 32'h3D43177B;
	wgt[29] = 32'h3CCF2374;
	wgt[30] = 32'h3D3291E7;
	wgt[31] = 32'h3C278671;
	wgt[32] = 32'h3C591918;
	wgt[33] = 32'h3D903865;
	wgt[34] = 32'h3D5714E1;
	wgt[35] = 32'h3D8137FC;
	wgt[36] = 32'h3D7E941D;
	wgt[37] = 32'h3D712810;
	wgt[38] = 32'h3D1DFFDD;
	wgt[39] = 32'h3D387764;
	wgt[40] = 32'h3D1C2CA9;
	wgt[41] = 32'h3D3B7C10;
	wgt[42] = 32'h3AFBD05D;
	wgt[43] = 32'h3B4233EC;
	wgt[44] = 32'h3DB2D220;
	wgt[45] = 32'h3D998C08;
	wgt[46] = 32'h3D92B0FF;
	wgt[47] = 32'h3DAAE6F5;
	wgt[48] = 32'h3DC1A5D6;
	wgt[49] = 32'h3D85F306;
	wgt[50] = 32'h3D09586D;
	wgt[51] = 32'h3CAC5A1A;
	wgt[52] = 32'h3CB4B810;
	wgt[53] = 32'hBC2E6B65;
	wgt[54] = 32'hBD0C67FA;
	wgt[55] = 32'h3DC44493;
	wgt[56] = 32'h3DCB4105;
	wgt[57] = 32'h3DCDF57F;
	wgt[58] = 32'h3DDEC9C1;
	wgt[59] = 32'h3D94A853;
	wgt[60] = 32'h3D13C545;
end
	
initial
begin
	aclk = 0;
	rst_n = 0;
	
	#100
	rst_n = 1;
end

always #3.333 aclk = ~aclk;

vecMac61 u0 (
	.aclk		(aclk),		
	.rst_n		(rst_n),
	
	.mac_req		(wgt_req && fin_req && rst_n),	
	.wgt_req		(wgt_req),	
	.fin_req		(fin_req),
	
	.fin_0		(fin[0]		),
	.wgt_0		(wgt[0]		),
	.fin_1		(fin[1]		),
	.wgt_1		(wgt[1]		),
	.fin_2		(fin[2]		),
	.wgt_2		(wgt[2]		),
	.fin_3		(fin[3]		),
	.wgt_3		(wgt[3]		),
	.fin_4		(fin[4]		),
	.wgt_4		(wgt[4]		),
	.fin_5		(fin[5]		),
	.wgt_5		(wgt[5]		),
	.fin_6		(fin[6]		),
	.wgt_6		(wgt[6]		),
	.fin_7		(fin[7]		),
	.wgt_7		(wgt[7]		),
	.fin_8		(fin[8]		),
	.wgt_8		(wgt[8]		),
	.fin_9		(fin[9]		),
	.wgt_9		(wgt[9]		),
	.fin_10		(fin[10]		),
	.wgt_10		(wgt[10]		),
	.fin_11		(fin[11]		),
	.wgt_11		(wgt[11]		),
	.fin_12		(fin[12]		),
	.wgt_12		(wgt[12]		),
	.fin_13		(fin[13]		),
	.wgt_13		(wgt[13]		),
	.fin_14		(fin[14]		),
	.wgt_14		(wgt[14]		),
	.fin_15		(fin[15]		),
	.wgt_15		(wgt[15]		),
	.fin_16		(fin[16]		),
	.wgt_16		(wgt[16]		),
	.fin_17		(fin[17]		),
	.wgt_17		(wgt[17]		),
	.fin_18		(fin[18]		),
	.wgt_18		(wgt[18]		),
	.fin_19		(fin[19]		),
	.wgt_19		(wgt[19]		),
	.fin_20		(fin[20]		),
	.wgt_20		(wgt[20]		),
	.fin_21		(fin[21]		),
	.wgt_21		(wgt[21]		),
	.fin_22		(fin[22]		),
	.wgt_22		(wgt[22]		),
	.fin_23		(fin[23]		),
	.wgt_23		(wgt[23]		),
	.fin_24		(fin[24]		),
	.wgt_24		(wgt[24]		),
	.fin_25		(fin[25]		),
	.wgt_25		(wgt[25]		),
	.fin_26		(fin[26]		),
	.wgt_26		(wgt[26]		),
	.fin_27		(fin[27]		),
	.wgt_27		(wgt[27]		),
	.fin_28		(fin[28]		),
	.wgt_28		(wgt[28]		),
	.fin_29		(fin[29]		),
	.wgt_29		(wgt[29]		),
	.fin_30		(fin[30]		),
	.wgt_30		(wgt[30]		),
	.fin_31		(fin[31]		),
	.wgt_31		(wgt[31]		),
	.fin_32		(fin[32]		),
	.wgt_32		(wgt[32]		),
	.fin_33		(fin[33]		),
	.wgt_33		(wgt[33]		),
	.fin_34		(fin[34]		),
	.wgt_34		(wgt[34]		),
	.fin_35		(fin[35]		),
	.wgt_35		(wgt[35]		),
	.fin_36		(fin[36]		),
	.wgt_36		(wgt[36]		),
	.fin_37		(fin[37]		),
	.wgt_37		(wgt[37]		),
	.fin_38		(fin[38]		),
	.wgt_38		(wgt[38]		),
	.fin_39		(fin[39]		),
	.wgt_39		(wgt[39]		),
	.fin_40		(fin[40]		),
	.wgt_40		(wgt[40]		),
	.fin_41		(fin[41]		),
	.wgt_41		(wgt[41]		),
	.fin_42		(fin[42]		),
	.wgt_42		(wgt[42]		),
	.fin_43		(fin[43]		),
	.wgt_43		(wgt[43]		),
	.fin_44		(fin[44]		),
	.wgt_44		(wgt[44]		),
	.fin_45		(fin[45]		),
	.wgt_45		(wgt[45]		),
	.fin_46		(fin[46]		),
	.wgt_46		(wgt[46]		),
	.fin_47		(fin[47]		),
	.wgt_47		(wgt[47]		),
	.fin_48		(fin[48]		),
	.wgt_48		(wgt[48]		),
	.fin_49		(fin[49]		),
	.wgt_49		(wgt[49]		),
	.fin_50		(fin[50]		),
	.wgt_50		(wgt[50]		),
	.fin_51		(fin[51]		),
	.wgt_51		(wgt[51]		),
	.fin_52		(fin[52]		),
	.wgt_52		(wgt[52]		),
	.fin_53		(fin[53]		),
	.wgt_53		(wgt[53]		),
	.fin_54		(fin[54]		),
	.wgt_54		(wgt[54]		),
	.fin_55		(fin[55]		),
	.wgt_55		(wgt[55]		),
	.fin_56		(fin[56]		),
	.wgt_56		(wgt[56]		),
	.fin_57		(fin[57]		),
	.wgt_57		(wgt[57]		),
	.fin_58		(fin[58]		),
	.wgt_58		(wgt[58]		),
	.fin_59		(fin[59]		),
	.wgt_59		(wgt[59]		),
	.fin_60		(fin[60]		),
	.wgt_60		(wgt[60]		)
);

endmodule