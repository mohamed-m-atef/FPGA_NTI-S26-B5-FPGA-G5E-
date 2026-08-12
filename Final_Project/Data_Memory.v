module Data_Memory (
    input wire clk,
    input wire mem_read,
    input wire mem_write,
    input wire [31:0] address,
    input wire [31:0] write_data,
    output wire [31:0] read_data
);

    // 256-word RAM memory array (32-bit width)
    reg [31:0] memory [0:255];
         integer i;

     initial begin

    for (i = 0; i < 256; i = i + 1)
        memory[i] = 32'h0000_0000;

    
    memory[0] = 32'd10;

    end 



    // Synchronous write operation on rising edge of clock
    always @(posedge clk) begin
        if (mem_write) begin
            memory[address[31:2]] <= write_data;
        end
    end

    // Combinational read operation
    assign read_data = (mem_read) ? memory[address[31:2]] : 32'h0000_0000;

endmodule
