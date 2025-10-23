//   function automatic string enum_name_by_index #(parameter type ENUM_T = int)
//                                                 (int index);
//     ENUM_T value = ENUM_T'(0);
//     int count = value.num();
//     int wrapped_index = index % count;

//     for (int i = 0; i < wrapped_index; i++)
//       value = value.next();

//     return value.name();
//   endfunction
  
// `define ENUM_NAME_BY_INDEX(ENUM_TYPE, INDEX) \
  // enum_name_by_index#(.ENUM_T(ENUM_TYPE))(INDEX)

// function automatic string get_enum_name #(type T = int) (int idx);
//     T val = T'(idx);
//     return val.name();
// endfunction

// covergroup A_cg_df(input int signed i, input apb_sequence_item_mon cov);
//   option.weight = ((i == -16)? 0:1);
//   option.name = $sformatf("df = %0d",i);
//   option.per_instance = 1;
//   option.goal = 50;
//   df: coverpoint cov.A iff (cov.ALU_EN_STATE_e == ALU_ON) {
//     bins A[] = {i};
//     ignore_bins A_ignored[] = {-16};
//   }
// endgroup : A_cg_df

// covergroup B_cg_df(input int signed i, input apb_sequence_item_mon cov);
//    	option.weight = ((i == -16)? 0:1);
//    	option.name = $sformatf("df = %0d",i);
//    	option.per_instance = 1;
//     option.goal = 50;   	
//    	df: coverpoint cov.B iff (cov.ALU_EN_STATE_e == ALU_ON) {
//    		bins B[] = {i};
// 			ignore_bins B_ignored[] = {-16};
//    	}
// endgroup : B_cg_df

covergroup pwrite_cg_df(input int i, input apb_sequence_item_mon cov, ref bit has_coverage);
	option.name = (cov.dir == WRITE)  ? "WRITE" :
                (cov.dir == READ)   ? "READ" :
                "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.dir iff (has_coverage/* reset & Penable & PSEL*/) {
		bins dir[] = {i};
	}
endgroup : pwrite_cg_df

covergroup pwrite_cg_dt(input int i, input int k, input apb_sequence_item_mon cov, ref bit has_coverage);
	// option.name = ((i == WRITE) && (k == READ))  ? "WRITE -> READ" :
  //               ((i == READ)  && (k == WRITE)) : "READ -> WRITE"
                // "Invalid";
  option.name = $sformatf("%0d => %0d ", i, k);
	option.per_instance = 1;
	df: coverpoint cov.dir iff (has_coverage/* reset & Penable & PSEL*/) {
		bins dir[] = (i => k);
	}
endgroup : pwrite_cg_dt

// covergroup A_op_cg_dt(input int i, input int k , input apb_sequence_item_mon cov);
// 	option.weight = ((k == 7 || i == 7)? 0:1);
// 	option.name = $sformatf("dt %0d => %0d", i, k);
//    	option.per_instance = 1;
//    	dt: coverpoint cov.a_op iff ((cov.OP_MODE_e == MODE_A) && (cov.ALU_EN_STATE_e == ALU_ON)) {
//    		bins A_op[] = (i => k);
// 			ignore_bins A_op_ignored1[] = (i => 7);
//    		ignore_bins A_op_ignored2[] = (7 => k);
//    	}	
// endgroup : A_op_cg_dt


class apb_coverage extends uvm_component;

  //uvm_component test_name;
  string test_name;

  apb_agent_config apb_agt_cfg;
  // rst_seq_item reset_seq_h;
  apb_sequence_item_mon output_cov_copied, input_cov_copied;
  apb_sequence_item_mon input_item, output_item;

  //---------------------------------------
  // Declare TLM component for reset
  //---------------------------------------
  // uvm_analysis_export #(rst_seq_item) reset_collected_export;

  // Analysis exports
  uvm_analysis_export #(apb_sequence_item_mon) analysis_export_inputs;
  uvm_analysis_export #(apb_sequence_item_mon) analysis_export_outputs;

  // TLM FIFOs
  // uvm_tlm_analysis_fifo #(rst_seq_item) reset_fifo;
  uvm_tlm_analysis_fifo #(apb_sequence_item_mon) inputs_fifo;
  uvm_tlm_analysis_fifo #(apb_sequence_item_mon) outputs_fifo;

  // Transaction counter
  int count_trans;

  //instance base coverage
	protected int signed j, z;

	// A_cg_df A_cg_df_vals [(2**INPUT_WIDTH)];
	// B_cg_df B_cg_df_vals [(2**INPUT_WIDTH)];

	pwrite_cg_df   pwrite_cg_df_vals   [2**1];
	pwrite_cg_dt   pwrite_cg_dt_vals   [2**1] [2**1];

	// A_op_cg_dt A_op_cg_dt_vals [(2**A_OP_WIDTH)][(2**A_OP_WIDTH)];


  // Register with factory
  `uvm_component_utils_begin(apb_coverage)
  `uvm_field_int(count_trans, UVM_DEFAULT)
  `uvm_component_utils_end

  bit has_coverage;
  //---------------------------------------
  // Constructor
  //---------------------------------------
  function new(string name, uvm_component parent);
    super.new(name, parent);
    // Initialize counters
    count_trans = 0;
		input_cov_copied = new();
		output_cov_copied = new();
		
    // if(!(uvm_config_db#(string)::get(this,"","test_name",test_name)))
    //   `uvm_fatal(get_full_name, "Couldn't get TEST_NAME")
      
      // `uvm_info(get_full_name(),$sformatf("TEST_NAME %s",test_name),UVM_LOW)
    // apb_agt_cfg = apb_agent_config::type_id::create("apb_agt_cfg", this);
    // apb_agt_cfg = new("apb_agt_cfg", uvm_component);
    // Create coverage groups 
    foreach(pwrite_cg_df_vals[i])     pwrite_cg_df_vals[i] 	  = new(i, output_cov_copied, has_coverage);
    foreach(pwrite_cg_dt_vals[i,k])   pwrite_cg_dt_vals[i][k] = new(i, k, output_cov_copied, has_coverage);
            // foreach(A_op_cg_dt_vals[i,j])   A_op_cg_dt_vals[i][j] 	= new(i, j, input_cov_copied);



    // case(test_name)
    //   "random_test": begin 

        // j = -(2**(INPUT_WIDTH-1));//-16
        // for (int i = 0; i < (2**(INPUT_WIDTH)) ; i++) begin //0 to 31
        //   pwrite_df_vals[i] = new(j, input_cov_copied);
        //   j = j + 1;
        // end

        // j = -(2**(OUTPUT_WIDTH-1));//-32
        // for (int i = 0; i < (2**(OUTPUT_WIDTH)) ; i++) begin
        //   C_cg_df_vals[i] = new(j, output_cov_copied);
        //   j = j + 1;
        // end

        // z = -(2**(OUTPUT_WIDTH-1));//-32
        // for (int i = 0; i < (2**(OUTPUT_WIDTH)) ; i++) begin
        //   j = -(2**(OUTPUT_WIDTH-1));
        //   for (int k = 0; k < (2**(OUTPUT_WIDTH)); k++) begin
        //     C_cg_dt_vals[i][k] = new(z, j, output_cov_copied);
        //     j = j + 1;
        //   end
        //   z = z + 1;
        // end

        // foreach(A_op_cg_df_vals[i])   A_op_cg_df_vals[i] 	   = new(i, input_cov_copied);
        // foreach(B_op01_cg_df_vals[i]) B_op01_cg_df_vals[i] = new(i, input_cov_copied);
        // foreach(B_op11_cg_df_vals[i]) B_op11_cg_df_vals[i] = new(i, input_cov_copied);

        // foreach(A_op_cg_dt_vals[i,j])   A_op_cg_dt_vals[i][j] 	= new(i, j, input_cov_copied);
        // foreach(B_op01_cg_dt_vals[i,j]) B_op01_cg_dt_vals[i][j] = new(i, j, input_cov_copied);
        // foreach(B_op11_cg_dt_vals[i,j]) B_op11_cg_dt_vals[i][j] = new(i, j, input_cov_copied);

        // foreach(A_B_en_cg_df_vals[i])   A_B_en_cg_df_vals[i] = new(i, input_cov_copied);
        // foreach(A_B_en_cg_dt_vals[i,j]) A_B_en_cg_dt_vals[i][j] = new(i, j, input_cov_copied);

        // foreach(ALU_en_cg_df_vals[i])   ALU_en_cg_df_vals[i] = new(i,input_cov_copied);
        // foreach(ALU_en_cg_dt_vals[i,j]) ALU_en_cg_dt_vals[i][j] = new(i,j,input_cov_copied);
      
    // end

    //   "repitition_test": begin 
    //     a_op_repi_cg = new();
    //     b_op01_repi_cg = new();
    //     b_op11_repi_cg = new(); 
    //   end

    //   "error_test": begin
    //     error_cg = new();
    //   end
    // endcase
   
  endfunction : new

  //---------------------------------------
  // Build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // output_item = apb_sequence_item_mon::type_id::create("output_item");
    // Create analysis exports
    // reset_collected_export = new ("reset_collected_export",this);  
    analysis_export_inputs = new("analysis_export_inputs", this);
    analysis_export_outputs = new("analysis_export_outputs", this);


    // Create TLM FIFOs
    // reset_fifo = new("reset_fifo", this);
    inputs_fifo = new("inputs_fifo", this);
    outputs_fifo = new("outputs_fifo", this);
    
  endfunction: build_phase

  //---------------------------------------
  // Connect phase
  //---------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // Connect exports to FIFOs
    // reset_collected_export.connect(reset_fifo.analysis_export);
    analysis_export_inputs.connect(inputs_fifo.analysis_export);
    analysis_export_outputs.connect(outputs_fifo.analysis_export);
  endfunction: connect_phase

  //---------------------------------------
  // Run phase
  //---------------------------------------
  task run_phase(uvm_phase phase);
    has_coverage = apb_agt_cfg.get_has_coverage();
    forever begin
      fork
        // reset_fifo.get(reset_seq_h);
        get_and_sample();
      join_any
      disable fork;
    end
  endtask : run_phase

  //---------------------------------------
  // tasks definations
  //---------------------------------------

  task get_and_sample();

    forever begin
      fork
        // begin
        //   inputs_fifo.get(input_item);
        //   input_cov_copied.copy(input_item);
        // end
        begin
          outputs_fifo.get(output_item);
          output_cov_copied.copy(output_item);
        end
      join

      // Increment transaction counter
      count_trans++;
      
      foreach(pwrite_cg_df_vals[i]) pwrite_cg_df_vals[i].sample();
      foreach(pwrite_cg_dt_vals[i,j]) pwrite_cg_dt_vals[i][j].sample();
      // case(test_name)
      //   "random_test": begin 
      //     control_cg.sample(input_item);
      //     a_operations_cg.sample(input_item);
      //     b_operations01_cg.sample(input_item);
      //     b_operations11_cg.sample(input_item);
      //     input_values_cg.sample(input_item);
      //     output_values_cg.sample(output_item);
      //     data_ranges_cg.sample(input_item, output_item);
      //     stability_cg.sample(input_item, output_item);
      //     special_cases_cg.sample(input_item); 
      //     foreach(A_cg_df_vals[i]) A_cg_df_vals[i].sample();
      //     foreach(B_cg_df_vals[i]) B_cg_df_vals[i].sample();

          // foreach(A_op_cg_dt_vals[i,j])   A_op_cg_dt_vals[i][j].sample();
          // foreach(B_op01_cg_dt_vals[i,j]) B_op01_cg_dt_vals[i][j].sample();
          // foreach(B_op11_cg_dt_vals[i,j]) B_op11_cg_dt_vals[i][j].sample();

          // foreach(A_op_cg_df_vals[i])   A_op_cg_df_vals[i].sample();
          // foreach(B_op01_cg_df_vals[i]) B_op01_cg_df_vals[i].sample();
          // foreach(B_op11_cg_df_vals[i]) B_op11_cg_df_vals[i].sample();			

          // foreach(A_B_en_cg_df_vals[i]) A_B_en_cg_df_vals[i].sample();

          // foreach(A_B_en_cg_dt_vals[i,j]) A_B_en_cg_dt_vals[i][j].sample();

          // foreach(ALU_en_cg_df_vals[i]) ALU_en_cg_df_vals[i].sample();
          // foreach(ALU_en_cg_dt_vals[i,j]) ALU_en_cg_dt_vals[i][j].sample();

          // foreach(C_cg_df_vals[i]) C_cg_df_vals[i].sample();
      //   end

      //   "repitition_test": begin
      //     a_op_repi_cg.sample(input_item);
      //     b_op01_repi_cg.sample(input_item);
      //     b_op11_repi_cg.sample(input_item);
      //   end

      //   "error_test": begin
      //     error_cg.sample(input_item, output_item);
      //   end
      // endcase
      

      // You could add output value checking here if needed

      // coverage_target();
    end
  endtask

  // task coverage_target();

  //   case(test_name)
  //     "random_test": begin 
  //       if(control_cg.get_coverage()==100 && a_operations_cg.get_coverage()==100
  //          && b_operations01_cg.get_coverage()==100 && b_operations11_cg.get_coverage()==100 
  //          && input_values_cg.get_coverage() == 100 && output_values_cg.get_coverage() == 100
  //          && data_ranges_cg.get_coverage() == 100 && stability_cg.get_coverage() == 100
  //          && special_cases_cg.get_coverage() == 100
  //          && A_cg_df_vals[0].get_coverage() == 100  && B_cg_df_vals[0].get_coverage() == 100
  //         //  && A_op_cg_df_vals[0].get_coverage() == 100 && A_op_cg_dt_vals[0].get_coverage() == 100
  //         //  && B_op01_cg_df_vals[0].get_coverage() == 100 && B_op01_cg_dt_vals[0].get_coverage() == 100
  //         //  && B_op11_cg_df_vals[0].get_coverage() == 100 && B_op11_cg_dt_vals[0].get_coverage() == 100
  //         //  && A_B_en_cg_df_vals[0].get_coverage() == 100 && A_B_en_cg_dt_vals[0].get_coverage() == 100
  //         //  && ALU_en_cg_df_vals[0].get_coverage() == 100 && ALU_en_cg_dt_vals[0].get_coverage() == 100
  //         //  && C_cg_df_vals[0].get_coverage() == 100        
  //          ) 
  //         apb_sequence_item_mon::cov_target = 1;
  //     end

  //     "repitition_test": begin
  //       if(a_op_repi_cg.get_coverage()==100)  apb_sequence_item_mon::a_op_cov_repi_trgt = 1;
  //       if(b_op01_repi_cg.get_coverage()==100)  apb_sequence_item_mon::b_op01_cov_repi_trgt = 1;
  //       if(b_op11_repi_cg.get_coverage()==100)  apb_sequence_item_mon::b_op11_cov_repi_trgt = 1; 
  //       if(a_op_repi_cg.get_coverage()==100 && b_op01_repi_cg.get_coverage()==100
  //          && b_op11_repi_cg.get_coverage()==100) 
  //         apb_sequence_item_mon::cov_target = 1;      
  //     end

  //     "error_test": begin
  //       if(error_cg.get_coverage()==100)
  //         apb_sequence_item_mon::cov_target = 1;  
  //     end
  //   endcase
  // endtask
  
  //---------------------------------------
  // Report phase
  //---------------------------------------
  // function void report_phase(uvm_phase phase);
  //   `uvm_info(get_type_name(), $sformatf("Received transactions: %0d", count_trans), UVM_LOW)

  //   `uvm_info(get_type_name(), "\nCoverage Report:", UVM_LOW)
  //   `uvm_info(get_type_name(), $sformatf("TEST_NAME = %s", test_name), UVM_LOW)
    
    
  //   case(test_name)
  //     "random_test": begin 
  //       `uvm_info(get_type_name(), $sformatf("Control        Coverage: %.2f%%", control_cg.get_coverage()), UVM_LOW)
  //       `uvm_info(get_type_name(), $sformatf("Input Values   Coverage: %.2f%%", input_values_cg.get_coverage()), UVM_LOW)
  //       `uvm_info(get_type_name(), $sformatf("A Operations   Coverage: %.2f%%", a_operations_cg.get_coverage()), UVM_LOW)
  //       `uvm_info(get_type_name(), $sformatf("B Operations01 Coverage: %.2f%%", b_operations01_cg.get_coverage()), UVM_LOW)
  //       `uvm_info(get_type_name(), $sformatf("B Operations11 Coverage: %.2f%%", b_operations11_cg.get_coverage()), UVM_LOW)    
  //       `uvm_info(get_type_name(), $sformatf("Output Values  Coverage: %.2f%%", output_values_cg.get_coverage()), UVM_LOW)
  //       `uvm_info(get_type_name(), $sformatf("Data Ranges    Coverage: %.2f%%", data_ranges_cg.get_coverage()), UVM_LOW)
  //       `uvm_info(get_type_name(), $sformatf("Stability      Coverage: %.2f%%", stability_cg.get_coverage()), UVM_LOW)
  //       `uvm_info(get_type_name(), $sformatf("Special Cases  Coverage: %.2f%%", special_cases_cg.get_coverage()), UVM_LOW)

  //       `uvm_info(get_type_name(), $sformatf("A_cg_df  Coverage: %.2f%%", A_cg_df_vals[0].get_coverage()), UVM_LOW)
  //       `uvm_info(get_type_name(), $sformatf("B_cg_df  Coverage: %.2f%%", B_cg_df_vals[0].get_coverage()), UVM_LOW)

  //       // `uvm_info(get_type_name(), $sformatf("A_op_cg_df  Coverage: %.2f%%", A_op_cg_df_vals[0].get_coverage()), UVM_LOW)
  //       // `uvm_info(get_type_name(), $sformatf("A_op_cg_dt  Coverage: %.2f%%", A_op_cg_dt_vals[0].get_coverage()), UVM_LOW)

  //       // `uvm_info(get_type_name(), $sformatf("B_op01_cg_df  Coverage: %.2f%%", B_op01_cg_df_vals[0].get_coverage()), UVM_LOW)
  //       // `uvm_info(get_type_name(), $sformatf("B_op01_cg_dt  Coverage: %.2f%%", B_op01_cg_dt_vals[0].get_coverage()), UVM_LOW)

  //       // `uvm_info(get_type_name(), $sformatf("B_op11_cg_df  Coverage: %.2f%%", B_op11_cg_df_vals[0].get_coverage()), UVM_LOW)
  //       // `uvm_info(get_type_name(), $sformatf("B_op11_cg_dt  Coverage: %.2f%%", B_op11_cg_dt_vals[0].get_coverage()), UVM_LOW)

  //       // `uvm_info(get_type_name(), $sformatf("A_B_en_cg_df  Coverage: %.2f%%", A_B_en_cg_df_vals[0].get_coverage()), UVM_LOW)
  //       // `uvm_info(get_type_name(), $sformatf("A_B_en_cg_dt  Coverage: %.2f%%", A_B_en_cg_dt_vals[0].get_coverage()), UVM_LOW) 

  //       // `uvm_info(get_type_name(), $sformatf("ALU_en_cg_df  Coverage: %.2f%%", ALU_en_cg_df_vals[0].get_coverage()), UVM_LOW)
  //       // `uvm_info(get_type_name(), $sformatf("ALU_en_cg_dt  Coverage: %.2f%%", ALU_en_cg_dt_vals[0].get_coverage()), UVM_LOW)

  //       // `uvm_info(get_type_name(), $sformatf("C_cg_df  Coverage: %.2f%%", C_cg_df_vals[0].get_coverage()), UVM_LOW)                      
  //     end
      
  //     "repitition_test": begin 
  //       `uvm_info(get_type_name(), $sformatf("repitition cg for op_A Coverage: %.2f%%", a_op_repi_cg.get_coverage()), UVM_LOW)
  //       `uvm_info(get_type_name(), $sformatf("repitition cg for op_B1 Coverage: %.2f%%", b_op01_repi_cg.get_coverage()), UVM_LOW)
  //       `uvm_info(get_type_name(), $sformatf("repitition cg for op_B2 Coverage: %.2f%%", b_op11_repi_cg.get_coverage()), UVM_LOW)   
  //     end

  //     "error_test": begin
  //       `uvm_info(get_type_name(), $sformatf("Error Cases Coverage: %.2f%%", error_cg.get_coverage()), UVM_LOW)
  //     end
  //   endcase
  //   `uvm_info(get_type_name(), $sformatf("Total Coverage: %.2f%%", $get_coverage()), UVM_LOW)  
    


  // endfunction : report_phase

endclass : apb_coverage