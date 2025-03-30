// Parameterized register of the required size for pipeline register

module pipeline_register_stall #(parameter NUM_BITS = 16) (
    input wire clk,
    input wire stall,
    input wire [NUM_BITS - 1:0] din,
    output wire [NUM_BITS - 1:0] dout
);

    reg [NUM_BITS - 1:0] reg_data;

    always @(posedge clk) begin
        if (!stall) begin
            reg_data <= din;
        end else begin
            reg_data <= reg_data;
        end
    end

    assign dout = reg_data;

    initial begin
        reg_data = 0;
    end

endmodule