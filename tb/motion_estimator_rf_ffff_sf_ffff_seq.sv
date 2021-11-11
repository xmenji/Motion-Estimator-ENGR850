// this sequence used to modify the seq item to defined values to reach
// coverage numbers as well fucntional verification different pe with high
// values 
class motion_estimator_rf_ffff_sf_ffff_seq extends uvm_sequence;
 motion_estimator_sequence_item  item; 

  `uvm_object_utils(motion_estimator_rf_ffff_sf_ffff_seq)

 function new(string name = "motion_estimator_rf_ffff_sf_ffff_seq");
 super.new(name);
 endfunction

 task body();
  begin//{
     `uvm_info(get_full_name(),"motion_estimator_rf_ffff_sf_ffff_sequence_item is going to started",UVM_LOW);
      `uvm_create(item)
       assert(item.randomize()); // with { total_sum == 255;});
       foreach(item.rf[i])
       item.rf[i] = 0;

       foreach(item.sf1[i])
       item.sf1[i] = 0;
       foreach(item.sf2[i])
       item.sf2[i] = 0;

       for(int iii=0;iii < 16; iii++)
         item.rf[iii] = 'hff; 

       for(int iii=0;iii < 16; iii++)
       begin//{
         item.sf1[iii] = 'hff; 
         item.sf2[iii] = 'hff; 
       end//}
     `uvm_info(get_full_name(),"motion_estimator_rf_ffff_sf_ffff_sequence_item is ",UVM_LOW);
       
       item.print();
      `uvm_send(item)
      #1us; // to receive all outptus 
     `uvm_info(get_full_name(),"motion_estimator_rf_ffff_sf_ffff_sequence_item is ended",UVM_LOW);
  end//}
 endtask 
endclass
