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

`ifndef AY_APB_TEST_PKG
`define AY_APB_TEST_PKG

    `include "uvm_macros.svh"

    package apb_test_pkg;

        import uvm_pkg::*;
        import apb_agt_pkg::*;
        import apb_env_pkg::*;

        `include "apb_config.sv"
        `include "apb_base_test.sv"
        `include "one_random_test.sv"
        `include "write_read_test.sv"

    endpackage : apb_test_pkg
`endif