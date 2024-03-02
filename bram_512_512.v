/*
	时间：			2023.10.12
	功能：			将16个bram_32_52的IP拼接为1个bram_512_512
	
	版本：			1.0
	
	时序：			① 	只要addra与addrb_x不一样，那么读写就可以同时进行
	
	功能限制部分：	① 	wea为1是写，wea为0是读，因此在一个时刻只能进行读或者写的一种
						
	
	可改进的方向：	①	一个bram_32_512本身就可以存放2行多的fin数据，此处调用了8个bram_32_512，因此如何更高效地利用存储空间很重要
	
	修改：			① 
	
	修改意图：		①
*/
module bram_512_512 (
	input   		        	clka    	,
	input   		        	wea     	,
	input   		[8:0]   	addra   	,		//	写地址的LSB是对于512bit而言的
	input   		[511:0] 	dina    	,
	
	input   		        	clkb    	,		//	这样写的好处是读端口可以进行精细控制
	input   		        	rstb    	,
	input   		[8:0]   	addrb_0 	,
	input   		[8:0]   	addrb_1 	,
	input   		[8:0]   	addrb_2 	,
	input   		[8:0]   	addrb_3 	,
	input   		[8:0]   	addrb_4 	,
	input   		[8:0]   	addrb_5 	,
	input   		[8:0]   	addrb_6 	,
	input   		[8:0]   	addrb_7 	,
	input   		[8:0]   	addrb_8 	,
	input   		[8:0]   	addrb_9 	,
	input   		[8:0]   	addrb_10 	,
	input   		[8:0]   	addrb_11 	,
	input   		[8:0]   	addrb_12 	,
	input   		[8:0]   	addrb_13 	,
	input   		[8:0]   	addrb_14 	,
	input   		[8:0]   	addrb_15 	,
	output  		[511:0] 	doutb 	
	
);

bram_32_512 bram_inst0 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[31:0]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_0       	),
    .doutb	(doutb[31:0]	)
);

bram_32_512 bram_inst1 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[63:32]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_1       	),
    .doutb	(doutb[63:32]	)
);

bram_32_512 bram_inst2 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[95:64]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_2       	),
    .doutb	(doutb[95:64]	)
);

bram_32_512 bram_inst3 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[127:96]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_3       	),
    .doutb	(doutb[127:96]	)
);

bram_32_512 bram_inst4 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[159:128]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_4       	),
    .doutb	(doutb[159:128]	)
);

bram_32_512 bram_inst5 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[191:160]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_5       	),
    .doutb	(doutb[191:160]	)
);

bram_32_512 bram_inst6 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[223:192]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_6       	),
    .doutb	(doutb[223:192]	)
);

bram_32_512 bram_inst7 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[255:224]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_7       	),
    .doutb	(doutb[255:224]	)
);

bram_32_512 bram_inst8 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[287:256]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_8       	),
    .doutb	(doutb[287:256]	)
);

bram_32_512 bram_inst9 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[319:288]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_9       	),
    .doutb	(doutb[319:288]	)
);

bram_32_512 bram_inst10 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[351:320]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_10       	),
    .doutb	(doutb[351:320]	)
);

bram_32_512 bram_inst11 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[383:352]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_11       	),
    .doutb	(doutb[383:352]	)
);

bram_32_512 bram_inst12 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[415:384]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_12       	),
    .doutb	(doutb[415:384]	)
);

bram_32_512 bram_inst13 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[447:416]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_13       	),
    .doutb	(doutb[447:416]	)
);

bram_32_512 bram_inst14 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[479:448]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_14       	),
    .doutb	(doutb[479:448]	)
);

bram_32_512 bram_inst15 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[511:480]	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_15       	),
    .doutb	(doutb[511:480]	)
);


endmodule