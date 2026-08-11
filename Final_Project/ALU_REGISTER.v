module ALU_REG (
input wire clk,
input wire reset,
input wire [4:0] Read_Reg1,
input wire [4:0] Read_Reg2,
input wire [4:0] Write_Reg,
input wire [31:0] Write_Data,
input wire RegWrite,
input wire ALUSrc,
input wire [2:0] ALUControl,
input wire [15:0] immediate,
output wire[31:0]Result,
output wire Zero
);

wire [31:0] Read_Data1;
wire [31:0] Read_Data2;
wire [31:0] out_mux;
wire [31:0] extended;

Register_File REG_FILE (
.clk(clk),
.reset(reset),
.Read_Reg1(Read_Reg1),
.Read_Reg2(Read_Reg2),
.Write_Reg(Write_Reg),
.Write_Data(Write_Data),
.RegWrite(RegWrite),
.Read_Data1(Read_Data1),
.Read_Data2(Read_Data2)
);

Sign_Extend Extend (
.immediate(immediate),
.extended(extended)
);

mux_2x1 mux (
.A(Read_Data2),
.B(extended),
.S(ALUSrc),
.out(out_mux)
);

ALU_32 ALU (
.A(Read_Data1),
.B(out_mux),
.ALUControl(ALUControl)
,.out(Result),
.Zero(Zero)
);



endmodule
