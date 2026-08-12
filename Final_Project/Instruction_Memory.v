module Instruction_Memory (
    input wire [31:0] pc_addr,
    output wire [31:0] instruction
);

    // 64-word ROM memory array (32-bit width)
    reg [31:0] mem [0:63]; 
    integer i;

    // Read instruction using word alignment (PC shifted right by 2)
    assign instruction = mem[pc_addr[31:2]];

    // Initial memory setup with loop to clear all memory locations (Prevents 'X' values)
    initial begin
        // Clear all memory locations to 0
        for (i = 0; i < 64; i = i + 1) begin
            mem[i] = 32'h0000_0000;
        end

    // Sample instruction code loaded into memory
    // 0: lw $t0, 0($zero)
    mem[0] = 32'h8C080000;

    // 1: sw $t0, 4($zero)
    mem[1] = 32'hAC080004;

    // 2: add $t2, $t0, $t1
    mem[2] = 32'h01095020;

    // 3: sub $t3, $t1, $t0
    mem[3] = 32'h01285822;

    // 4: and $t4, $t0, $t1
    mem[4] = 32'h01096024;

    // 5: or $t5, $t0, $t1
    mem[5] = 32'h01096825;

    // 6: slt $t6, $t0, $t1
    mem[6] = 32'h0109702A;
    
   // beq $t0, $t0, +2
    mem[7]  = 32'h11080002;
    
    //skip
    mem[8]  = 32'h01087820;
    mem[9]  = 32'h01098020;
    
    //j 12
    mem[10] = 32'h0800000C;
    
    //skip
    mem[11] = 32'h01088820;
    
    //target
    mem[12] = 32'h01099020;
    end

endmodule