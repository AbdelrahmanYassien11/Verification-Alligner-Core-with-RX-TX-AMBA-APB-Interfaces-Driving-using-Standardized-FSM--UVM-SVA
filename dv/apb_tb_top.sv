/******************************************************************
 * File:   apb_tb_top.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb interfac, where apb
 *              signals are defined as well as their width
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/

// Drawing a rose, a natural movement to your hand
// You said I could speak hyrogliphs and you'd understand
// but what if my mouth is shut, no words come around
// a dead language that doesn't have a sound...

//that night when we sang stranger's in the night
// a feeling of serenity, glassenheit

`include "uvm_macros.svh"

    module apb_tb_top();
    
    import uvm_pkg::*;
    import apb_test_pkg::*;

    bit clk;

    always #5ns clk = ~clk;

    apb_if apb_inf(.clk(clk));

    // Instantiate the DUT
    cfs_aligner dut(
        .clk        (clk),
        .reset_n    (apb_inf.preset_n),
        
        .paddr      (apb_inf.paddr),
        .pwrite     (apb_inf.pwrite),
        .psel       (apb_inf.psel),
        .penable    (apb_inf.penable),
        .pwdata     (apb_inf.pwdata),
        .pready     (apb_inf.pready),
        .prdata     (apb_inf.prdata),
        .pslverr    (apb_inf.pslverr)
    );

    initial begin
        apb_inf.preset_n = 0;
        #20ns;
        apb_inf.preset_n = 1;
    end
    
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        uvm_config_db#(virtual apb_if)::set(null, "uvm_test_top.env.agt", "vif", apb_inf);

        run_test();
    end 

    endmodule : apb_tb_top
