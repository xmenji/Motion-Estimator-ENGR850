module control (clock,start,S1S2mux,NewDist,CompStart,PEready,VectorX,VectorY, AddressR,AddressS1,AddressS2, pflag);
input clock;
input start;
output [15:0] S1S2mux;
output  [15:0] NewDist ;
output CompStart;
output reg [3:0] PEready;
output [3:0] VectorX,VectorY;
output [7:0] AddressR;
output [9:0] AddressS1,AddressS2;
output pflag;
reg pflag;
reg [15:0] S1S2mux;
reg [15:0] NewDist;
reg CompStart;
reg [15:0] PEready_; 
reg [3:0] VectorX,VectorY;
reg [7:0] AddressR;
reg [9:0] AddressS1,AddressS2;
reg [12:0] count;
reg completed;
reg [11:0] temp;
reg [3:0] j;
integer i;


always@(posedge clock) begin
  if(start ==0) 
    count <= 12'b0;
  else if (completed==0) 
   begin
      count<=count+1'b1;
   end

       
end
  
always@(count) begin
  j=0;
  for(i=0;i<16;i=i+1) begin
          	NewDist[i]=(count[7:0]==i);
          	PEready_[i]=(NewDist[i] && !(count<256));
                
		if(PEready_[i] && j<2) begin 
			j=j+1;
		end
		PEready=0;
		case(PEready_)
		16'h0:PEready     =  'd0;
		16'h1:PEready     =  'd1;
		16'h2:PEready     =  'd2;
		16'h4:PEready     =  'd3;
		16'h8:PEready     =  'd4;
		16'h10:PEready    =  'd5;
		16'h20:PEready    =  'd6;
		16'h40:PEready    =  'd7;
		16'h80:PEready    =  'd8;
		16'h100:PEready   =  'd9;
		16'h200:PEready   =  'd10;
		16'h400:PEready   =  'd11;
		16'h800:PEready   =  'd12;
		16'h1000:PEready  =  'd13;
		16'h2000:PEready  =  'd14;
		16'h4000:PEready  =  'd15;
		16'h8000: PEready =  'd16;
		default :PEready  =  'd0;
		//if(j==1) PEready=i;  
		//if(PEready_==0) PEready = 0;          	
		endcase
                S1S2mux[i]=(count[3:0] >= i);
	      	CompStart = (!(count<256));

		if( (count % 255)==0 ) 
			pflag = 1;
		else
			pflag = 0;		
   end
 
      AddressR = count[7:0];
      AddressS1 = (count[11:8] + count[7:4])*32 +count[3:0];
      
      temp = count[11:0]-16;
      AddressS2 = (temp[11:8] + temp[7:4])*32 + temp[3:0] + 16;
 
      VectorX = count[3:0] - 8;
      VectorY = count[11:8] - 8;
      completed=(count == 4111); 
end

      
endmodule
