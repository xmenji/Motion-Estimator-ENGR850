module Comparator(clock,CompStart,PEout,PEready,vectorX,vectorY,BestDist,motionX,motionY, pflag);
input clock;
input CompStart;
input [8*16-1:0] PEout;
input [3:0] PEready;
input [3:0] vectorX,vectorY;
input pflag;
output [7:0] BestDist;
output [3:0] motionX,motionY;
reg [7:0] BestDist,newDist;
reg [3:0] motionX,motionY ;
reg newBest;
reg [8*16-1:0] tempPEout;

always@(posedge clock)
  if(CompStart==0) BestDist<=8'hff;
  else if(newBest==1)
  begin
     BestDist<=newDist;
     motionX<=vectorX;
     motionY<=vectorY;
  end

always@(posedge clock)
	if(pflag == 1) tempPEout[127:0] <= PEout[127:0] ;
		

  
always@(BestDist or tempPEout or PEready)
begin
  //newDist=PEout [PEready*8+7:PEready*8];


       case(PEready)
         
         4'd0: newDist=tempPEout[7:0];
                    
         4'd1: newDist=tempPEout[15:8];
                    
         4'd2: newDist=tempPEout[23:16];
                              
         4'd3: newDist=tempPEout[31:24];
                              
         4'd4: newDist=tempPEout[39:32];
                    
         4'd5: newDist=tempPEout[47:40];
                   
         4'd6: newDist=tempPEout[55:48];
                    
         4'd7: newDist=tempPEout[63:56];
                    
         4'd8: newDist=tempPEout[71:64];
                    
         4'd9: newDist=tempPEout[79:72];
                    
         4'd10: newDist=tempPEout[87:80];
                    
         4'd11: newDist=tempPEout[95:88];
                    
         4'd12: newDist=tempPEout[103:96];
                    
         4'd13: newDist=tempPEout[111:104];
                    
         4'd14: newDist=tempPEout[119:112];
                    
         4'd15: newDist=tempPEout[127:120];
                    
                        
         endcase                       
       //if((!PEready==0) || (CompStart==0)) newBest=0; 
	   if( (CompStart==0)) newBest=0;
    else if (newDist<BestDist) newBest=1;
else newBest=0;
end
endmodule    
