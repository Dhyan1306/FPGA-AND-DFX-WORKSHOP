module axi_lite_calc_slave #(
    parameter C_S_AXI_DATA_WIDTH = 32,
    parameter C_S_AXI_ADDR_WIDTH = 5
)(
    input  wire                          S_AXI_ACLK,
    input  wire                          S_AXI_ARESETN,

    input  wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_AWADDR,
    input  wire                          S_AXI_AWVALID,
    output reg                           S_AXI_AWREADY,

    input  wire [C_S_AXI_DATA_WIDTH-1:0] S_AXI_WDATA,
    input  wire [C_S_AXI_DATA_WIDTH/8-1:0] S_AXI_WSTRB,
    input  wire                          S_AXI_WVALID,
    output reg                           S_AXI_WREADY,

    output reg [1:0]                     S_AXI_BRESP,
    output reg                           S_AXI_BVALID,
    input  wire                          S_AXI_BREADY,

    input  wire [C_S_AXI_ADDR_WIDTH-1:0] S_AXI_ARADDR,
    input  wire                          S_AXI_ARVALID,
    output reg                           S_AXI_ARREADY,

    output reg [C_S_AXI_DATA_WIDTH-1:0]  S_AXI_RDATA,
    output reg [1:0]                     S_AXI_RRESP,
    output reg                           S_AXI_RVALID,
    input  wire                          S_AXI_RREADY,

    output reg  [31:0] operand_a,
    output reg  [31:0] operand_b,
    output reg  [1:0]  opcode,
    output reg          start,
    input  wire [31:0] result,
    input  wire          done
);

    localparam ADDR_OPA    = 5'h00;
    localparam ADDR_OPB    = 5'h04;
    localparam ADDR_OPCODE = 5'h08;
    localparam ADDR_CTRL   = 5'h0C;
    localparam ADDR_STATUS = 5'h10;
    localparam ADDR_RESULT = 5'h14;

    reg [C_S_AXI_ADDR_WIDTH-1:0] awaddr_reg, araddr_reg;
    reg busy_ff, done_ff;

    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            S_AXI_AWREADY <= 0;
            awaddr_reg    <= 0;
        end else begin
            if (!S_AXI_AWREADY && S_AXI_AWVALID && S_AXI_WVALID) begin
                S_AXI_AWREADY <= 1;
                awaddr_reg    <= S_AXI_AWADDR;
            end else
                S_AXI_AWREADY <= 0;
        end
    end

    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            S_AXI_WREADY <= 0;
            operand_a    <= 0;
            operand_b    <= 0;
            opcode       <= 0;
            start        <= 0;
        end else begin
            start <= 0;
            if (!S_AXI_WREADY && S_AXI_WVALID && S_AXI_AWVALID) begin
                S_AXI_WREADY <= 1;
                case (awaddr_reg)
                    ADDR_OPA:    operand_a <= S_AXI_WDATA;
                    ADDR_OPB:    operand_b <= S_AXI_WDATA;
                    ADDR_OPCODE: opcode    <= S_AXI_WDATA[1:0];
                    ADDR_CTRL:   start     <= S_AXI_WDATA[0];
                    default: ;
                endcase
            end else
                S_AXI_WREADY <= 0;
        end
    end

    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            S_AXI_BVALID <= 0;
            S_AXI_BRESP  <= 0;
        end else begin
            if (S_AXI_AWREADY && S_AXI_AWVALID && S_AXI_WREADY && S_AXI_WVALID && !S_AXI_BVALID) begin
                S_AXI_BVALID <= 1;
                S_AXI_BRESP  <= 2'b00;
            end else if (S_AXI_BVALID && S_AXI_BREADY) begin
                S_AXI_BVALID <= 0;
            end
        end
    end

    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            S_AXI_ARREADY <= 0;
            araddr_reg    <= 0;
        end else begin
            if (!S_AXI_ARREADY && S_AXI_ARVALID) begin
                S_AXI_ARREADY <= 1;
                araddr_reg    <= S_AXI_ARADDR;
            end else
                S_AXI_ARREADY <= 0;
        end
    end

    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            busy_ff <= 0;
            done_ff <= 0;
        end else begin
            if (start)  busy_ff <= 1;
            if (done) begin
                done_ff <= 1;
                busy_ff <= 0;
            end
            if (S_AXI_ARREADY && S_AXI_ARVALID && araddr_reg == ADDR_STATUS)
                done_ff <= 0;
        end
    end

    always @(posedge S_AXI_ACLK or negedge S_AXI_ARESETN) begin
        if (!S_AXI_ARESETN) begin
            S_AXI_RVALID <= 0;
            S_AXI_RRESP  <= 0;
            S_AXI_RDATA  <= 0;
        end else begin
            if (S_AXI_ARREADY && S_AXI_ARVALID && !S_AXI_RVALID) begin
                S_AXI_RVALID <= 1;
                S_AXI_RRESP  <= 2'b00;
                case (araddr_reg)
                    ADDR_OPA:    S_AXI_RDATA <= operand_a;
                    ADDR_OPB:    S_AXI_RDATA <= operand_b;
                    ADDR_OPCODE: S_AXI_RDATA <= {30'b0, opcode};
                    ADDR_STATUS: S_AXI_RDATA <= {30'b0, busy_ff, done_ff};
                    ADDR_RESULT: S_AXI_RDATA <= result;
                    default:     S_AXI_RDATA <= 32'hDEADBEEF;
                endcase
            end else if (S_AXI_RVALID && S_AXI_RREADY) begin
                S_AXI_RVALID <= 0;
            end
        end
    end

endmodule