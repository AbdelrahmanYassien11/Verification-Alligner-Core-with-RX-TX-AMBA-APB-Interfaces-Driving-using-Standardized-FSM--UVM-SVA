class write_read_test extends apb_base_test;

  // Register with factory
  `uvm_component_utils(write_read_test)

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
            // Override the type of sequence used by the base_sequence class
            apb_base_sequence::type_id::set_type_override(write_read_sequence::type_id::get());
            // Call the build_phase method of the base class
            super.build_phase(phase);
            // Display a message indicating the build phase of the test
            `uvm_info(get_type_name(), "Build Phase", UVM_LOW)
        endfunction : build_phase

    //---------------------------------------
    // Arbitration mode method
    //---------------------------------------
        virtual task cfg_arb_mode;
        endtask
  
endclass : write_read_test