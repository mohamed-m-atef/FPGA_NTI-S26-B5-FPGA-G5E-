
module Register_File(
    input wire clk,
    input wire reset,
    input wire [4:0] Read_Reg1,
    input wire [4:0] Read_Reg2,
    input wire [4:0] Write_Reg,
    input wire [31:0] Write_Data,
    input wire RegWrite,
    output wire [31:0] Read_Data1,
    output wire [31:0] Read_Data2
);

reg [31:0] registers [0:31];

integer i;

always @(posedge clk or posedge reset)
begin
    if (reset)
    begin
        for (i = 0; i < 32; i = i + 1)
            registers[i] <= 32'b0;
    end
    else
    begin
        if (RegWrite && Write_Reg != 0)
            registers[Write_Reg] <= Write_Data;
    end
end

assign Read_Data1 = registers[Read_Reg1];
assign Read_Data2 = registers[Read_Reg2];

endmodule