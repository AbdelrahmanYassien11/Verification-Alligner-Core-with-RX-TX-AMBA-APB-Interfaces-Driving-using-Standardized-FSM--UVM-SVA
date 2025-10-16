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

`ifndef AY_APB_SEQ_ITEM_BASE
`define AY_APB_SEQ_ITEM_BASE
    class apb_base_sequence_item extends uvm_sequence_item;


        rand apb_addr        addr;
        rand apb_dir         dir;
        rand apb_data        data;

        `uvm_object_utils_begin(apb_base_sequence_item)
            // APB Inputs
            `uvm_field_int(addr, UVM_ALL_ON | UVM_HEX)
            `uvm_field_int(data, UVM_ALL_ON | UVM_HEX)
            `uvm_field_enum(apb_dir, dir, UVM_ALL_ON)
        `uvm_object_utils_end
    //------------------------------------------
    // Constructor for the Environment Object
    //------------------------------------------
        function new(string name = "");
            super.new(name);
        endfunction : new

    endclass : apb_base_sequence_item
`endif