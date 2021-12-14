//-------------------------------------------------------------------------
//                        www.verificationguide.com
//-------------------------------------------------------------------------
//gets the packet from generator and drive the transaction paket items into interface (interface is connected to DUT, so the items driven into interface signal will get driven in to DUT) 
`define DRIV_IF mem_vif.DRIVER.driver_cb
class driver;
  
  //used to count the number of transactions
  int no_transactions, j;
  
  //creating virtual interface handle
  virtual mem_intf mem_vif;
  
  //creating mailbox handle
  mailbox gen2driv;
  
  //constructor
  function new(virtual mem_intf mem_vif,mailbox gen2driv);
    //getting the interface
    this.mem_vif = mem_vif;
    //getting the mailbox handles from  environment 
    this.gen2driv = gen2driv;
  endfunction
  
  //Reset task, Reset the Interface signals to default/initial values
  
  task start;
    $display("in start of driver, mem_vid.start: %b", mem_vif.start);
    wait(!mem_vif.start);
    $display("--------- [DRIVER] Reset Started ---------");
    for(j = 0; j < 256; j++)
      `DRIV_IF.s_mem[j] <= 0;
    for(j = 0; j < 1024; j++)
      `DRIV_IF.R_mem[j] <= 0;
    wait(mem_vif.start);
    $display("--------- [DRIVER] Reset Ended ---------");
  endtask
  
  //drivers the transaction items to interface signals
  task drive;
      Transaction trans;
    repeat(10) 
     begin
      gen2driv.get(trans);
      $display("--------- [DRIVER-TRANSFER: %0d] ---------",no_transactions);
             @(posedge mem_vif.DRIVER.clk);
      `DRIV_IF.R_mem <= trans.R_mem;
        `DRIV_IF.s_mem <= trans.s_mem;
       `DRIV_IF.expected_motionX <= trans.expected_motionX;
       `DRIV_IF.expected_motionY <= trans.expected_motionY;
       $display("driver expected x: %d and y: %d", trans.expected_motionX, trans.expected_motionY);       
       wait(mem_vif.completed == 1);
       $display("[DRIVER] Completed = 1");
       if(`DRIV_IF.motionX >= 8)
         	trans.motionX <= `DRIV_IF.motionX - 16;
       else
       		trans.motionX <= `DRIV_IF.motionX;
       if(`DRIV_IF.motionY >= 8)
        	trans.motionY <= `DRIV_IF.motionY - 16;
       else
       		trans.motionY <= `DRIV_IF.motionY;
       $display("[DRIVER] OUTPUT STIMULUS: MotionX: %b, MotionY: %d", `DRIV_IF.motionX, `DRIV_IF.motionY);
	/*Printing Values of R and S 
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
      $display("-----------------------------------------");*/
      no_transactions++;
       @(posedge mem_vif.DRIVER.clk);
    end
  endtask
  
    
  //
  task main;
    $display("Driver main");
    forever begin
      fork
        //Thread-1: Waiting for reset
        begin
          wait(!mem_vif.start);
        end
        //Thread-2: Calling drive task
        begin
          forever
            drive();
        end
      join_any
      disable fork;
    end
  endtask
        
endclass