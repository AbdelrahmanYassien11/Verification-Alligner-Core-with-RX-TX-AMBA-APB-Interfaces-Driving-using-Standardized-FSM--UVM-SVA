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

`ifndef AY_APB_SEQ_ITEM_DRV
`define AY_APB_SEQ_ITEM_DRV
    class apb_sequence_item_drv extends apb_base_sequence_item;

        rand int unsigned pre_send_delay, post_send_delay;

        // Field Registeration
        `uvm_object_utils_begin(apb_sequence_item_drv)
        // APB Inputs
        // `uvm_field_int(addr, UVM_ALL_ON | UVM_HEX)
        // `uvm_field_int(data, UVM_ALL_ON | UVM_HEX)
        // `uvm_field_enum(apb_dir, dir, UVM_ALL_ON)
        // Test Specific
        `uvm_field_int(pre_send_delay, UVM_ALL_ON | UVM_DEC | UVM_NOCOMPARE)
        `uvm_field_int(post_send_delay, UVM_ALL_ON | UVM_DEC | UVM_NOCOMPARE)
        `uvm_object_utils_end
        
        constraint pre_drive_delay  {pre_send_delay  inside {[1:10]};};
        constraint post_drive_delay {post_send_delay inside {[1:10]};};
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
            string s = super.convert2string();
            s = $sformatf("%0s, PRE-D: %0d, POST-D: %0d", 
                            s, pre_send_delay, post_send_delay);
            return s;
        endfunction

    endclass : apb_sequence_item_drv

`endif