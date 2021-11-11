class motion_estimator_test extends uvm_test;
motion_estimator_env env;
motion_estimator_env_config m_config;
motion_estimator_seq seq;
 `uvm_component_utils(motion_estimator_test)

function new(string name = "motion_estimator_test" , uvm_component parent);
 super.new(name,parent);
endfunction
    
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  env = motion_estimator_env::type_id::create("env",this);
  uvm_config_db #( motion_estimator_env_config )::set( this , "*" , s_motion_estimator_env_config_id , m_config);
  seq = motion_estimator_seq::type_id::create("seq",this);
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
task timeout(int delay=300000ns );
  #delay;
  `uvm_error(get_full_name(),$sformatf(" %t ERROR TIMEOUT REACHED",$time));
  $finish;
endtask
endclass

