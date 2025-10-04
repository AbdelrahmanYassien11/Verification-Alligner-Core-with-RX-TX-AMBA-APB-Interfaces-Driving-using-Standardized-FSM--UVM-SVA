/******************************************************************
 * File:   apb_monitor.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb monitor, where the apb
 *              monitor's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_MON
`define AY_APB_MON

    class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor)

    uvm_analysis_port#(apb_sequence_item_mon) mon2agt;

    //------------------------------------------
    // Constructor for the monironment component
    //------------------------------------------
        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);

            //creating TLM PORTS
            mon2agt = new("mon2agt", this);
        endfunction : build_phase

    //---------------------------------------------------------
    // Connect Phase to connect the moniornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
        endfunction : connect_phase

    endclass : apb_monitor

`endif