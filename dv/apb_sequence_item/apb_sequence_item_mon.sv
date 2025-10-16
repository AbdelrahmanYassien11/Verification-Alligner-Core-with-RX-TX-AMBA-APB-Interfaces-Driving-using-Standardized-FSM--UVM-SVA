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

        apb_pslverr     pslverr;
        apb_pready      pready;
        int unsigned    pre_send_delay;
        int unsigned    transaction_length;

        // Field Registeration
        `uvm_object_utils_begin(apb_sequence_item_mon)
        // APB Outputs
        // `uvm_field_int(addr, UVM_ALL_ON | UVM_HEX)
        // `uvm_field_int(data, UVM_ALL_ON | UVM_HEX)
        // `uvm_field_enum(apb_dir, dir, UVM_ALL_ON)
        `uvm_field_enum(apb_pslverr, pslverr, UVM_ALL_ON)
        `uvm_field_enum(apb_pready, pready, UVM_ALL_ON)
        `uvm_field_int(pre_send_delay, UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(transaction_length, UVM_ALL_ON | UVM_DEC)
        `uvm_object_utils_end

        //------------------------------------------
        // Constructor for the Environment Object
        //------------------------------------------
            function new(string name = "");
                super.new(name);
            endfunction : new

    //------------------------------------------
    // Convert item into string to be displayed
    //------------------------------------------
        virtual function string convert2string();
            super.convert2string();
            string s = $sformatf("ADDR: %0h, DIR: %0s, DATA_RD: %0h, STATE: %0s, READY: %0s, PRE-D: %0d, LEN: %0d", addr, 
                                  data, dir.name(), pslverr.name(), pready.name(), pre_send_delay, transaction_length);
            return s;
        endfunction

    endclass : apb_sequence_item_mon
`endif