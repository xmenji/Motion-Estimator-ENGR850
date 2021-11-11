class motion_estimator_seq extends uvm_sequence;
 motion_estimator_sequence_item  item; 
  `uvm_object_utils(motion_estimator_seq)

 function new(string name = "motion_estimator_seq");
 super.new(name);
 endfunction

 task body();
  begin//{
     `uvm_info(get_full_name(),"motion_estimator_sequence_item is going to started",UVM_LOW);
     for(int i = 0 ; i < 10 ; i++)
     begin//{
      `uvm_create(item)
       assert(item.randomize());
       item.print();
      `uvm_send(item)
      #1us; // to receive all outptus 
     `uvm_info(get_full_name(),"motion_estimator_sequence_item is ended",UVM_LOW);
     end//}
  end//}
 endtask 
endclass
