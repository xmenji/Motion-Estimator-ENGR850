class Transaction;
   logic [7:0] R_mem[255:0];
  rand logic[7:0]   s_mem[1023:0];  
  rand integer expected_motionX, expected_motionY;
  integer motionX, motionY;
  bit completed;
  //logic [3:0] motionX, motionY;
  
  constraint c { expected_motionX inside {[-8:7]}; expected_motionY inside {[-8:7]};}

  
 /*
My idea was to define a transaction class in which we define two random array variable one to represent the search memory and another for the reference memory perturbation, one random variable to represent target motion X and one to represent target motion Y. Constraint the target motion and motion Y variable to be within the possible range.
Populate the reference memory from the search memory based the target motion X and motion Y values.
*/ 
 


  function Transaction do_copy();
    Transaction trans;
    trans = new();
    trans.R_mem  = this.R_mem;
    trans.s_mem = this.s_mem;
    trans.expected_motionX = this.expected_motionX;
    trans.expected_motionY = this.expected_motionY;
    trans.completed = this.completed;
    trans.motionX = this.motionX;
    trans.motionY = this.motionY;
    return trans;
  endfunction

  function void  make_rmem();
    //populate Rmem from Smem accordign to the motion set by motionX and MotionY
    foreach(this.R_mem[i])
      //this.R_mem [i] = this.s_mem[(31*7)+8+(i%16)+((i/16)*31)+(this.expected_motionX)+(this.expected_motionY*31)];
      this.R_mem[i] = this.s_mem[32*8+8+(((i/16)+this.expected_motionY)*32)+((i%16)+this.expected_motionX)];
  endfunction
  
endclass