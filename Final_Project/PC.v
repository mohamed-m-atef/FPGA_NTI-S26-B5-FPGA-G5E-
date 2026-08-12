module PC (
    input wire clk,
    input wire reset,
    input wire [31:0] pc_in,
    output reg [31:0] pc_out
);

    // Synchronous/Asynchronous update for PC with reset support
    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_out <= 32'h0000_0000;
        else
            pc_out <= pc_in;
    end

endmodule