class motion_estimator_env_config  extends uvm_object;

typedef motion_estimator_env_config  motion_estimator_env_config_t;  
	`uvm_object_utils( motion_estimator_env_config );
 
  static function motion_estimator_env_config_t get_config( uvm_component c );
    uvm_object o;
    motion_estimator_env_config_t t;
    if(!uvm_config_db #( motion_estimator_env_config )::get( c,"", s_motion_estimator_env_config_id , t ) ) begin	
      `uvm_error("Config Error","uvm_config_db #(motion_estimator_env_config_t)::get() cannot find resource s_motion_estimator_env_config_id");
      return null;
    end
    return t;
  endfunction
function new( string name = "" );
  super.new( name );
endfunction

endclass
