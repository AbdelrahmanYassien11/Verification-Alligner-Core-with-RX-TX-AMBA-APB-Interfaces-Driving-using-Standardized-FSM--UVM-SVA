/******************************************************************
 * File:   env_config.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb agent config, where the apb
 *              agent config's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_ENV_CFG
`define AY_ENV_CFG

    class env_config extends uvm_object;

        // agent config file instance
        apb_agent_config apb_agt_cfg;
        // Agent configurations
        uvm_active_passive_enum apb_agt_is_active;
        //==========================================================================
        // ENVIRONMENT STRUCTURE CONTROL
        //==========================================================================
        // What components to instantiate
        local bit has_scoreboard = 1;
        local bit has_coverage_collector = 1;
        local bit has_reg_adapter = 0;
        
        //==========================================================================
        // ENVIRONMENT-LEVEL BEHAVIOR
        //==========================================================================
        // Scoreboard settings
        
        // Coverage settings
        local bit enable_functional_coverage = 1;


        // Register with factory
        `uvm_object_utils_begin(env_config)
            `uvm_field_int(has_scoreboard, UVM_DEFAULT)
            `uvm_field_int(has_coverage_collector, UVM_DEFAULT)
            `uvm_field_int(has_reg_adapter, UVM_DEFAULT)
        `uvm_object_utils_end
        
        // Constructor
        function new(string name = "");
            super.new(name);
        endfunction : new
    

    endclass : env_config
`endif