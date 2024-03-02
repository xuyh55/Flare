`timescale 1ns/100ps
module tb_bram ();
reg  		        	clka    	;
reg  		        	wea     	;
reg  		[8:0]   	addra   	;		
reg  		[511:0] 	dina    	;

reg  		        	rstb    	;
reg  		[8:0]   	addrb_0 	;
wire  		[511:0] 	doutb 	    ;


initial
begin
	clka 			= 0;
	wea            	= 1;
	addra          	= 0;
	dina           	= 0;
	
	rstb           	= 1;
	addrb_0        	= 0;
	
	#100
	rstb = 0;
	
	#10005
	rstb = 1;
	wea = 0;

	#100
	rstb = 0;
	//wea = 1;
end

always #5 clka = ~clka;

reg clkb = 0;
always @(*) clkb =  clka;

always @(posedge clka)
begin
	addra <= addra + 1;
	dina <= dina + 1;
end

always @(posedge clka)
begin
	if (rstb)
		addrb_0 <= 0;
	else 
		addrb_0 <= addrb_0 + 1;
end

bram_512_512 u0 (
    .clka 		(clka                       				),
    .wea  		(wea				),
    .addra		(addra         	),
    .dina 		(dina               				),
			
    .clkb 		(clkb                        				),
	.rstb		(rstb),
    .addrb_0 	(addrb_0                				),
    .addrb_1 	(addrb_0                				),
    .addrb_2 	(addrb_0                				),
    .addrb_3 	(addrb_0                				),
    .addrb_4 	(addrb_0                				),
    .addrb_5 	(addrb_0                				),
    .addrb_6 	(addrb_0                				),
    .addrb_7 	(addrb_0                				),
    .addrb_8 	(addrb_0                				),
    .addrb_9 	(addrb_0                				),
    .addrb_10	(addrb_0                				),
    .addrb_11	(addrb_0                				),
    .addrb_12	(addrb_0                				),
    .addrb_13	(addrb_0                				),
    .addrb_14	(addrb_0                				),
    .addrb_15	(addrb_0                				),
    .doutb		(doutb                				)
);

endmodule