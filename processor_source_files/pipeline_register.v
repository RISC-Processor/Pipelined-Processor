// Parameterized register of the required size for pipeline register

module pipeline_register #(parameter NUM_BYTES = 16) (
    input wire clk,
    localparam BYTE_SIZE = 8,
    input wire [NUM_BYTES * BYTE_SIZE - 1:0] din,
    output reg [NUM_BYTES * BYTE_SIZE - 1:0] dout
)

    reg [NUM_BYTES * BYTE_SIZE - 1:0] reg_data;

    always @(posedge clk) begin
        reg_data <= din;
    end

    assign dout = reg_data;

endmodule