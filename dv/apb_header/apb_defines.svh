`ifndef AY_APB_DEF

`define AY_APB_DEF

    `ifndef AY_APB_MAX_DATA_WIDTH
        `define AY_APB_MAX_DATA_WIDTH 32
    `endif

    `ifndef AY_APB_MAX_ADDR_WIDTH
        `define AY_APB_MAX_ADDR_WIDTH 16
    `endif

    // `ifndef AY_APB_AGT_CFG_PARAMS
    //     `define AY_APB_AGT_CFG_PARAMS
    // `endif

    // `ifdef AY_APB_AGT_CFG_PARAMS
    //     `define APB_AGT_ACTIVE_NOT_ACTIVE 1
    //     `define APB_AGT_TXN_THRESHOLD 1
    //     `define APB_AGT_CHECKS 1
    // `endif

`endif