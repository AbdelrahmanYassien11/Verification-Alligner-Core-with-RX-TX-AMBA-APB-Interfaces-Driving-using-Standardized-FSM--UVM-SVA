/******************************************************************
 * File:   apb_agt.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb agt, where the apb
 *              agt's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_AGENT
`define AY_APB_AGENT

    class apb_agent extends uvm_agent;
    `uvm_component_utils(apb_agent)

    apb_driver      drv;
    apb_monitor     mon;
    apb_sequencer   seqr;

    apb_agent_config apb_agt_cfg;

    uvm_analysis_port#(apb_sequence_item) agt2env;


    //------------------------------------------
    // Constructor for the agtironment component
    //------------------------------------------
        function new(string name = "apb_agent", uvm_component parent);
            super.new(name, parent);
        endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            //Creating Agent Components
            drv         = apb_driver::type_id::create("drv", this);
            mon         = apb_monitor::type_id::create("mon", this);
            seqr        = apb_sequencer::type_id::create("seqr", this);
            //Creating Agent Config File Instance
            apb_agt_cfg = apb_agent_config::type_id::create("apb_agt_cfg", this);
            //Creating Agent's TLM Connections
            agt2env     = new("agt2env", this);
        endfunction : build_phase

    //---------------------------------------------------------
    // Connect Phase to connect the agtiornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase);
            apb_vif vif;
            
            super.connect_phase(phase);

            //Connecting Sequencer to Driver
            drv.seq_item_port.connect(seqr.seq_item_export);
            
            //Getting Virtual Interface Instance
            if(!uvm_config_db#(virtual cfs_apb_if)::get(this, "", "vif", vif)) begin
                `uvm_fatal("APB_NO_VIF", $sformatf("Could not get from the database the APB virtual interface using name"))
            end
            else begin
                apb_agt_cfg.set_vif(vif);
            end

            //connecting the monitor's analysis port to the agent's
            mon.mon2agt.connect(agt2env);
        endfunction : connect_phase

    endclass : apb_agent

`endif