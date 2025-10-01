/******************************************************************
 * File:   apb_env.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb env, where apb env
 *              components are inestantiated, created and 
 *              connected.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_ENV
`define AY_APB_ENV

    class apb_env extends uvm_env;
    `uvm_component_utils(apb_env)

    //------------------------------------------
    // Constructor for the environment component
    //------------------------------------------
        function new(string name = "apb_env", uvm_component parent)
            super.new(name, parent);
        endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
        function void build_phase(uvm_phase phase)
            super.build_phase(phase);
        endfunction : build_phsae

    //---------------------------------------------------------
    // Connect Phase to connect the Enviornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase)
            super.connect_phase(phase);
        endfunction : connect_phase

    endclass : apb_env

`endif