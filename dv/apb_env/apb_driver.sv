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


    local bit  [1:0] state, next_state;
    localparam IDLE = 2'b0, SETUP = 2'b01, ACCESS = 2'b10;
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
            state = IDLE;
            vif.psel    <= 0;
            vif.penable <= 0;
            vif.pwrite  <= 0;
            vif.paddr   <= 0;
            vif.pwdata  <= 0;
            forever begin
                rsp = apb_sequence_item_mon::type_id::create("rsp");
                seq_item_port.get_next_item(req);
                state_ctrl(req);
                `uvm_info(get_type_name(), req.convert2string(), UVM_LOW)
                // @(vif.driver_cb);
            end
        endtask : run_phase


        task drive_multiple_transaction;


        endtask : drive_multiple_transaction

        task drive_transaction;
            for(int i = 0; i < item.pre_drive_delay; i++) begin
                @(posedge vif.cclk);
            end
            case (state)
                IDLE:   `uvm_warning(get_type_name(), "Shouldn't happen");
                SETUP:  begin
                    vif.driver_cb.pwrite    <= int'(req.dir);
                    vif.driver_cb.paddr     <= req.addr;
                    vif.driver_cb.psel      <= 1;
                    vif.driver_cb.penable   <= 0;
                    if(req.dir == WRITE) begin
                        vif.pwdata <= req.data_wr;
                    end                       
                end
                ACCESS: begin
                    vif.driver_cb.penable <= 1'b1;
                end
            endcase

            foreach (!vif.monitor_cb.pready) begin @(posedge clk); end
            rsp.data_rd = vif.monitor_cb.prdata;
            rsp.pslverr = apb_pslverr'(vif.monitor_cb.pslverr);
            `uvm_info(get_type_name(), rsp.convert2string(), UVM_LOW)

            vif.psel    <= 0;
            vif.penable <= 0;
            vif.pwrite  <= 0;
            vif.paddr   <= 0;
            vif.pwdata  <= 0;

            for(int i = 0; i < item.post_drive_delay; i++) begin
                @(posedge vif.clk);
            end
        endtask : drive_transaction


        task state_ctrl(input apb_sequence_item_drv req);
            case (state)
                IDLE: begin 
                    state = SETUP;
                end
                SETUP: begin
                    state = ACCESS;
                end
                ACCESS: begin
                    if(vif.monitor_cb.pready == NREADY) begin 
                        state = ACCESS;
                    end
                    else if (vif.monitor_cb.pready == READY && req.penable) begin
                        state = SETUP;
                    end
                    else if (vif.monitor_cb.pready == READY && ~req.penable) begin
                        state = IDLE;
                    end
                    else begin
                        `uvm_fatal(get_type_name(), "undefined state")
                    end
                end
                default: `uvm_fatal(get_type_name(), "undefined state")  
            endcase
        endtask : state_ctrl

    endclass : apb_driver

`endif