class apb_base_test extends uvm_test;
  
  // Environment instance
  apb_env env;
  
  // Register with factory
  `uvm_component_utils(apb_base_test)
  
  //---------------------------------------
  // Constructor
  //---------------------------------------
  function new(string name = "", uvm_component parent = null);
    super.new(name, parent);
  endfunction : new

  //---------------------------------------
  // Build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Create environment
    env = apb_env::type_id::create("env", this);

    // Set verbosity level
    uvm_top.set_report_verbosity_level(UVM_MEDIUM);

    uvm_config_db#(string)::set(this,"*","test_name",get_type_name());

  endfunction : build_phase

  //---------------------------------------
  // Arbitration mode method
  //---------------------------------------
  
  virtual task cfg_arb_mode;
  endtask

  //---------------------------------------
  // End of elaboration phase
  //---------------------------------------
  function void end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);
    
    // Print the topology
    uvm_top.print_topology();
  endfunction : end_of_elaboration_phase
  
  //---------------------------------------
  // Run phase
  //---------------------------------------
  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    // Raise objection to keep the test from completing
    phase.raise_objection(this);

    `uvm_info(get_type_name(), "Base test started", UVM_HIGH)
    
    `uvm_info(get_type_name(), "Base test completed", UVM_MEDIUM)
   
    // Drop objection to allow the test to complete :(
    phase.drop_objection(this);
  endtask : run_phase
  
  //---------------------------------------
  // Report phase
  //---------------------------------------
  function void report_phase(uvm_phase phase);
    uvm_report_server server = uvm_report_server::get_server();
    
    if (server.get_severity_count(UVM_FATAL) + 
        server.get_severity_count(UVM_ERROR) == 0)
      `uvm_info(get_type_name(), "TEST PASSED", UVM_LOW)
    else
      `uvm_info(get_type_name(), "TEST FAILED", UVM_LOW)
  endfunction : report_phase
  
endclass : apb_base_test