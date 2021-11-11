`timescale 1ns/1ps
module motion_estimator_tb_top();
import uvm_pkg::*;
import motion_estimator_test_pkg::*; 

//import axi_master_env_pkg::*;
bit  clk;
//========clock generation===========
parameter CLOCK_PERIOD = 4; //Time period of clock . (Frequency 500MHZ) = 4ns
parameter DUTY_CYCLE = 50; //50% duty cycle
parameter CLOCK_HI = (CLOCK_PERIOD*DUTY_CYCLE/100);
parameter CLOCK_LO = (CLOCK_PERIOD-CLOCK_HI);

initial
forever begin//{ 
#CLOCK_LO;
clk = 1'b0;
#CLOCK_HI;
clk = 1'b1;
end//}

//=====interface instance generation===============
motion_estimator_intf vif(clk);

topmodule dut(.clock(vif.clk) ,
                     .start(vif.start) ,
                     .R(vif.R) ,
                     .s1(vif.S1) ,
                     .s2(vif.S2) ,
                     .motionx(vif.MotionX) , 
                     .motiony(vif.MotionY) ,
		     .AddressR(vif.AddressR),
		     .AddressS1(vif.AddressS1),
		     .AddressS2(vif.AddressS2)
                     );
//==============set the interface===================
initial
begin
uvm_config_db#(virtual motion_estimator_intf)::set(null,"","vif",vif);
run_test();
end
initial
begin
 $vcdplusmemon();
 $vcdpluson();
 $vcdplusfile("top.vpd");
end
endmodule
