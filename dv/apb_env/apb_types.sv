/******************************************************************
 * File:   apb_env.sv
 * Author: Abdelrahman Yassien
 * Email:  Abdelrahman.Yassien11@gmail.com
 * Date:   01/10/2025
 * Description: This file is the apb env, where apb env
 *              components are inestantiated, created and 
 *              connected.
 * 
 * Copyright (c) [2025] Abdelrahman Yassien. All Rights Reserved.
 * This file is part of the verification of AMBA APB Project.
  ******************************************************************/
`ifndef AY_APB_TYPES
`define AY_APB_TYPES

  typedef virtual apb_if apb_vif;

  // CONTROL
  typedef enum  {WRITE = 0, READ = 1}         apb_dir;
  typedef bit   [`AY_APB_MAX_ADDR_WIDTH-1:0]  apb_addr;
  typedef enum  {OK = 0, ERR = 1}             apb_pslverr;
  typedef enum  {READY = 0, NREADY = 1}       apb_pready;
  typedef enum  {DISABLED = 0, ENABLED = 1}   apb_penable;
  //typedef enum  {S1 = 0, S2 = 1, S3 = 2}      apb_psel;
 


  // DATA
  typedef bit   [`AY_APB_MAX_DATA_WIDTH-1:0]  apb_data_wr;
  typedef logic [`AY_APB_MAX_DATA_WIDTH-1:0]  apb_data_rd;


`endif