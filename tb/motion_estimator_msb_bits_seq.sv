// this sequence will randomize the seq item and changing the item values to
// defined values based on test mem_sel. this is to cover corner cases of
// design functionality as well as coverage stability.
class motion_estimator_msb_bits_seq extends uvm_sequence;
 motion_estimator_sequence_item  item; 
 rand int mem_sel;

  `uvm_object_utils(motion_estimator_msb_bits_seq)

 function new(string name = "motion_estimator_msb_bits_seq");
 super.new(name);
 endfunction

 task body();
  begin//{
     `uvm_info(get_full_name(),"motion_estimator_msb_bits_sequence_item is going to started",UVM_LOW);
      `uvm_create(item)
       assert(item.randomize() with { total_sum == 250;});
       for(int iii=0;iii < 5; iii++)
       begin//{
        case(mem_sel) //0 for rf mem, 1 for s1, 2 for s2
        0:
         item.rf[17][iii+3] = 1'b1; 
	1: begin//{
	for(int kk =26 ; kk < 16;kk++) // doubt logic?
	begin//{
         item.sf1[kk+16][iii+3] = 1'b1; 
         item.sf2[kk+16][iii+3] = 1'b1; 
	end//}
	for(int kk =0 ; kk < 40;kk++)
         item.sf1[kk+32][iii+3] = 1'b1; 
	for(int kk =16 ; kk < 50;kk++)
         item.sf2[kk][iii+3] = 1'b1; 
	end//}
	2: 
         item.sf2[26][iii+3] = 1'b1; 
	default:
	 `uvm_fatal(get_full_name(),"Check mem sel value")
	endcase 
       end//}
       item.print();
      `uvm_send(item)
      #1us; // to receive all outptus 
     `uvm_info(get_full_name(),"motion_estimator_msb_bits_sequence_item is ended",UVM_LOW);
  end//}
 endtask 
endclass
