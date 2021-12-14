interface mem_intf(input logic clk, start);
    logic[7:0]      R_mem[255:0];
    logic[7:0]      s_mem[1023:0]; 
  logic[3:0]      motionX;
  logic[3:0]      motionY;
  integer expected_motionX;
  integer expected_motionY;
    logic[7:0]      AddressR;
    logic[9:0]      AddressS1;
    logic[9:0]      AddressS2;
    logic[7:0]      R;
    logic[7:0]      s1;
    logic[7:0]      s2;
  logic [7:0]		BestDist;
  	logic 			completed;

  
  always@(*) begin
    R=   R_mem[AddressR];
    s1=   s_mem[AddressS1];
    s2=   s_mem[AddressS2];
  end
   

   clocking driver_cb @(posedge clk);
    default input #1 output #1;
     output R_mem;
     output s_mem;
     output R;
     output s1;
     output s2;
     output expected_motionX;
     output expected_motionY;
     input BestDist;
     input motionX, motionY;
     input AddressR;
     input AddressS1;
     input AddressS2;
     input completed;
  endclocking
  
  clocking monitor_cb @(posedge clk);
    default input #1 output #1;
     input R_mem;
     input s_mem;
     input R;
     input s1;
     input s2;
     input expected_motionX;
     input expected_motionY;
     input motionX, motionY;
     input AddressR;
     input AddressS1;
     input AddressS2;
     input completed;
     input BestDist;
  endclocking
  
  modport DRIVER  (clocking driver_cb, input clk, start);
  

    modport MONITOR (clocking monitor_cb, input clk, start);
  
endinterface