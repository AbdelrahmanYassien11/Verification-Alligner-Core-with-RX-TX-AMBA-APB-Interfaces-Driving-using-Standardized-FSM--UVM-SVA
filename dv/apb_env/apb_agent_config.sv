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
            if(! uvm_config_db#(virtual apb_if)::get(this,,"vif",vif))
                `uvm_fatal(get_type_name(), "FAILED TO GET VIRTUAL INTERFACE INSTANCE")
        endfunction : build_phase

    //---------------------------------------------------------
    // Connect Phase to connect the moniornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
        endfunction : connect_phase

    //Getter for the APB virtual interface
        virtual function apb_vif get_vif();
            return vif;
        endfunction
        
    //Setter for the APB virtual interface
        virtual function void set_vif(apb_vif value);
            if(vif == null) begin
                vif = value;
            end
            else begin
                `uvm_fatal(get_type_name(), "Trying to set the APB virtual interface more than once")
            end
        endfunction
    
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