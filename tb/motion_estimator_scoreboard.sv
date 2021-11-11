// this is dummy file . I haven't do any manipulation here. keep it for shake
// of structure of testbench. since it is mostly clock , expected and
// comparison are done in monitor itself. which is having more flexibility
// than having it here.
class motion_estimator_scoreboard extends uvm_scoreboard;
`uvm_component_utils(motion_estimator_scoreboard)

uvm_tlm_analysis_fifo#(motion_estimator_sequence_item) motion_estimator_fifo;
uvm_analysis_export#(motion_estimator_sequence_item) motion_estimator_analysis_export;

function new(string name = "motion_estimator_scoreboard" , uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase  phase);
 super.build_phase(phase);
 motion_estimator_fifo = new("motion_estimator_fifo",this);
 motion_estimator_analysis_export = new("motion_estimator_analysis_export",this);
endfunction

function void connect_phase(uvm_phase phase);
 motion_estimator_analysis_export.connect(motion_estimator_fifo.analysis_export);
endfunction

task run_phase(uvm_phase phase);
  get_packet(); 
endtask 

task get_packet();
 motion_estimator_sequence_item seq_item;
 motion_estimator_sequence_item seq_item_temp;
forever 
  begin//{
  seq_item = new();
  motion_estimator_fifo.get(seq_item);
  $cast(seq_item_temp,seq_item.clone());
  end//} 
endtask 
endclass 
