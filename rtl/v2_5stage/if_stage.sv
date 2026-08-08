module if_stage #(
    parameter int IMEM_WORDS = 256
) (
    input  logic        clk,
    input  logic        rst_n,

    input  logic        stall,
    input  logic        redirect_valid,
    input  logic [31:0] redirect_pc,

    output logic [31:0] if_id_pc,
    output logic [31:0] if_id_inst,
    output logic        if_id_valid
);
    // program counter
    logic [31:0] pc_q;
    always_ff @( posedge clk or negedge rst_n ) begin
        if (!rst_n) begin
            pc_q <= '0;
        end else if (redirect_valid) begin
            pc_q <= redirect_pc;
        end else if (stall) begin
            pc_q <= pc_q;
        end else begin
            pc_q <= pc_q + 4;
        end
    end

    // if/id pipeline register
    always_ff @( posedge clk or negedge rst_n ) begin
        if_id_pc <= pc_q;
        if (!rst_n) begin
            if_id_valid <= 0;
        end else if (redirect_valid) begin
            if_id_valid <= 0;
        end else if (stall) begin
            if_id_valid <= 1;
        end else begin
            if_id_valid <= 1;
        end
    end

    assign if_id_inst = imem[pc_q[31:2]];
endmodule