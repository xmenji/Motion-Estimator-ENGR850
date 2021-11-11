// this file having 3 memories and num clock cycles to drive start input to
// design. RF,SF1,SF2 are dynamic array and they are randomized based on set
// of constraints coded here
class motion_estimator_sequence_item extends uvm_sequence_item;
rand byte unsigned rf[];
rand byte unsigned sf1[];
rand byte unsigned sf2[];
rand int start_num_clks ;
rand int unsigned total_sum,total_sum1,rf_sum,sf1_sum,sf2_sum;

constraint rf_sf_size_c // this to set rf,sf1,sf2 array sizes to 256,980,980 
{
 rf.size() == 16*16;
 sf1.size() == 16*30;
 sf2.size() == 16*30;
};
constraint total_sum_c  // Make sure sum of all memory bits between 250 to 255
{
 total_sum inside {[250:255]};
}

constraint total_sum_c_1  // Make sure sum of all memory bits between 250 to 255
{
 total_sum1 inside {[250:255]};
}
constraint rf_size_sf_size_c
{
 sf1_sum + sf2_sum == total_sum;
}
constraint sf_size_c_l
{
 rf_sum == total_sum1;
}
constraint rf_sf_sum_c // Having different sum value each memory to easy hadling of constraints.
{
 rf.sum() == rf_sum;
 sf1.sum() == sf1_sum;
 sf2.sum() == sf2_sum;
}

constraint start_num_clks_c // this is to drive start signal how many cycles we want .
{
 start_num_clks inside {[4500:4500]};
}

constraint order_total_c // make sure rf sum,s1 sum , s2 sum get randomized before total sum. 
{
 solve total_sum before rf_sum,sf1_sum,sf2_sum;
}

constraint order_total_c_1 // make sure rf sum,s1 sum , s2 sum get randomized before total sum. 
{
 solve total_sum1 before rf_sum;
}

constraint order_sum_mem_c // memory randomization order. 
{
 solve rf_sum,sf1_sum,sf2_sum before rf,sf1,sf2;
}

 `uvm_object_utils_begin(motion_estimator_sequence_item) // registering sequence item to uvm factory
 `uvm_object_utils_end

 function new(string name = "motion_estimator_sequence_item"); // constructor for sequence item
 super.new(name);
 endfunction
function void do_print (uvm_printer printer); // printing statement of each memories inside this class. Ex. seq_item.print() will display all the constent of memories in log file.
for(int i=0 ; i< rf.size(); i=i+16)
$display("rf[%0h] = %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h ", i,rf[i], rf[i+1] , rf[i+2] , rf[i+3] , rf[i+4] , rf[i+5] , rf[i+6] , rf[i+7] , rf[i+8] , rf[i+9] , rf[i+10], rf[i+11], rf[i+12], rf[i+13], rf[i+14], rf[i+15]);

for(int i=0 ; i< sf1.size();i=i+16)
$display("sf1[%0h] = %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h ", i,sf1[i], sf1[i+1] , sf1[i+2] , sf1[i+3] , sf1[i+4] , sf1[i+5] , sf1[i+6] , sf1[i+7] , sf1[i+8] , sf1[i+9] , sf1[i+10], sf1[i+11], sf1[i+12], sf1[i+13], sf1[i+14], sf1[i+15]);
for(int i=0 ; i< sf2.size(); i=i+16)
$display("sf2[%0h] = %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h %0h ", i,sf2[i], sf2[i+1] , sf2[i+2] , sf2[i+3] , sf2[i+4] , sf2[i+5] , sf2[i+6] , sf2[i+7] , sf2[i+8] , sf2[i+9] , sf2[i+10], sf2[i+11], sf2[i+12], sf2[i+13], sf2[i+14], sf2[i+15]);
endfunction
endclass
