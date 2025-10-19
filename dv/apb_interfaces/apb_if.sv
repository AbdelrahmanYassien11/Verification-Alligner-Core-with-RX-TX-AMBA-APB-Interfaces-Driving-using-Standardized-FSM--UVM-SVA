/******************************************************************
 * File:   apb_if.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb interface, where apb
 *              signals are defined as well as their width
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_IF
`define AY_APB_IF

    `include "uvm_macros.svh"
    `include "apb_defines.svh"
    `include "apb_types.sv"
    import uvm_pkg::*;
    interface apb_if(input clk);

        logic preset_n;

        logic[`AY_APB_MAX_ADDR_WIDTH-1:0] paddr;

        logic pwrite;

        logic psel;

        logic penable;

        logic[`AY_APB_MAX_DATA_WIDTH-1:0] pwdata;

        logic pready;

        logic[`AY_APB_MAX_DATA_WIDTH-1:0] prdata;

        logic pslverr;


        // ENUMS To VIEW VALUES
        apb_dir         pwrite_view;
        apb_penable     penable_view;
        apb_pready      pready_view;
        apb_pslverr     pslverr_view;

        assign  pwrite_view     = apb_dir'(pwrite);
        assign  penable_view    = apb_penable'(penable);
        assign  pready_view     = apb_pready'(pready);
        assign  pslverr_view    = apb_pslverr'(pslverr);

        // SVA for APB Interface Protocol Checks
        property en_assert;
            disable iff (~preset_n)
            @(posedge clk) 
            $rose(psel) |=> $rose(penable);
        endproperty : en_assert

        penable_assert_assert: assert property(en_assert)
        $display("y");
        else $display("x");

        penable_assert_cover: cover property(en_assert);

        property en_deassert1;
            disable iff (~preset_n)
            @(posedge clk)
            $rose(psel) |=> $rose(penable) ##[0:$] $rose(pready) ##1 $fell(penable);
        endproperty : en_deassert1

        penable_deassert1_assert: assert property(en_deassert1)
        `uvm_info(get_type_name(), "Penable Deassertion SVA Hit", UVM_HIGH);
        else `uvm_info(get_type_name(), "Penable Deassertion SVA Miss/Fail", UVM_HIGH);

        penable_deassert1_cov: cover property(en_deassert1);

        property stable_input2;
            disable iff (~preset_n)
            @(posedge clk)
            $rose(psel) |=> 
            ($stable(psel) && $stable(paddr) && $stable(pwrite) && $stable(pwdata)) ##[1:$] ($fell(pready));
        endproperty : stable_input2

        valid_inputs2_assert: assert property(stable_input2)
        `uvm_info(get_type_name(), "Stable Inputs SVA Hit", UVM_HIGH);
        else `uvm_info(get_type_name(), "Stable Inputs SVA Miss/Fail", UVM_HIGH);

        valid_inputs2_cov: cover property (stable_input2);

        property x_propagation;
            disable iff (~preset_n)
            $isunknown(psel && paddr && pwrite && pwdata && pready && pslverr && prdata && penable);
        endproperty : x_propagation

        x_propagation_assert: assert property(x_propagation)
        `uvm_info(get_type_name(), "x_propagation SVA Hit = X Propagation Happened", UVM_HIGH);
        else `uvm_info(get_type_name(), "x_propagation SVA Miss/Fail = X Propagation did not happen", UVM_HIGH);

        x_propagation_cov: cover property (x_propagation);

        // ============================================
        // CLOCKING BLOCKS
        // ============================================
        
        // Driver Clocking Block (Master side)
        // Used by driver to drive inputs to DUT
        clocking driver_cb @(posedge clk);
            default input #1step output #1ns;  // Setup/hold timing
            
            output paddr;
            output pwrite;
            output psel;
            output penable;
            output pwdata;
            input  pready;
            input  prdata;
            input  pslverr;

        endclocking
        
        // Monitor Clocking Block (Observer)
        // Used by monitor to sample all signals
        clocking monitor_cb @(posedge clk);
            default input #1step;  // Sample just before clock edge
            
            input paddr;
            input pwrite;
            input psel;
            input penable;
            input pwdata;
            input pready;
            input prdata;
            input pslverr;

        endclocking
        
        // Slave Clocking Block (if needed for slave BFM)
        // Used by slave responder to drive outputs
        // clocking slave_cb @(posedge clk);
        //     default input #1step output #1ns;
            
        //     input  paddr;
        //     input  pwrite;
        //     input  psel;
        //     input  penable;
        //     input  pwdata;
        //     output pready;
        //     output prdata;
        //     output pslverr;

        // endclocking

        // ============================================
        // MODPORTS
        // ============================================
        
        // Driver modport - connects to UVM driver
        modport driver_mp (
            clocking driver_cb,
            input clk,
            input preset_n
        );
        
        // Monitor modport - connects to UVM monitor
        modport monitor_mp (
            clocking monitor_cb,
            input clk,
            input preset_n
        );
        
        // Slave modport - if needed
        // modport slave_mp (
        //     clocking slave_cb,
        //     input clk,
        //     input preset_n
        // );
        
        // Passive modport - Assertions
        modport passive_mp (
            input paddr,
            input pwrite,
            input psel,
            input penable,
            input pwdata,
            input pready,
            input prdata,
            input pslverr,
            input clk,
            input preset_n
        );


    endinterface : apb_if
    
`endif


        // property en_deassert2;
        //     disable iff (~preset_n)
        //     @(posedge clk)
        //     $rose(penable) ##[1:$] $fell(psel) |-> $fell(penable);
        // endproperty : en_deassert2
        // penable_deassert2_assert: assert property(en_deassert2);
        // penable_deassert2_cov: cover property(en_deassert2);

        // property stable_input1;
        //     disable iff (~preset_n)
        //     @(posedge clk)
        //     $rose(psel) |=> 
        //     (($stable(psel) && $stable(paddr) && $stable(pwrite) && $stable(pwdata)) throughout (/*(pready == 0) ##[0:$] $rose(pready)*/ /*##1 */$fell(pready)));
        // endproperty : stable_input1
        // valid_inputs1_assert: assert property(stable_input1)
        // $display("%0t Valiiiiiiiiid", $time());
        // else $display("%0t Invaliiiiiiiiiiiiiiiiiiiid", $time());
        // valid_inputs1_cov: cover property (stable_input1);