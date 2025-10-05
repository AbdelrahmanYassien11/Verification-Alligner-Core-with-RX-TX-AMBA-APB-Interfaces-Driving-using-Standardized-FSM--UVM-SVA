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

`ifndef AY_APB_BASE_SEQ
`define AY_APB_BASE_SEQ

    class apb_base_sequence extends uvm_sequence;

        apb_sequencer seqr;

        // Class Registeration
        `uvm_object_utils(apb_base_sequence)

        //------------------------------------------
        // Constructor for the Environment Object
        //------------------------------------------
            function new(string name = "");
                super.new(name);
            endfunction : new

            virtual task pre_body;
                super.pre_body();
            endtask : pre_body

            virtual task body;
                super.body();
            endtask : body

    endclass : apb_base_sequence

`endif