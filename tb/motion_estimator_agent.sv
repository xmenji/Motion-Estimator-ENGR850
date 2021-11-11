class motion_estimator_agent extends uvm_agent;

motion_estimator_driver dri;
motion_estimator_monitor  mon;
motion_estimator_sequencer sqr;
bit en_m = 1;
uvm_active_passive_enum is_active = UVM_ACTIVE;

     `uvm_component_utils(motion_estimator_agent)

    function new(name = "motion_estimator_agent",uvm_component parent);
      super.new(name,parent);
    endfunction
    
    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
       if(is_active == UVM_ACTIVE)
         begin//{
           dri =motion_estimator_driver::type_id::create("dri",this);
           sqr  =motion_estimator_sequencer::type_id::create("sqr",this);
           if(!uvm_config_db#(virtual motion_estimator_intf)::get(null,"","vif",dri.vif))
              `uvm_error( "CONFIG_ERROR","uvm_config_db#(virtual motion_estimator_intf)::get CANNOT FOUND");
         end//}
	 begin//{
           mon = motion_estimator_monitor::type_id::create("mon",this);
           if(!uvm_config_db#(virtual motion_estimator_intf)::get(null,"","vif",mon.vif))
              `uvm_error( "CONFIG_ERROR","uvm_config_db#(virtual motion_estimator_intf)::get CANNOT FOUND");
	 end//}
    endfunction
    
    function void  connect_phase(uvm_phase phase);
       if(is_active == UVM_ACTIVE)
            begin//{
            dri.seq_item_port.connect(sqr.seq_item_export);
            end//}
	   mon.m_en = en_m;
    endfunction
endclass
