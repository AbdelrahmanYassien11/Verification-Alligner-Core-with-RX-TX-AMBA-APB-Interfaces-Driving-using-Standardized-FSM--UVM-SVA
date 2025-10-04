/******************************************************************
 * File:   apb_test_pkg.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This File is the test package file, where test 
 *              files are being included
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/

// `ifndef AY_APB_PKG
// `define AY_APB_PKG

    `include "uvm_macros.svh"

    package apb_pkg;

        import uvm_pkg::*;

        // `include "apb_sequence_item.sv"
        // `include "apb_types.sv"
        `include "apb_agent_config.sv"

        // `include "apb_driver.sv"
        // `include "apb_sequencer.sv"
        // `include "apb_monitor.sv"
        `include "apb_agent.sv"

        `include "apb_env.sv"

        `include "apb_base_test.sv"

    endpackage : apb_pkg
// `endif