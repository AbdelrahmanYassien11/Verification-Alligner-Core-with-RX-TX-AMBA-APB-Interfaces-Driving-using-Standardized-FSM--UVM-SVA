/******************************************************************
 * File:   test_config.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb agent config, where the apb
 *              agent config's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_TEST_CFG
`define AY_TEST_CFG

  class test_config extends uvm_object;
    `uvm_object_utils(test_config)

    // TEST-LEVEL settings only
    local string test_name;
    local int unsigned num_transactions = 1000;
    local int unsigned timeout_ns = 100000;
    local uvm_verbosity_level verbosity = UVM_MEDIUM;

    // Random seed control
    local int unsigned seed;

    // Test scenario control
    local bit enable_error_injection = 0;

    function new(string name = "");
      super.new(name);
    endfunction

  endclass : test_config

`endif