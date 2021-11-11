
class motion_estimator_rf_ffff_sf_ffff_test extends motion_estimator_test;
motion_estimator_rf_ffff_sf_ffff_seq seq;
 `uvm_component_utils(motion_estimator_rf_ffff_sf_ffff_test)

function new(string name = "motion_estimator_rf_ffff_sf_ffff_test" , uvm_component parent);
 super.new(name,parent);
endfunction
    
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  seq = motion_estimator_rf_ffff_sf_ffff_seq::type_id::create("seq",this);
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
