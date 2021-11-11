interface motion_estimator_intf(
 input clk);
 logic start;
 logic [7:0] R;
 logic [7:0] S1;
 logic [7:0] S2;
 wire  [3:0] MotionX;
 wire  [3:0] MotionY;
 wire  [7:0] AddressR;
 wire  [9:0] AddressS1;
 wire  [9:0] AddressS2;
 endinterface
