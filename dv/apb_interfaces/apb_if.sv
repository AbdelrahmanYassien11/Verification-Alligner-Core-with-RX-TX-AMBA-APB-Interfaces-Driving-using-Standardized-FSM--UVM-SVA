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

    `include "apb_defines.svh"
    `include "apb_types.sv"
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


    // ============================================
    // ENUMS TO VIEW VALUES IN WAVEFORM
    // ============================================
        apb_dir         pwrite_view;
        apb_penable     penable_view;
        apb_pready      pready_view;
        apb_pslverr     pslverr_view;

        assign  pwrite_view     = apb_dir'(pwrite);
        assign  penable_view    = apb_penable'(penable);
        assign  pready_view     = apb_pready'(pready);
        assign  pslverr_view    = apb_pslverr'(pslverr);

        //  if its set to 1, the assertions work, otherwise they're turned off.
        bit has_checks;
        int hang_threshold;
        initial begin
            has_checks = 1;
        end

    // ====================================================================
    // SVA for APB Interface Protocol Checks - Assertions & Sequences
    // ====================================================================
        sequence setup_phase_s;
            $rose(psel) || (psel == 1 & $fell(pready));
        endsequence : setup_phase_s

        sequence access_phase_s;
            (psel == 1) && $rose(penable);
        endsequence : access_phase_s

        sequence transaction_end_s;
            $fell(pready) || ($stable(pready) && ($changed(paddr) || $changed(psel) || $changed(pwdata) || $changed(pwrite))); 
        endsequence : transaction_end_s

        // SVA for APB Interface Protocol Checks
        /*----------------------------------------------Penable Assertions-------------------------------------------------*/
        property penable_assert;
            disable iff (!preset_n || !has_checks)
            @(posedge clk) 
            setup_phase_s |=> $rose(penable);
        endproperty : penable_assert

        penable_assert_assert: assert property(penable_assert)
        //$info("Penable Assertion SVA Hit");
        else $error("Penable Assertion SVA Miss/Fail");

        penable_assert_cov: cover property(penable_assert);

        property penable_deassert;
            disable iff (!preset_n || !has_checks)
            @(posedge clk)
            setup_phase_s |=> $rose(penable) ##[0:$] $rose(pready) ##1 $fell(penable);
        endproperty : penable_deassert

        penable_deassert_assert: assert property(penable_deassert)
        //$info("Penable Deassertion SVA Hit");
        else $error("Penable Deassertion SVA Miss/Fail");

        penable_deassert_cov: cover property(penable_deassert);

        property penable_stable;
            disable iff (!preset_n || !has_checks)
            @(posedge clk)
            setup_phase_s |=> $rose(penable) ##1 $stable(penable) ##[0:$] $rose(pready);
        endproperty : penable_stable

        penable_stable_assert: assert property(penable_stable)
        //$info("Penable Stable SVA Hit");
        else $error("Penable Stable SVA Miss/Fail");

        penable_stable_cov: cover property(penable_stable);

        /*----------------------------------------------Paddr Assertions-------------------------------------------------*/
        property paddr_valid_write_ranges;
            disable iff (!preset_n || !has_checks)
            @(posedge clk)
            setup_phase_s ##0 (pwrite == 1) |-> (paddr == 'h0000 || paddr == 'h00F0 || paddr == 'h00F4);
        endproperty : paddr_valid_write_ranges

        paddr_valid_write_ranges_assert: assert property(paddr_valid_write_ranges)
        //$info("Penable Assertion SVA Hi");
        else $error("Paddr Assertion SVA Miss/Fail");

        paddr_valid_write_ranges_cov: cover property(paddr_valid_write_ranges);

        //More can be added...very specific, for assertion for certain thresholds of data not to be used when certian addresses are being used...
        /*-------------------------------------------------Protocol Assertions----------------------------------------------*/
        
        property stable_inputs;
            disable iff (!preset_n || !has_checks)
            @(posedge clk)
            $rose(psel) |=> 
            ($stable(psel) && $stable(paddr) && $stable(pwrite) && ((pwrite == 1 && $stable(pwdata)) || (pwrite == 0))) ##[1:$] transaction_end_s;
        endproperty : stable_inputs

        stable_inputs_assert: assert property(stable_inputs)
        // $info("Stable Inputs SVA Hit");
        else $error("Stable Inputs SVA Miss/Fail");

        stable_inputs_cov: cover property (stable_inputs);

        property x_propagation;
            disable iff (!preset_n || !has_checks)
            @(posedge clk)
            ($isunknown(psel) || $isunknown(penable) || $isunknown(paddr) || $isunknown(pwrite) || $isunknown(pwdata) || 
            $isunknown(pready) || $isunknown(pslverr) || $isunknown(prdata)) == 0;
        endproperty : x_propagation

        x_propagation_assert: assert property(x_propagation)
        //$info("x_propagation SVA Miss/Fail = X Propagation did not happen");
        else $error("x_propagation SVA Hit = X Propagation Happened");

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