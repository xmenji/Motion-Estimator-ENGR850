`include "transaction.sv"
`include "generator.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"

class environment;
  generator gen;
  driver driv;
  monitor mon;
  scoreboard scb;
  
  mailbox gen2driv, mon2scb;
  
  event gen_ended;
  
  virtual mem_intf mem_vif;
  
	
  function new(virtual mem_intf mem_vif);
    this.mem_vif = mem_vif;
    
    gen2driv = new();
    mon2scb = new();
    
    gen = new(gen2driv,gen_ended);
    driv = new(mem_vif, gen2driv);
    mon = new(mem_vif, mon2scb);
    scb = new(mon2scb);
  endfunction
  
  task pre_test();
    $display("[GENERATOR] In driver start");
    driv.start();
  endtask
  
  task test();
    fork
      gen.main();
      driv.main();
      mon.main();
      scb.main();
    join_any
  endtask
  
  task post_test();
    wait(gen_ended.triggered);
    wait(gen.repeat_count == driv.no_transactions);
    wait(gen.repeat_count == scb.no_transactions);
  endtask 
  
  task run;
    pre_test();
    $display("[GENERATOR] Done with pre test, going into test.");
    test();
    post_test();
    $finish;
  endtask
  
endclass;