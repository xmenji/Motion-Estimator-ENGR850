class motion_estimator_sequencer extends uvm_sequencer#(motion_estimator_sequence_item);
 `uvm_sequencer_utils_begin(motion_estimator_sequencer)
 `uvm_sequencer_utils_end
function new(string name = "motion_estimator_sequencer",uvm_component parent);
   super.new(name,parent);
endfunction

endclass
