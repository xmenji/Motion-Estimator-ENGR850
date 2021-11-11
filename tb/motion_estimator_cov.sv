//this file having all the functional coverpoints -> 1) MotioX has to covered
//atleast any one value of these ranages([0:3][3:7][7:11][12:15]). 

//2) MotioY has to covered
//atleast any one value of these ranages([0:3][3:7][7:11][12:15]). 



typedef struct {
 logic [3:0] MotionX,MotionY;
 time t_;
} vectors;
typedef struct 
{
 bit [7:0] accumulate;
 bit [7:0] difference;
}pe_dbase[int];




covergroup motion_estimator_cg(vectors vec);
MOTION_VECTOR_X : coverpoint vec.MotionX
{
   bins low_x ={[0:3]};
   bins low_1 ={[4:7]};
   bins low_2 ={[8:11]};
   bins low_3 ={[12:15]};
   
}
MOTION_VECTOR_Y : coverpoint vec.MotionY
{
  bins low_y ={[0:3]};
  bins low_4 ={[4:7]};
  bins low_5 ={[8:11]};
  bins low_6 ={[12:15]};
  

 }
 endgroup


