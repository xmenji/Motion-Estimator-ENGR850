`timescale 1ns/10ps
module timeunit;
   initial $timeformat(-9,1," ns",9);
endmodule

module toplevel_testbench_op ( ) ;
   wire[3:0] 		  motionx;
   wire[3:0] 		  motiony;
   wire[7:0]		  AddressR;
   wire[9:0]		  AddressS1;
   wire[9:0]          AddressS2;
	

   reg               clock;
   reg               start;
   reg[7:0]          R;
   reg[7:0]          s1;
   reg[7:0]          s2;
   reg[7:0]	     R_mem[255:0];
   reg[7:0]	     s1_mem[960:0];	
   reg[7:0]	     s2_mem[960:0];
   integer i,j;
   
   always #10 clock = ~clock;



   initial
     begin


   $readmemh("rmem_data.hex",R_mem);
   $readmemh("smem_data.hex", s1_mem);
   $readmemh("smem_data.hex", s2_mem);    


   assign R= 	R_mem[AddressR]	;
   assign s1=   s1_mem[AddressS1];
   assign s2=   s2_mem[AddressS2];
       
        clock = 1'b0;             
        start = 1'b0; 
	

        @(posedge clock);
        #1 start= 1'b1;   
         
        #83320	         
        $finish;
     end

topmodule dut (
		.motionx	       (motionx[3:0]),
		.motiony	       (motiony[3:0]),
                
        .start		       (start),
        .clock                 (clock),
		.R		       (R[7:0]),
		.s1		       (s1[7:0]),
		.s2                    (s2[7:0]),
		.AddressR              (AddressR[7:0]),
		.AddressS1	       (AddressS1[9:0]),
		.AddressS2	       (AddressS2[9:0]));
endmodule
