 covergroup pwrite_data_df_tog_cg(input bit [AY_APB_MAX_DATA_WIDTH-1:0] position, input apb_sequence_item_mon cov, ref bit has_coverage);
    option.per_instance = 1;
    df: coverpoint (cov.pwrite_data & position) != 0 iff(has_coverage);
 endgroup : pwrite_data_df_tog_cg

 covergroup pwrite_data_dt_tog_cg(input bit [AY_APB_MAX_DATA_WIDTH-1:0] position, input apb_sequence_item_mon cov, ref bit has_coverage);
    option.per_instance = 1;    
    dt: coverpoint (cov.pwrite_data & position) != 0  iff(has_coverage){
          bins tr[] = (0 => 1, 1 => 0);
      }
 endgroup : pwrite_data_dt_tog_cg

covergroup pwrite_cg_df(input int i, input apb_sequence_item_mon cov, ref bit has_coverage);
	option.name = (i == WRITE) ? "WRITE" :
                (i == READ)  ? "READ" :
                "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.dir iff (has_coverage/* reset & Penable & PSEL*/) {
		bins dir[] = {i};
	}
endgroup : pwrite_cg_df

covergroup pwrite_cg_dt(input int i, input int k, input apb_sequence_item_mon cov, ref bit has_coverage);
	option.name = ((i == WRITE) && (k == READ))  ? "WRITE => READ" :
                ((i == READ)  && (k == WRITE)) ? "READ  => WRITE":
                ((i == WRITE) && (k == WRITE)) ? "WRITE => WRITE":
                ((i == READ) && (k == READ))   ? "READ  => READ":
                  "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.dir iff (has_coverage/* reset & Penable & PSEL*/) {
		bins dir[] = (i => k);
	}
endgroup : pwrite_cg_dt


covergroup pready_cg_df(input int i, input apb_sequence_item_mon cov, ref bit has_coverage);
	option.name = (i == READY) ?  "READY" :
                (i == NREADY)? "NOT READY" :
                "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.pready iff (has_coverage/* reset & Penable & PSEL*/) {
		bins dir[] = {i};
	}
endgroup : pready_cg_df

covergroup pready_cg_dt(input int i, input int k, input apb_sequence_item_mon cov, ref bit has_coverage);
	option.name = ((i == READY) && (k == NREADY))  ? "READY => NREADY" :
                ((i == NREADY)  && (k == READY)) ? "NREADY  => READY":
                ((i == READY) && (k == READY)) ?   "READY => READY":
                ((i == NREADY) && (k == NREADY)) ? "NREADY  => NREADY":
                  "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.pready iff (has_coverage/* reset & Penable & PSEL*/) {
		bins dir[] = (i => k);
	}
endgroup : pready_cg_dt


covergroup pslverr_cg_df(input int i, input apb_sequence_item_mon cov, ref bit has_coverage);
	option.name = (i == OK) ?  "OK" :
                (i == ERROR)? "ERROR" :
                "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.pslverr iff (has_coverage/* reset & Penable & PSEL*/) {
		bins dir[] = {i};
	}
endgroup : pslverr_cg_df

covergroup pslverr_cg_dt(input int i, input int k, input apb_sequence_item_mon cov, ref bit has_coverage);
	option.name = ((i == OK) && (k == ERROR))  ? "OK => ERROR" :
                ((i == ERROR)  && (k == OK)) ? "ERROR  => OK":
                ((i == OK) && (k == OK)) ?   "OK => OK":
                ((i == ERROR) && (k == ERROR)) ? "ERROR  => ERROR":
                  "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.pslverr iff (has_coverage/* reset & Penable & PSEL*/) {
		bins dir[] = (i => k);
	}
endgroup : pslverr_cg_dt


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

  pwrite_df_tog_cg pwrite_df_tog_cg_bits  [AY_APB_MAX_DATA_WIDTH-1:0];
  pwrite_dt_tog_cg pwrite_df_tog_cg_bits  [AY_APB_MAX_DATA_WIDTH-1:0];

	pwrite_cg_df   pwrite_cg_df_vals   [2**1];
	pwrite_cg_dt   pwrite_cg_dt_vals   [2**1] [2**1];

  pslverr_cg_df   pslverr_cg_df_vals   [2**1];
	pslverr_cg_dt   pslverr_cg_dt_vals   [2**1] [2**1];

  pready_cg_df   pready_cg_df_vals   [2**1];
	pready_cg_dt   pready_cg_dt_vals   [2**1] [2**1];

  // Register with factory
  `uvm_component_utils_begin(apb_coverage)
  `uvm_field_int(count_trans, UVM_DEFAULT)
  `uvm_component_utils_end

  bit has_coverage;


 covergroup time_b4_txn_cg with function sample(apb_sequence_item_mon cov);
    // 1: Number Cycles Before Transaction
    LONG_txn: coverpoint cov.cycles_b4_item iff (apb_agt_cfg.get_has_coverage()) {
      bins LONG = {[20:$]};
    }
    SHORT_txn: coverpoint cov.cycles_b4_item iff (apb_agt_cfg.get_has_coverage()) {
      bins SHORT = {[1:5]};
    }
    MEDIUM_txn: coverpoint cov.cycles_b4_item iff (apb_agt_cfg.get_has_coverage()) {
      bins MEDIUM = {[5:20]};
    }
  endgroup : time_b4_txn_cg

 covergroup txn_len_cg with function sample(apb_sequence_item_mon cov);
    // 2: Transaction Length
    LONG_txn: coverpoint cov.transaction_length iff (apb_agt_cfg.get_has_coverage()) {
      bins LONG = {[20:$]};
    }
    SHORT_txn: coverpoint cov.transaction_length iff (apb_agt_cfg.get_has_coverage()) {
      bins SHORT = {[1:5]};
    }
    MEDIUM_txn: coverpoint cov.transaction_length iff (apb_agt_cfg.get_has_coverage()) {
      bins MEDIUM = {[5:20]};
    }
  endgroup : txn_len_cg

  covergroup addr_dt_cg with function sample(apb_sequence_item_mon cov);
    dt: coverpoint cov.transaction_length iff (apb_agt_cfg.get_has_coverage()) {
      bins CTRL_to_STATUS = (CTRL_ADDR    => STATUS_ADDR);
      bins STATUS_to_CTRL = (STATUS_ADDR  => CTRL_ADDR);
      bins IRQEN_to_IRQ   = (IRQEN_ADDR   => IRQ_ADDR);
      bins IRQ_to_IRQEN   = (IRQ_ADDR     => IRQEN_ADDR);
    }
  endgroup

  covergroup addr_df_cg with function sample(apb_sequence_item_mon cov);
    df: coverpoint cov.transaction_length iff (apb_agt_cfg.get_has_coverage()) {
      bins CTRL    = {CTRL_ADDR};
      bins STATUS  = {STATUS_ADDR};
      bins IRQEN   = {IRQEN_ADDR};
      bins IRQ     = {IRQ_ADDR};
    }
  endgroup

  covergroup dir_repi_cg with function sample(apb_sequence_item_mon cov);
    // 2: Repeated operations
    dir_repeat: coverpoint cov.dir iff (apb_agt_cfg.get_has_coverage()) {
      bins dir_repeats[] = {([READ:WRITE] [* 5])};
    }
    ready_repeat: coverpoint cov.dir iff (apb_agt_cfg.get_has_coverage()) {
      bins READY_repeats[] = ([NREADY:READY] [* 5]);
    }
    error_repeat: coverpoint cov.dir iff (apb_agt_cfg.get_has_coverage()) {
      bins ERROR_repeats[] = ([OK:ERROR] [* 5]);
    }
  endgroup : dir_repi_cg

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

    foreach(pslverr_cg_df_vals[i])     pslverr_cg_df_vals[i] 	  = new(i, output_cov_copied, has_coverage);
    foreach(pslverr_cg_dt_vals[i,k])   pslverr_cg_dt_vals[i][k] = new(i, k, output_cov_copied, has_coverage);

    foreach(pready_cg_df_vals[i])     pready_cg_df_vals[i] 	  = new(i, output_cov_copied, has_coverage);
    foreach(pready_cg_dt_vals[i,k])   pready_cg_dt_vals[i][k] = new(i, k, output_cov_copied, has_coverage);


    dir_repi_cg     = new();
    txn_len_cg      = new();
    time_b4_txn_cg  = new();
    addr_df_cg      = new();
    addr_dt_cg      = new();
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

      foreach(pslverr_cg_df_vals[i]) pslverr_cg_df_vals[i].sample();
      foreach(pslverr_cg_dt_vals[i,j]) pslverr_cg_dt_vals[i][j].sample();

      foreach(pready_cg_df_vals[i]) pready_cg_df_vals[i].sample();
      foreach(pready_cg_dt_vals[i,j]) pready_cg_dt_vals[i][j].sample();

      dir_repi_cg.sample(output_cov_copied);
      time_b4_txn_cg.sample(output_cov_copied);
      txn_len_cg.sample(output_cov_copied);
      addr_df_cg.sample(output_cov_copied);
      addr_dt_cg.sample(output_cov_copied);
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