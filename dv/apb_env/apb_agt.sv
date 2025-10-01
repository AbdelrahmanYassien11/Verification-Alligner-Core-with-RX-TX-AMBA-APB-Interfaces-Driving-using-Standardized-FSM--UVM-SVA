/******************************************************************
 * File:   apb_agt.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb agt, where the apb
 *              agt's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_agt
`define AY_APB_agt

    class apb_agt extends uvm_agt;
    `uvm_component_utils(apb_agt)

    //------------------------------------------
    // Constructor for the agtironment component
    //------------------------------------------
        function new(string name = "apb_agt", uvm_component parent)
            super.new(name, parent);
        endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
        function void build_phase(uvm_phase phase)
            super.build_phase(phase);
        endfunction : build_phsae

    //---------------------------------------------------------
    // Connect Phase to connect the agtiornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase)
            super.connect_phase(phase);
        endfunction : connect_phase

    endclass : apb_agt

`endif