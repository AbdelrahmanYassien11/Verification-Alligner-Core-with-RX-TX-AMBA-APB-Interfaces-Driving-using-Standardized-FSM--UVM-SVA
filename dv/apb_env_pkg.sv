/******************************************************************
 * File:   apb_env_pkg.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This File is the test package file, where environment 
 *              files are being included
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/


`ifndef AY_APB_ENV_PKG
`define AY_APB_ENV_PKG
    `include "uvm_macros.svh"
    `include "apb_agt_pkg.sv"
    package apb_env_pkg;

        import uvm_pkg::*;
        `import apb_agt_pkg::*;

        `include "apb_env.sv"
    endpackage : apb_env_pkg

`endif