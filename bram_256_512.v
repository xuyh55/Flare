/*
	ʱ�䣺			2023.10.07
	���ܣ�			��8��bram_32_52��IPƴ��Ϊ1��bram_256_512
	
	�汾��			1.0
	
	ʱ��			�� 
	
	�������Ʋ��֣�	�� 	weaΪ1��д��weaΪ0�Ƕ��������һ��ʱ��ֻ�ܽ��ж�����д��һ��
					�� 	Ϊ�˷��㣬����������ͼ�Ŀ�ȸ�Ϊ8��������������ԭ��227��ȱ����232��ȣ���ζ��һ����29 *8�����ص㣬
						��ô�����bram���Դ��512 / 29 = 17��
						
	
	�ɸĽ��ķ���	��	һ��bram_32_512����Ϳ��Դ��2�ж��fin���ݣ��˴�������8��bram_32_512�������θ���Ч�����ô洢�ռ����Ҫ
	
	�޸ģ�			�� 
	
	�޸���ͼ��		��
*/
module bram_256_512 (
	input   		        	clka    	,
	input   		        	wea     	,
	input   		[8:0]   	addra   	,		//	д��ַ��LSB�Ƕ���256bit���Ե�
	input   		[255:0] 	dina    	,
	
	input   		        	clkb    	,		//	����д�ĺô��Ƕ��˿ڿ��Խ��о�ϸ����
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