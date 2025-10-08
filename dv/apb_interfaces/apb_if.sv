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