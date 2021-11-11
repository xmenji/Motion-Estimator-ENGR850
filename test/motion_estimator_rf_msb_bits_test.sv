class motion_estimator_rf_msb_bits_test extends motion_estimator_test;
motion_estimator_msb_bits_seq seq;
 `uvm_component_utils(motion_estimator_rf_msb_bits_test)

function new(string name = "motion_estimator_rf_msb_bits_test" , uvm_component parent);
 super.new(name,parent);
endfunction
    
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  seq = motion_estimator_msb_bits_seq::type_id::create("seq",this);
endfunction 
function void connect_phase(uvm_phase phase);
  env.mst_agnt.mon.m_en = 1;
endfunction
task run_phase(uvm_phase phase);
 phase.raise_objection(this);
 fork
  begin
  seq.start(env.mst_agnt.sqr);
  #150;
  end
  timeout();
 join_any
 phase.drop_objection(this);
endtask
endclass
