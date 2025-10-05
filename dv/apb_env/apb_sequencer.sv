/******************************************************************
 * File:   apb_sequencer.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb sequencer, where the apb
 *              sequencer's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_SEQR
`define AY_APB_SEQR

    class apb_sequencer extends uvm_sequencer#(apb_sequence_item_drv, apb_sequence_item_mon);
    `uvm_component_utils(apb_sequencer)

    //------------------------------------------
    // Constructor for the sequencerironment component
    //------------------------------------------
        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction : build_phase

    //---------------------------------------------------------
    // Connect Phase to connect the sequenceriornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
        endfunction : connect_phase

    endclass : apb_sequencer

`endif