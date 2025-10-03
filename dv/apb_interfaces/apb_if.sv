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
// `ifndef AY_APB_IF
// `define AY_APB_IF
    `ifndef AY_APB_MAX_DATA_WIDTH
        `define AY_APB_MAX_DATA_WIDTH 32
    `endif

    `ifndef AY_APB_MAX_ADDR_WIDTH
        `define AY_APB_MAX_ADDR_WIDTH 32
    `endif

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

    endinterface : apb_if
// `endif