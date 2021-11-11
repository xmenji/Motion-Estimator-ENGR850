class motion_estimator_env extends uvm_env;

motion_estimator_agent mst_agnt; 
motion_estimator_virtual_sequencer v_sqr;
motion_estimator_env_config m_config;
motion_estimator_scoreboard sb;

  `uvm_component_utils(motion_estimator_env)


   function new(string name = "motion_estimator_env",uvm_component parent);
      super.new(name,parent);
   endfunction
   
   function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      m_config = motion_estimator_env_config::get_config(this);
      mst_agnt = motion_estimator_agent::type_id::create("mst_agnt",this);
      v_sqr = motion_estimator_virtual_sequencer::type_id::create("v_sqr",this);
      sb = motion_estimator_scoreboard::type_id::create("sb",this);
   endfunction
   
   function void connect_phase(uvm_phase phase);
      v_sqr.sqr = mst_agnt.sqr;
      //TODO 
      //mst_agnt.mon.motion_estimator_analysis_port.connect(sb.motion_estimator_analysis_export);
   endfunction

endclass
