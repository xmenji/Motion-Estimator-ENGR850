// Driver which getting item from sequence and driving R,S1,S2 to DUT on next
// edge of clk  through
// interface based on ADDRESSR,AddressS1,AddressS2 values. 
class motion_estimator_driver extends uvm_driver#(motion_estimator_sequence_item);

virtual motion_estimator_intf vif; 
motion_estimator_sequence_item seq_item;

 `uvm_component_utils(motion_estimator_driver)

     function new(string name = "motion_estimator_driver",uvm_component parent);
          super.new(name,parent);
     endfunction
     function void build_phase(uvm_phase phase);
          super.build_phase(phase);
          seq_item = motion_estimator_sequence_item::type_id::create("seq_item",this);
     endfunction
     function void connect_phase(uvm_phase phase);
           super.connect_phase(phase);
     endfunction

     task run_phase(uvm_phase phase);
     begin//{
      initialize_signals();
      wait_for_some_fixed_clk_cycles();
     forever
      begin//{
         fork //{
          get_and_drive();
         join//}
      end//}
     end//}
     endtask 
     task get_and_drive();
     begin//{
     seq_item_port.get_next_item(req);
     $cast(rsp,req.clone());
     rsp.print();
     drive_data(); 
     rsp.set_id_info(req);
     seq_item_port.item_done();
     end//}
     endtask
     task drive_data();
	@(posedge vif.clk);
	fork//{
         drive_start();
	 drive_r_s1_s2();
	join_any//}
        // begin//{
	// fork//{
        //  while(1)
	//   begin//{
	//    foreach(req.Rf_mem[i])
	//    begin//{
	//    for(int kk =0; kk < 16; kk++)
	//     begin//{
	//      vif.R = req.Rf_mem[i].value[kk];
	//      vif.S1 = req.Sf_mem[i].value[kk];
	//      vif.start = 1;
	//      @(posedge vif.clk);
	//     end//}
	//    end//}
	//    break;
	//    end//}
	//    begin//{
	//    repeat (16) @ (posedge vif.clk);
	//    while(1)
	//    begin//{
	//    foreach(req.Sf_mem[i])
	//    begin//{
	//    for(int kk =0; kk < 16; kk++)
	//     begin//{
	//      vif.S2 = req.Sf_mem[i].value[kk+16];
	//      @(posedge vif.clk);
	//     end//}
	//    end//}
	//      vif.start = 0;
	//    break;
	//    end//}
	//    end//}
	//  join//}
        // end//} 
     endtask
task initialize_signals();
begin
vif.R  = 'h0;
vif.S1 = 'h0;
vif.S2 = 'h0;
vif.start = 'h0;
#100ns;
end
endtask
task drive_start();
  begin//{
   vif.start = 1'b1;
   repeat(req.start_num_clks) @(posedge vif.clk);
   vif.start = 1'b0;
   @(posedge vif.clk);
  end//}
endtask
task wait_for_some_fixed_clk_cycles();
 repeat(25) @(posedge vif.clk);
endtask
task drive_r_s1_s2();
forever
begin//{
if(vif.start == 1)
begin//{
 vif.R = req.rf[vif.AddressR];
 vif.S1 = req.sf1[vif.AddressS1];
 vif.S2 = req.sf2[vif.AddressS2];
end//}
 @(posedge vif.clk);
end//}
endtask
endclass
