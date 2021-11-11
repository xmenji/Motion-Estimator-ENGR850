class motion_estimator_monitor extends uvm_monitor;
int count;
bit m_en;
int cnt_up;
int got_new_dist;
logic [7:0] RF,S1,S2;
logic completed;
logic [15:0] S1S2 = 'd1;
vectors exp_q[$];
vectors act_q[$];
logic [7:0]new_dist;
logic [7:0]best_dist='hff;
event start_compare;
pe_dbase pe_db;
  `uvm_component_utils(motion_estimator_monitor)

virtual motion_estimator_intf vif; 
motion_estimator_sequence_item seq_item;
uvm_analysis_port #(motion_estimator_sequence_item) motion_estimator_analysis_port;

motion_estimator_cg cg;


function new(string name = "motion_estimator_monitor" ,uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
motion_estimator_analysis_port = new("motion_estimator_analysis_port",this);
seq_item = motion_estimator_sequence_item::type_id::create("seq_item",this);
endfunction
task run_phase(uvm_phase phase);
if(m_en)
begin//{
 reset_values();
 fork//{
  //count_clock();
  //start_pe();
  sample_data();
  compare_out();
  sample_cov();
 join_none//}

end//}
endtask
task sample_cov();
vectors vec;
forever 
 begin//
  @(posedge vif.clk);
  
  vec.MotionX = vif.MotionX; 
  vec.MotionY = vif.MotionY;
  cg = new(vec);
  cg.sample();

  
 end//}
endtask
task start_pe();
begin//{
 wait(vif.start==1);
 begin//{
  for(int jjj =0; jjj < 16 ; jjj++)
   begin//{
   fork//{
    pe_func(jjj);
   join_none//}
    @(posedge vif.clk);
   end//}
 end//}
end//}
endtask
task sample_data();
forever 
begin//{
 if(vif.start == 1)
 begin//{
  #0.1ns;
  RF = vif.R;
  S1 = vif.S1;
  S2 = vif.S2;

  if(count < 4111)
  begin//{
   count = count+1;
  end//}
  if(count >= 4111)
  begin//{
    completed = 1;
    ->start_compare;
  end//}
  update_S1S2;
  `uvm_info(get_full_name(),$psprintf("count=%0d",count),UVM_MEDIUM);
  `uvm_info(get_full_name(),$psprintf("RF=%d S1=%0d s2=%0d",RF,S1,S2),UVM_HIGH);
  if(count <16)
  begin//{
  `uvm_info(get_full_name(),$psprintf("if PE called %0d ",count),UVM_MEDIUM);
   for(int jjj =0; jjj < count ; jjj++)
    pe_func(jjj);
  end//}
  else
  begin//{
  `uvm_info(get_full_name(),$psprintf("else PE called %0d ",count),UVM_MEDIUM);
   for(int jjj =0; jjj < 16; jjj++)
    pe_func(jjj);
  end//}

  `uvm_info(get_full_name(),$psprintf("R=%0h S1=%0h S2=%0h",RF,S1,S2),UVM_HIGH);
  for(int jjj =0; jjj < 1 ; jjj++) //TODO chenge to 16 after fix from designer
  begin//{
  fork//{
   gen_vectors(jjj);  
  join_none//}
  end//}
 // if(count < 256)
 //  gen_vectors(0);  
 // else
 //  gen_vectors(15);  

 end//}
 @(posedge vif.clk);
end//}
endtask
task gen_vectors(idx);
vectors vec;
int cnt_l;
bit [7:0] new_dist_l;
begin//{
cnt_l = count;
cnt_l = cnt_l + 1;

if((count % 255) == 0 && count > 1)
begin//{
@(posedge vif.clk);
new_dist_l = pe_db[0].accumulate;
if(new_dist_l < best_dist)
begin//{
 vec.MotionX = cnt_l[3:0] -8;
 vec.MotionY = cnt_l[11:8] - 8;
 vec.t_ = $time;
 exp_q.push_back(vec);
 //best_dist = new_dist;
 cg = new(vec);
 cg.sample();
 `uvm_info(get_full_name(),$psprintf("MotionX=%0h MotionY=%0h",vec.MotionX,vec.MotionY),UVM_HIGH);
 fork//{
 sample_out_data();
 join_none//}
end//}
 
 fork//{
 update_dist();
 join_none//}
end//}
end//}
endtask
task update_dist();
pe_dbase pe_db_temp;
foreach(pe_db[i])
begin//{
 pe_db_temp = pe_db;
end//}
 cnt_up = cnt_up+1;
`uvm_info(get_full_name(),$psprintf("cnt_up=%0d",cnt_up),UVM_HIGH);
repeat (cnt_up) @(posedge vif.clk);
for(int kk = 0; kk < 16; kk++)
begin//{
new_dist = pe_db_temp[kk].accumulate;
pe_db[kk].accumulate = pe_db[kk].difference;
`uvm_info(get_full_name(),$psprintf("new_dist=%0h best_dist=%0h count=%0d",new_dist,best_dist,count),UVM_HIGH);
if(new_dist < best_dist)
begin//{
best_dist = new_dist;
//pe_db[kk].accumulate = pe_db[kk].difference;
end//}
@(posedge vif.clk);
end//}
endtask
task compare_out();
vectors vec_exp,vec_act;
int size;
forever 
begin//{
 @start_compare;
 size=exp_q.size();
 if(exp_q.size()  != act_q.size())
 begin//{
  `uvm_warning(get_full_name(),"EXP or ACT Doesn't have same num of entries ");
   size = (exp_q.size()>act_q.size()) ? exp_q.size() : act_q.size(); 
 end//}

 if(exp_q.size() != 0 && act_q.size() != 0)
 begin//{
  for(int i = 0; i< size; i++)
  begin//{
   vec_exp = exp_q.pop_front();
   vec_act = act_q.pop_front();

    `uvm_info(get_full_name(),$psprintf("RTL MotionX :: %0h  Testbench MotionX ::%0h  ",vec_exp.MotionX,vec_exp.MotionX),UVM_LOW);
    `uvm_info(get_full_name(),$psprintf("RTL MotionY :: %0h  Testbench MotionY ::%0h  ",vec_exp.MotionY,vec_exp.MotionY),UVM_LOW);
   if(vec_act.MotionX != vec_exp.MotionX)
    `uvm_error(get_full_name(),$psprintf("MotionX mismatch Exp::%0h time=%0t Act=%0h time=%0t",vec_exp.MotionX,vec_exp.t_,vec_act.MotionX,vec_act.t_));
   if(vec_act.MotionY != vec_exp.MotionY)
    `uvm_error(get_full_name(),$psprintf("MotionY mismatch Exp::%0h time=%0t Act=%0h time=%0d",vec_exp.MotionY,vec_exp.t_,vec_act.MotionY,vec_act.t_));
  end//}
 end//}
 end//}
endtask
task count_clock();
forever 
begin//{
 update_S1S2;
 if(vif.start)
 begin//{
  if(count < 4111)
  begin//{
   count = count+1;
  end//}
  if(count >= 4111)
  begin//{
    completed = 1;
    ->start_compare;
  end//}
   `uvm_info(get_full_name(),$psprintf("count=%0d",count),UVM_MEDIUM);
 end//}
 @(posedge vif.clk);
end//}
endtask
// task pe_func(input logic S1S2,input int idx,int wait_time);
// logic [7:0] S_l;
// logic [7:0] R_l;
// bit carry;
// bit [9:0] accu_temp;
// wait (wait_time) @(posedge vif.clk);
// forever
// begin//{
//  R_l = RF;
//  S_l = S1S2[idx] ? S1 : S2;
//  pe_db[idx].difference = R_l > S_l ? R_l-S_l : S_l - R_l;
//  accu_temp  = pe_db[idx].accumulate + pe_db[idx].difference;
//  if(accu_temp[9])
//   pe_db[idx].accumulate = 'hff;
//  else
//   pe_db[idx].accumulate = pe_db[idx].accumulate + pe_db[idx].difference;
// 
//    `uvm_info(get_full_name(),$psprintf("PE%0d accumulate=%0h difference = %0h S1=%0h s2=%0h s=%0h R=%0h S1S2[idx]=%0b ",idx,pe_db[idx].accumulate,pe_db[idx].difference,S1,S2,S_l,RF,S1S2[idx]),UVM_HIGH);
//   @(posedge vif.clk);
// end//}
// endtask
function void pe_func(input int idx);
logic [7:0] S_l;
logic [7:0] R_l;
bit carry;
bit [9:0] accu_temp;
begin//{
 R_l = RF;
// S_l = S1S2[idx] ? S1 : S2;
 if(S1S2[idx])
 begin//{
   S_l = S1;
 end//}
 else
 begin//{
   S_l = S2;
 end//}
// pe_db[idx].difference = R_l > S_l ? R_l-S_l : S_l - R_l;
if(R_l > S_l)
begin//{
 pe_db[idx].difference = R_l-S_l; // : S_l - R_l;
end//}
else
begin//{
 pe_db[idx].difference = S_l - R_l; 
end//}
 accu_temp  = pe_db[idx].accumulate + pe_db[idx].difference;
   `uvm_info(get_full_name(),$psprintf("PE%0d accumulate=%0h difference = %0h S1=%0h s2=%0h s=%0h R=%0h S1S2[idx]=%0b ",idx,pe_db[idx].accumulate,pe_db[idx].difference,S1,S2,S_l,R_l,S1S2[idx]),UVM_HIGH);
 if(accu_temp[9])
  pe_db[idx].accumulate = 'hff;
 else
  pe_db[idx].accumulate = pe_db[idx].accumulate + pe_db[idx].difference;

   `uvm_info(get_full_name(),$psprintf("PE%0d accumulate=%0h difference = %0h S1=%0h s2=%0h s=%0h R=%0h S1S2[idx]=%0b ",idx,pe_db[idx].accumulate,pe_db[idx].difference,S1,S2,S_l,RF,S1S2[idx]),UVM_HIGH);
end//}
endfunction


function void reset_values();
endfunction
function void update_S1S2();
 if(count[3:0] == 0)
 begin//{
  S1S2 = 1;
  $display("update_S1S2::%0d",S1S2);
  return;
 end//}
 else 
 begin//{
  S1S2[count[3:0]] = 1;
  $display("update_S1S2::%0d",S1S2);
  return;
 end//}
endfunction
task sample_out_data();
 vectors vec;
 repeat (1) @ (posedge vif.clk);
 #0.5ns;
 vec.MotionX = vif.MotionX;
 vec.MotionY = vif.MotionY;
 vec.t_ = $time;
 act_q.push_back(vec);
   `uvm_info(get_full_name(),$psprintf("sampling output data MotionX::%0h MotionY::%0h ",vec.MotionX,vec.MotionY),UVM_HIGH);
endtask
function void report_phase(uvm_phase phase);
real c;
`uvm_info(get_full_name(),$psprintf("Goal= 100"),UVM_NONE);
c = cg.get_coverage();
`uvm_info(get_full_name(),$psprintf("Current coverage=%0f ",c),UVM_NONE);
endfunction
endclass
