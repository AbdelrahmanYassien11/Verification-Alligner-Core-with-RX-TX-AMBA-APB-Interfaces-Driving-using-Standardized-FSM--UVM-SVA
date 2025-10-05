/******************************************************************
 * File:   apb_driver.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb driver, where the apb
 *              driver's logic is implemented as well as needed 
 *              TLM connections.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_DRV
`define AY_APB_DRV

    class apb_driver extends uvm_driver#(apb_sequence_item_drv, apb_sequence_item_mon);
    `uvm_component_utils(apb_driver)

    local apb_vif vif;
    //------------------------------------------
    // Constructor for the driverironment component
    //------------------------------------------
        function new(string name = "", uvm_component parent);
            super.new(name, parent);
        endfunction : new

    //-------------------------------------------------------------
    // Build phase for component creation, initialization & Setters
    //-------------------------------------------------------------
        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
        endfunction : build_phase

    //---------------------------------------------------------
    // Connect Phase to connect the driveriornment TLM Components
    //---------------------------------------------------------
        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            //Getting Virtual Interface Instance

        endfunction : connect_phase

    //---------------------------------------
    // Run phase
    //---------------------------------------
        task run_phase(uvm_phase phase);
            apb_sequence_item_drv req;
            apb_sequence_item_mon rsp;
            super.run_phase(phase);
            if(!uvm_config_db#(virtual apb_if)::get(this, "", "vif", vif)) begin
                `uvm_fatal(get_type_name(), $sformatf("Could not get from the database the APB virtual interface using name"))
            end
            forever begin
                rsp = apb_sequence_item_mon::type_id::create("rsp");
                seq_item_port.get_next_item(req);            

                `uvm_info(get_type_name(), req.convert2string(), UVM_LOW)
                @(negedge vif.clk);
                vif.pwrite <= int'(req.dir);
                vif.paddr  <= req.addr;
                if(!req.dir) begin
                    //vif.pwrite <= int'(req.dir);
                    vif.pwdata <= req.data_wr;
                end
                else begin
                    //wait(vif.pready);
                    rsp.data_rd = vif.prdata;
                    rsp.pslverr = apb_pslverr'(vif.pslverr);
                    `uvm_info(get_type_name(), rsp.convert2string(), UVM_LOW)
                end
                seq_item_port.item_done();
            end
        endtask : run_phase


    endclass : apb_driver

`endif