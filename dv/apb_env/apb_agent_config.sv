/******************************************************************
 * File:   apb_agent_config.sv
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
`ifndef AY_APB_AGT_CFG
`define AY_APB_AGT_CFG

    class apb_agent_config extends uvm_component;
    `uvm_component_utils(apb_agent_config)

    local apb_vif vif;
    local bit has_checks = 1;
    local int hang_threshold = 200;
    local uvm_active_passive_enum is_active = UVM_ACTIVE;

    //------------------------------------------
    // Constructor for the monironment component
    //------------------------------------------
        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            
            // Setter & Getter
            // if(! uvm_config_db#(virtual apb_if)::get(this,"","vif",vif))
            //     `uvm_fatal(get_type_name(), "FAILED TO GET VIRTUAL INTERFACE INSTANCE")
        endfunction : build_phase

    //Getter for the APB virtual interface
        virtual function apb_vif get_vif();
            return this.vif;
        endfunction
        
    //Setter for the APB virtual interface
        virtual function void set_config(apb_vif value, bit has_checks, int hang_threshold, uvm_active_passive_enum is_active);
            if(this.vif == null) begin
                this.vif = value;
                this.has_checks = has_checks;
                this.hang_threshold = hang_threshold;
                this.is_active = is_active;
            end
            else begin
                `uvm_fatal(get_type_name(), "Trying to set the APB virtual interface more than once")
            end
        endfunction : set_config

    //Getter for the agent type flag
        virtual function uvm_active_passive_enum get_is_active();
            return this.is_active;
        endfunction : get_is_active

    //Getter for the checks enable flag
        virtual function int get_hang_threshold();
            return this.hang_threshold;
        endfunction : get_hang_threshold

    //Getter for the checks enable flag
        virtual function get_has_checks();
            return this.has_checks;
        endfunction : get_has_checks


    //-------------------------------------------------------------------------------------------------------------------------
    // Start of Simulation Phase to check if things that are gonna be used inside the run/main phase are working correctly
    //-------------------------------------------------------------------------------------------------------------------------
        virtual function void start_of_simulation_phase(uvm_phase phase);
            super.start_of_simulation_phase(phase);
            
            if(get_vif() == null) begin
                `uvm_fatal(get_type_name(), "The APB virtual interface is not configured at \"Start of simulation\" phase")
            end
            else begin
                `uvm_info(get_type_name(), "The APB virtual interface is configured at \"Start of simulation\" phase", UVM_DEBUG)
            end
        endfunction

    endclass : apb_agent_config



`endif