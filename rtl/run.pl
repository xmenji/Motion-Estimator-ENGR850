vcs -sverilog -R  -timescale=1ns/1ns +acc +vpi  +seed=1  -l $test.log -R  -debug_pp  +ntb_solver_debug=trace +ntb_solver_debug_filter=1  +UVM_VERBOSITY=uvm_verbosity +UVM_TESTNAME=$test +incdir+${UVM_HOME} ${UVM_HOME}/uvm.sv ${UVM_HOME}/dpi/uvm_dpi.cc -cm_tgl mda -lca -cm line+cond+fsm+tgl -ova_cov -cm_name $test  -F  files.list




 
