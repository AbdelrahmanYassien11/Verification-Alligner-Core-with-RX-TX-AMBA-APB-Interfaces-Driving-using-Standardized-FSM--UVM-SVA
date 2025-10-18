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

`ifndef AY_APB_WR_SEQ
`define AY_APB_WR_SEQ

    class write_read_sequence extends apb_base_sequence;

        // Class Registeration
        `uvm_object_utils(write_read_sequence)

        //------------------------------------------
        // Constructor for the Environment Object
        //------------------------------------------
            function new(string name = "");
                super.new(name);
            endfunction : new

        //---------------
        // Pre-Body task
        //---------------
            virtual task pre_body;
                super.pre_body();
            endtask : pre_body

        //---------------
        // Body task
        //---------------
            virtual task body;
                apb_sequence_item_drv req;
                super.body();
                req = apb_sequence_item_drv::type_id::create("req");

                start_item(req);
                if(!(req.randomize() with {dir == WRITE; addr == 'h0000; data == 'h0000_0010;}))
                    `uvm_fatal(get_type_name(), "Failed to randomize sequence item")
                finish_item(req);

                start_item(req);
                if(!(req.randomize() with {dir == READ; addr == 'h000C;}))
                    `uvm_fatal(get_type_name(), "Failed to randomize sequence item")
                finish_item(req);
            endtask : body

    endclass : write_read_sequence

`endif