/*
	时间：			2023.10.07
	功能：			将8个bram_32_52的IP拼接为1个bram_256_512
	
	版本：			1.0
	
	时序：			① 
	
	功能限制部分：	① 	wea为1是写，wea为0是读，因此在一个时刻只能进行读或者写的一种
					② 	为了方便，把输入特征图的宽度改为8的整数倍，这样原本227宽度变成了232宽度，意味着一行有29 *8个像素点，
						那么这里的bram可以存放512 / 29 = 17行
						
	
	可改进的方向：	①	一个bram_32_512本身就可以存放2行多的fin数据，此处调用了8个bram_32_512，因此如何更高效地利用存储空间很重要
	
	修改：			① 
	
	修改意图：		①
*/
module bram_256_512 (
	input   		        	clka    	,
	input   		        	wea     	,
	input   		[8:0]   	addra   	,		//	写地址的LSB是对于256bit而言的
	input   		[255:0] 	dina    	,
	
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
	output  		[255:0] 	doutb 	
	
);

bram_32_512 bram_inst0 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[31:0]   	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_0	  	),
    .doutb	(doutb[31:0]	)
);


bram_32_512 bram_inst1 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[63:32]   	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_1       	),
    .doutb	(doutb[63:32]	)
);


bram_32_512 bram_inst2 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[95:64]   	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_2       	),
    .doutb	(doutb[95:64]	)
);


bram_32_512 bram_inst3 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[127:96]   ),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_3       	),
    .doutb	(doutb[127:96]	)
);


bram_32_512 bram_inst4 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[159:128] 	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_4       	),
    .doutb	(doutb[159:128]	)
);


bram_32_512 bram_inst5 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[191:160] 	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_5       	),
    .doutb	(doutb[191:160]	)
);


bram_32_512 bram_inst6 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[223:192] 	),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_6       	),
    .doutb	(doutb[223:192]	)
);


bram_32_512 bram_inst7 (
    .clka 	(clka         	),
    .wea  	(wea          	),
    .addra	(addra        	),
    .dina 	(dina[255:224]  ),
    .clkb 	(clkb         	),
    .rstb 	(rstb         	),
    .addrb	(addrb_7       	),
    .doutb	(doutb[255:224]	)
);
endmodule