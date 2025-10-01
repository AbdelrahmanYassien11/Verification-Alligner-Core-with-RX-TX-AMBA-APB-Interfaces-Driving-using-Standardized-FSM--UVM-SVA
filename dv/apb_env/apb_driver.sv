/******************************************************************
 * File:   apb_driver.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb driver, where the apb
 *              driver's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_DRV
`define AY_APB_DRV

    class apb_driver extends uvm_driver;
    `uvm_component_utils(apb_driver)

    //------------------------------------------
    // Constructor for the driverironment component
    //------------------------------------------
        function new(string name = "apb_driver", uvm_component parent)
            super.new(name, parent);
        endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
        function void build_phase(uvm_phase phase)
            super.build_phase(phase);
        endfunction : build_phsae

    //---------------------------------------------------------
    // Connect Phase to connect the driveriornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase)
            super.connect_phase(phase);
        endfunction : connect_phase

    endclass : apb_driver

`endif