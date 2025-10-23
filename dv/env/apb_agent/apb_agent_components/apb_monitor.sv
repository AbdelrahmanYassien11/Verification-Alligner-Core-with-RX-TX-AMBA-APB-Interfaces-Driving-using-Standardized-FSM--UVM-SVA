/******************************************************************
 * File:   apb_monitor.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb monitor, where the apb
 *              monitor's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_MON
`define AY_APB_MON

    class apb_monitor extends uvm_monitor;
    `uvm_component_utils(apb_monitor)

    local apb_vif vif;
    uvm_analysis_port#(apb_sequence_item_mon) mon2agt;

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

            //creating TLM PORTS
            mon2agt = new("mon2agt", this);
        endfunction : build_phase

    //---------------------------------------------------------
    // Connect Phase to connect the moniornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
        endfunction : connect_phase


    //---------------------------------------
    // Run phase
    //---------------------------------------
        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
                `uvm_fatal(get_type_name(), $sformatf("Could not get from the database the APB virtual interface using name"))
            end
            collect_transactions();
        endtask : run_phase    


        task collect_transactions();
            forever begin
                collect_transaction();
            end
        endtask : collect_transactions


        task collect_transaction();
            apb_sequence_item_mon item = apb_sequence_item_mon::type_id::create("item");
            while(vif.monitor_cb.psel !== 1'b1) begin
                @(vif.monitor_cb);
                item.cycles_b4_item++;
            end
            `uvm_info(get_type_name(), "SETUP PHASE", UVM_HIGH)
            item.addr = vif.monitor_cb.paddr;
            item.dir  = apb_dir'(vif.monitor_cb.pwrite);
            if(apb_dir'(vif.monitor_cb.pwrite) == WRITE) begin
                item.data = vif.monitor_cb.pwdata; 
            end
            item.transaction_length++;

            //because each transfer takes at least 1 clk cycle
            @(vif.monitor_cb);
            item.transaction_length++;
            `uvm_info(get_type_name(), "ACCESS PHASE", UVM_HIGH)

            while(apb_pready'(vif.monitor_cb.pready) != READY) begin
                @(vif.monitor_cb);
                item.transaction_length++;
            end

            if(item.transaction_length > vif.hang_threshold) begin $display("%0d, %0d", vif.hang_threshold, item.transaction_length); `uvm_fatal(get_type_name(), "TB is hanging")
            end
            item.pslverr = apb_pslverr'(vif.monitor_cb.pslverr);
            item.pready = apb_pready'(vif.monitor_cb.pready);
            if(apb_dir'(vif.monitor_cb.pwrite) == READ) begin
                item.data = vif.monitor_cb.prdata;
            end
            `uvm_info(get_type_name(), "RESPONSE PHASE", UVM_HIGH)

            mon2agt.write(item);
            `uvm_info(get_type_name(), $sformatf("%0s", item.convert2string), UVM_LOW)

            @(vif.monitor_cb);
            
        endtask : collect_transaction   
    endclass : apb_monitor

`endif