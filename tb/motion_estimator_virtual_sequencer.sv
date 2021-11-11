class motion_estimator_virtual_sequencer extends uvm_virtual_sequencer;
`uvm_component_utils(motion_estimator_virtual_sequencer)
motion_estimator_sequencer sqr;
function new( string name = "motion_estimator_virtual_sequencer",uvm_component parent);
 super.new(name,parent);
endfunction
endclass
