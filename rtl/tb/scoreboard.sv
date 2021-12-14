class scoreboard;
  
  mailbox mon2scb; 
  
  int no_transactions, j;
  
  //some local memory, needs to be modified
  integer motionX, motionY;
  integer bestDist;
  integer latestDist, currentFrame;
  integer refCount;
  
  function new(mailbox mon2scb);
    this.mon2scb = mon2scb; 
  endfunction
  
  
  task main;
    Transaction trans; 
    $display("scb main");     
    forever begin
      mon2scb.get(trans);
      $display("In Scoreboard: Expected x: %d, Expected y: %d", trans.expected_motionX, trans.expected_motionY);
      /*
      $display("[SCOREBOARD] ----- Printing Values in Monitor -----");
             for(j = 0; j < 256; j++)begin
         if(j%16 == 0) $display("  ");
         $write("%h ", trans.R_mem[j]);
         if(j == 255) $display("  ");
             end
      
             for(j = 0; j < 1024; j++)begin
         if(j%32 == 0) $display("  ");
         $write("%h  ",trans.s_mem[j]);
         if(j == 1023) $display("  "); 
       end*/
      
      
      
      
      /* details to self-checking algorithm */ 
    bestDist = 8'hff;
    latestDist = 0;
    currentFrame = 0;
    refCount = 0;
    for(int y = 0; y < 16; y++) begin
      for(int x = 0; x < 16; x++) begin
        latestDist = 0;
        currentFrame = 0;
        refCount = 0;
        //$display("x: %0h and y: %0h", x, y); 
        for(int i = y; i < y+16; i++)begin
          for(int j = x; j < x+16; j++) begin
            currentFrame = trans.R_mem[refCount] - trans.s_mem[(i*32)+j];
            refCount++;
            if(currentFrame<0) latestDist-=currentFrame;
            else latestDist+=currentFrame;
            
          end
          if(latestDist > 8'hff) break;
        end //end of inner nested loop
        if(latestDist < bestDist) begin
          bestDist = latestDist;
          motionX = x;
          motionY = y;
        end //end of if
        
      end 
    end //end of outer nested loop

      // might need to change these numbers
    motionX = motionX - 8;
    motionY = motionY - 8;
      
      if(motionX == trans.motionX && motionY == trans.motionY) 
        $display("Result is correct. Expected X: %0d | Y: %0d. Actual X: %0d | Y: %0d ", motionX, motionY, trans.motionX, trans.motionY); 
      else
        $display("Result is not correct. Expected X: %d | Y: %d. Actual X: %d | Y: %d", motionX, motionY, trans.motionX, trans.motionY); 
            
      no_transactions++;
      $display("no_transactions in scoreboard: %d", no_transactions);
    end
  endtask
  
endclass
