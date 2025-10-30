 covergroup pwdata_df_tog_cg(input apb_data position, input apb_sequence_item_mon cov);
    option.per_instance = 1;
    df: coverpoint (cov.data & position) != 0 ;
 endgroup : pwdata_df_tog_cg

 covergroup pwdata_dt_tog_cg(input apb_data position, input apb_sequence_item_mon cov);
    option.per_instance = 1;    
    dt: coverpoint (cov.data & position) != 0  {
      bins tr[] = (0 => 1, 1 => 0);
    }
 endgroup : pwdata_dt_tog_cg

  covergroup addr_cg_dt (input int i, input int k, input apb_sequence_item_mon cov);
    option.name = $sformatf("%0h => %0h", reg_addrs[i], reg_addrs[k]);
    coverpoint cov.addr {
      // auto-generate all transitions dynamically
      bins addr_dt[] = (reg_addrs[i] => reg_addrs[k]);
    }
  endgroup : addr_cg_dt

covergroup pwrite_cg_df(input int i, input apb_sequence_item_mon cov);
	option.name = (i == WRITE) ? "WRITE" :
                (i == READ)  ? "READ" :
                "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.dir {
		bins dir[] = {i};
	}
endgroup : pwrite_cg_df

covergroup pwrite_cg_dt(input int i, input int k, input apb_sequence_item_mon cov);
	option.name = ((i == WRITE) && (k == READ))  ? "WRITE => READ" :
                ((i == READ)  && (k == WRITE)) ? "READ  => WRITE":
                ((i == WRITE) && (k == WRITE)) ? "WRITE => WRITE":
                ((i == READ) && (k == READ))   ? "READ  => READ":
                  "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.dir {
		bins dir[] = (i => k);
	}
endgroup : pwrite_cg_dt

covergroup pready_cg_df(input int i, input apb_sequence_item_mon cov);
	option.name = (i == READY) ?  "READY" :
                (i == NREADY)? "NOT READY" :
                "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.pready {
		bins dir[] = {i};
	}
endgroup : pready_cg_df

covergroup pready_cg_dt(input int i, input int k, input apb_sequence_item_mon cov);
	option.name = ((i == READY) && (k == NREADY))  ? "READY => NREADY" :
                ((i == NREADY)  && (k == READY)) ? "NREADY  => READY":
                ((i == READY) && (k == READY)) ?   "READY => READY":
                ((i == NREADY) && (k == NREADY)) ? "NREADY  => NREADY":
                  "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.pready {
		bins dir[] = (i => k);
	}
endgroup : pready_cg_dt

covergroup pslverr_cg_df(input int i, input apb_sequence_item_mon cov);
	option.name = (i == OK) ?  "OK" :
                (i == ERROR)? "ERROR" :
                "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.pslverr {
		bins dir[] = {i};
	}
endgroup : pslverr_cg_df

covergroup pslverr_cg_dt(input int i, input int k, input apb_sequence_item_mon cov);
	option.name = ((i == OK) && (k == ERROR))  ? "OK => ERROR" :
                ((i == ERROR)  && (k == OK)) ? "ERROR  => OK":
                ((i == OK) && (k == OK)) ?   "OK => OK":
                ((i == ERROR) && (k == ERROR)) ? "ERROR  => ERROR":
                  "Invalid";
	option.per_instance = 1;
	df: coverpoint cov.pslverr {
		bins dir[] = (i => k);
	}
endgroup : pslverr_cg_dt

class apb_coverage_comp_wrapper#(type T = int, int unsigned IDX = 4 ) extends uvm_component;
  `uvm_component_param_utils(apb_coverage_comp_wrapper#(int, IDX))

  covergroup cov_idx with function sample(int unsigned val);
    option.per_instance = 1;
    index: coverpoint val{
      option.comment = "index";
      bins vals[IDX] = {[0:IDX]};
    }
  endgroup
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      
      cov_idx = new();
	    cov_idx.set_inst_name($sformatf("%s_%s", get_full_name(), "cov_idx"));
    endfunction
    
    //Function to print the coverage information.
    //This is only to be able to visualize some basic coverage information
    //in EDA Playground.
    //DON'T DO THIS IN A REAL PROJECT!!!
    virtual function string coverage2string();
      return {
        $sformatf("\n   cover_index:              %03.2f%%", cov_idx.get_inst_coverage()),
        $sformatf("\n      index:                 %03.2f%%", cov_idx.index.get_inst_coverage())
      };
    endfunction
    
    //Function used to sample the information
    virtual function void sample(int unsigned value);
      cov_idx.sample(value);
    endfunction

endclass : apb_coverage_comp_wrapper

class apb_coverage extends uvm_component;

    //Wrapper over the coverage group covering the indices in the PADDR signal
    //at which the bit of the PADDR was 0
    apb_coverage_comp_wrapper#(int, `AY_APB_MAX_ADDR_WIDTH) wrap_cover_addr_0;

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

  pwdata_df_tog_cg pwdata_df_tog_cg_bits  [`AY_APB_MAX_DATA_WIDTH-1:0];
  pwdata_dt_tog_cg pwdata_dt_tog_cg_bits  [`AY_APB_MAX_DATA_WIDTH-1:0];

	pwrite_cg_df   pwrite_cg_df_vals   [2**1];
	pwrite_cg_dt   pwrite_cg_dt_vals   [2**1] [2**1];

  pslverr_cg_df   pslverr_cg_df_vals   [2**1];
	pslverr_cg_dt   pslverr_cg_dt_vals   [2**1] [2**1];

  pready_cg_df   pready_cg_df_vals   [2**1];
	pready_cg_dt   pready_cg_dt_vals   [2**1] [2**1];

  addr_cg_dt     addr_cg_dt_vals    [4] [4];

  // Register with factory
  `uvm_component_utils_begin(apb_coverage)
  `uvm_field_int(count_trans, UVM_DEFAULT)
  `uvm_component_utils_end

  bit has_coverage;


 covergroup time_b4_txn_cg with function sample(apb_sequence_item_mon cov);
    // 1: Number Cycles Before Transaction
    LONG_txn: coverpoint cov.cycles_b4_item  {
      bins LONG = {[20:$]};
    }
    SHORT_txn: coverpoint cov.cycles_b4_item  {
      bins SHORT = {[1:5]};
    }
    MEDIUM_txn: coverpoint cov.cycles_b4_item  {
      bins MEDIUM = {[5:20]};
    }
  endgroup : time_b4_txn_cg

 covergroup txn_len_cg with function sample(apb_sequence_item_mon cov);
    // 2: Transaction Length
    LONG_txn: coverpoint cov.transaction_length  {
      bins LONG = {[20:$]};
    }
    SHORT_txn: coverpoint cov.transaction_length  {
      bins SHORT = {[1:5]};
    }
    MEDIUM_txn: coverpoint cov.transaction_length  {
      bins MEDIUM = {[5:20]};
    }
  endgroup : txn_len_cg


  covergroup addr_df_cg with function sample(apb_sequence_item_mon cov);
    df: coverpoint cov.addr  {
      bins CTRL    = {CTRL_ADDR};
      bins STATUS  = {STATUS_ADDR};
      bins IRQEN   = {IRQEN_ADDR};
      bins IRQ     = {IRQ_ADDR};
    }
  endgroup

  covergroup dir_repi_cg with function sample(apb_sequence_item_mon cov);
    // 2: Repeated operations
    dir_repeat: coverpoint cov.dir  {
      bins dir_repeats[] = ([READ:WRITE] [* 5]);
    }
    ready_repeat: coverpoint cov.dir  {
      bins READY_repeats[] = ([NREADY:READY] [* 5]);
    }
    error_repeat: coverpoint cov.dir  {
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

      `uvm_info(get_type_name(), "Coverage for APB Agent is Turned On", UVM_LOW)
      foreach(pwdata_df_tog_cg_bits[i]) pwdata_df_tog_cg_bits[i] = new(1<<i,output_cov_copied);
      foreach(pwdata_dt_tog_cg_bits[i]) pwdata_dt_tog_cg_bits[i] = new(1<<i,output_cov_copied);

      foreach(addr_cg_dt_vals[i,j]) addr_cg_dt_vals[i][j] = new(i, j, output_cov_copied);

      foreach(pwrite_cg_df_vals[i])     pwrite_cg_df_vals[i] 	  = new(i, output_cov_copied);
      foreach(pwrite_cg_dt_vals[i,k])   pwrite_cg_dt_vals[i][k] = new(i, k, output_cov_copied);

      foreach(pslverr_cg_df_vals[i])     pslverr_cg_df_vals[i] 	  = new(i, output_cov_copied);
      foreach(pslverr_cg_dt_vals[i,k])   pslverr_cg_dt_vals[i][k] = new(i, k, output_cov_copied);

      foreach(pready_cg_df_vals[i])     pready_cg_df_vals[i] 	  = new(i, output_cov_copied);
      foreach(pready_cg_dt_vals[i,k])   pready_cg_dt_vals[i][k] = new(i, k, output_cov_copied);

      dir_repi_cg     = new();
      txn_len_cg      = new();
      time_b4_txn_cg  = new();
      addr_df_cg      = new();

   
  endfunction : new

  //---------------------------------------
  // Build phase
  //---------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // Create analysis exports
    // reset_collected_export = new ("reset_collected_export",this);  
    analysis_export_inputs = new("analysis_export_inputs", this);
    analysis_export_outputs = new("analysis_export_outputs", this);


    // Create TLM FIFOs
    // reset_fifo = new("reset_fifo", this);
    inputs_fifo = new("inputs_fifo", this);
    outputs_fifo = new("outputs_fifo", this);


    wrap_cover_addr_0    = apb_coverage_comp_wrapper#(int, `AY_APB_MAX_ADDR_WIDTH)::type_id::create("wrap_cover_addr_0",    this);
    
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

      for(int i = 0; i < `AY_APB_MAX_ADDR_WIDTH; i++) begin
        if(output_cov_copied.addr[i]) begin
          // wrap_cover_addr_1.sample(i);
        end
        else begin
          wrap_cover_addr_0.sample(i);
        end
      end

    if(has_coverage) begin
      foreach(pwdata_df_tog_cg_bits[i]) pwdata_df_tog_cg_bits[i].sample();
      foreach(pwdata_dt_tog_cg_bits[i]) pwdata_dt_tog_cg_bits[i].sample();
      
      foreach(addr_cg_dt_vals[i,j]) addr_cg_dt_vals[i][j].sample();

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
    end

      // You could add output value checking here if needed

      // coverage_target();
    end
  endtask

  // task coverage_target();

  // endtask
  
  ---------------------------------------
  Report phase
  ---------------------------------------
  function void report_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("Received transactions: %0d", count_trans), UVM_LOW)

    `uvm_info(get_type_name(), "\nCoverage Report:", UVM_LOW)
    // `uvm_info(get_type_name(), $sformatf("TEST_NAME = %s", test_name), UVM_LOW)
    
  
    `uvm_info(get_type_name(), $sformatf("pwrite Repetition         Coverage: %.2f%%", dir_repe_cg.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Time Before Transactions  Coverage: %.2f%%", time_b4_txn_cg.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("Transaction Length        Coverage: %.2f%%", txn_len_cg.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("paddr df:                 Coverage: %.2f%%", addr_df_cg.get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("pwdata df:  Coverage: %.2f%%", pwdata_df_tog_cg_bits[0].get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("pwdata dt:  Coverage: %.2f%%", pwdata_dt_tog_cg_bits[0].get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("paddr dt:   Coverage: %.2f%%", addr_cg_dt_vals[0][0].get_coverage()), UVM_LOW)

    `uvm_info(get_type_name(), $sformatf("pwrite df:  Coverage: %.2f%%", pwrite_cg_df_vals[0].get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("pwrite dt:  Coverage: %.2f%%", pwrite_cg_dt_vals[0][0].get_coverage()), UVM_LOW)

    `uvm_info(get_type_name(), $sformatf("pslverr df:  Coverage: %.2f%%", pslverr_cg_df_vals[0].get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("pslverr dt:  Coverage: %.2f%%", pslverr_cg_dt_vals[0][0].get_coverage()), UVM_LOW)

    `uvm_info(get_type_name(), $sformatf("pready df:  Coverage: %.2f%%", pready_cg_df_vals[0].get_coverage()), UVM_LOW)
    `uvm_info(get_type_name(), $sformatf("pready dt:  Coverage: %.2f%%", pready_cg_dt_vals[0][0].get_coverage()), UVM_LOW)

    `uvm_info(get_type_name(), $sformatf("Total Coverage: %.2f%%", $get_coverage()), UVM_LOW)  
    
  endfunction : report_phase

endclass : apb_coverage