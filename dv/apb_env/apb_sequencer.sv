/******************************************************************
 * File:   apb_sequencer.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb sequenceritor, where the apb
 *              sequenceritor's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_sequencer
`define AY_APB_sequencer

    class apb_sequencer extends uvm_sequenceritor;
    `uvm_component_utils(apb_sequencer)

    //------------------------------------------
    // Constructor for the sequencerironment component
    //------------------------------------------
        function new(string name = "apb_sequencer", uvm_component parent)
            super.new(name, parent);
        endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
        function void build_phase(uvm_phase phase)
            super.build_phase(phase);
        endfunction : build_phsae

    //---------------------------------------------------------
    // Connect Phase to connect the sequenceriornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase)
            super.connect_phase(phase);
        endfunction : connect_phase

    endclass : apb_sequencer