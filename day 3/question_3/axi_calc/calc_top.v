module calc_top (
    input  wire        S_AXI_ACLK,
    input  wire        S_AXI_ARESETN,

    input  wire [4:0]  S_AXI_AWADDR,
    input  wire        S_AXI_AWVALID,
    output wire         S_AXI_AWREADY,

    input  wire [31:0] S_AXI_WDATA,
    input  wire [3:0]  S_AXI_WSTRB,
    input  wire        S_AXI_WVALID,
    output wire         S_AXI_WREADY,

    output wire [1:0]   S_AXI_BRESP,
    output wire          S_AXI_BVALID,
    input  wire          S_AXI_BREADY,

    input  wire [4:0]  S_AXI_ARADDR,
    input  wire        S_AXI_ARVALID,
    output wire         S_AXI_ARREADY,

    output wire [31:0]  S_AXI_RDATA,
    output wire [1:0]   S_AXI_RRESP,
    output wire          S_AXI_RVALID,
    input  wire          S_AXI_RREADY
);

    wire [31:0] operand_a, operand_b, result;
    wire [1:0]  opcode;
    wire        start, done;

    axi_lite_calc_slave axi_inst (
        .S_AXI_ACLK(S_AXI_ACLK),
        .S_AXI_ARESETN(S_AXI_ARESETN),
        .S_AXI_AWADDR(S_AXI_AWADDR),
        .S_AXI_AWVALID(S_AXI_AWVALID),
        .S_AXI_AWREADY(S_AXI_AWREADY),
        .S_AXI_WDATA(S_AXI_WDATA),
        .S_AXI_WSTRB(S_AXI_WSTRB),
        .S_AXI_WVALID(S_AXI_WVALID),
        .S_AXI_WREADY(S_AXI_WREADY),
        .S_AXI_BRESP(S_AXI_BRESP),
        .S_AXI_BVALID(S_AXI_BVALID),
        .S_AXI_BREADY(S_AXI_BREADY),
        .S_AXI_ARADDR(S_AXI_ARADDR),
        .S_AXI_ARVALID(S_AXI_ARVALID),
        .S_AXI_ARREADY(S_AXI_ARREADY),
        .S_AXI_RDATA(S_AXI_RDATA),
        .S_AXI_RRESP(S_AXI_RRESP),
        .S_AXI_RVALID(S_AXI_RVALID),
        .S_AXI_RREADY(S_AXI_RREADY),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .opcode(opcode),
        .start(start),
        .result(result),
        .done(done)
    );

    // Reconfigurable Partition instance.
    // Module name MUST be "rm_core" for all three DFX configs (rm1/rm2/rm3),
    // since Vivado's DFX flow requires the same module/cell name across
    // all Reconfigurable Module implementations swapped into this instance.
    // This build links against the RM1 (Arithmetic) source by default.
    rm_core rp_inst (
        .clk(S_AXI_ACLK),
        .rst(!S_AXI_ARESETN),
        .operand_a(operand_a),
        .operand_b(operand_b),
        .opcode(opcode),
        .start(start),
        .result(result),
        .done(done)
    );

endmodule