
`include "interface.sv"
`include "random_test.sv"
`timescale 1ns/10ps
//module timeunit;
//   initial $timeformat(-9,1," ns",9);
//endmodule

module top_tb();
    bit               clk;
    bit               start;
   
  

   always #10 clk = ~clk;
  
  initial begin 
    $display("Starting TB");
    start = 1'b0;
    @(negedge clk);
    
    start = 1'b1;
  end
  
    mem_intf intf(clk, start);
 
  test t1(intf);

  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end

  /*
topmodule dut (
  .motionx         (intf.motionX),
  .motiony         (intf.motionY),
                
  .start           (intf.start),
  .clock                 (intf.clk),
  .R           (intf.R),
  .s1          (intf.s1),
  .s2                    (intf.s2),
  .AddressR              (intf.AddressR),
  .AddressS1         (intf.AddressS1),
  .AddressS2         (intf.AddressS2),
  .completed(intf.completed)
);*/
  
  
  top dut(
    .clock(intf.clk), 
    .start(intf.start), 
    .BestDist(intf.BestDist), 
    .motionX(intf.motionX), 
    .motionY(intf.motionY), 
    .AddressR(intf.AddressR), 
    .AddressS1(intf.AddressS1), 
    .AddressS2(intf.AddressS2), 
    .R(intf.R), 
    .S1(intf.s1), 
    .S2(intf.s2), 
    .completed(intf.completed));

 
endmodule
