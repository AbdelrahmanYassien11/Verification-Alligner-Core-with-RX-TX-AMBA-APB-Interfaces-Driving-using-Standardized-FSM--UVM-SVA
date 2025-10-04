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

    apb_agent agt;

    uvm_analysis_port#(apb_sequence_item_mon) agt2env_;

    uvm_analysis_port#(apb_sequence_item_mon) env2scb_;
    uvm_analysis_port#(apb_sequence_item_mon) env2sub_;

    //------------------------------------------
    // Constructor for the environment component
    //------------------------------------------
        function new(string name = "apb_env", uvm_component parent);
            super.new(name, parent);
        endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //Creating environment components
            agt = apb_agent::type_id::create("agt", this);

            //Creating environment TLM Connections
            agt2env_ = new("agt2env_", this);
            env2scb_ = new("env2scb_", this);
            env2sub_ = new("env2sub_", this);
        endfunction : build_phase

    //---------------------------------------------------------
    // Connect Phase to connect the Enviornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
        endfunction : connect_phase

    endclass : apb_env

`endif