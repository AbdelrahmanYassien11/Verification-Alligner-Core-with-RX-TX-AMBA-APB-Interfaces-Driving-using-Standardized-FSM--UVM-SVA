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

`ifndef AY_APB_SEQ_ITEM_MON
`define AY_APB_SEQ_ITEM_MON
    class apb_sequence_item_mon extends apb_base_sequence_item;

        apb_addr        addr;
        apb_data_rd     data_rd;
        apb_pslverr     pslverr;
        apb_pready      pready;

        // Field Registeration
        `uvm_object_utils_begin(apb_sequence_item_mon)
        // APB Outputs
        `uvm_field_int(addr, UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(data_rd, UVM_ALL_ON | UVM_HEX)
        `uvm_field_enum(apb_pslverr, pslverr, UVM_ALL_ON)
        `uvm_field_enum(apb_pready, pready, UVM_ALL_ON)
        `uvm_object_utils_end

        //------------------------------------------
        // Constructor for the Environment Object
        //------------------------------------------
            function new(string name = "");
                super.new(name);
            endfunction : new

    endclass : apb_sequence_item_mon
`endif