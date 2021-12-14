//-------------------------------------------------------------------------
//                        www.verificationguide.com
//-------------------------------------------------------------------------
//Samples the interface signals, captures into transaction packet and send the packet to scoreboard.

`define MON_IF mem_vif.MONITOR.monitor_cb
class monitor;
  int j;
  //creating virtual interface handle
  virtual mem_intf mem_vif;
  
  //creating mailbox handle
  mailbox mon2scb;
  
  //constructor
  function new(virtual mem_intf mem_vif,mailbox mon2scb);
    //getting the interface
    this.mem_vif = mem_vif;
    //getting the mailbox handles from  environment 
    this.mon2scb = mon2scb;
  endfunction
  
  //Samples the interface signal and send the sample packet to scoreboard
  task main;
    $display("Monitor main");
    forever begin
      Transaction trans;
      trans = new();

      @(posedge mem_vif.MONITOR.clk);
      wait(mem_vif.start ==1);
      @(posedge mem_vif.MONITOR.clk);
      $display("----- [MONITOR] Putting values into Transaction -----");
      	trans.R_mem  = `MON_IF.R_mem;
      	trans.s_mem = `MON_IF.s_mem;
      @(posedge mem_vif.MONITOR.clk);
      	trans.expected_motionX = `MON_IF.expected_motionX;
      	trans.expected_motionY = `MON_IF.expected_motionY;

     wait(`MON_IF.completed);
      $display("[MONITOR] COMPLETED");
      trans.motionX = `MON_IF.motionX;
      trans.motionY = `MON_IF.motionY;

      if(trans.motionX >= 8)
         	trans.motionX = trans.motionX - 16;
       else
       		trans.motionX = trans.motionX;
      if(trans.motionY >= 8)
        	trans.motionY = trans.motionY - 16;
       else
       		trans.motionY = trans.motionY;
      $display("[MONITOR]: Expected OUTPUT STIMULUS x: %d and Expected Y: %d", trans.motionX, trans.motionY);
        mon2scb.put(trans);
      /*
      $display("[MONITOR] ----- Printing Values in Monitor -----");
             for(j = 0; j < 256; j++)begin
         if(j%16 == 0) $display("  ");
         $write("%h ", trans.R_mem[j]);
         if(j == 255) $display("  ");
             end
      
             for(j = 0; j < 1024; j++)begin
         if(j%32 == 0) $display("  ");
         $write("%h  ",trans.s_mem[j]);
         if(j == 1023) $display("  "); 
       end
      $display(" ---------- ");
     */
    end
   
  endtask
  
endclass