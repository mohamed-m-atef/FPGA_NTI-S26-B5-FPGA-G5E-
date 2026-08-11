`timescale 1ns / 1ps

module TOP_MODULE_tb ;

reg [1:0] ALUOp;
reg [5:0] funct;
reg [31:0] ReadData1;
reg [31:0] ReadData2;

wire [31:0] ALUResult;
wire Zero;

TOP_MODULE DUT (
.ALUOp(ALUOp),
.funct(funct),
.ReadData1(ReadData1),
.ReadData2(ReadData2),
.ALUResult(ALUResult),
.Zero(Zero)
);

initial
begin

// lw / sw  (add) expect 12
ALUOp = 2'b00;
funct = 6'b000000;
ReadData1 = 32'd10;
ReadData2 = 32'd2;
#10;

// beq (sub)  exepect 13
ALUOp = 2'b01;
funct = 6'b000000;
ReadData1 = 32'd15;
ReadData2 = 32'd2;
#10;

// beq  (sub) exepect 0
ALUOp = 2'b01;
funct = 6'b000000;
ReadData1 = 32'd10;
ReadData2 = 32'd10;
#10;

// R-Type (add) {12}
ALUOp = 2'b10;
funct = 6'b100000;
ReadData1 = 32'd10;
ReadData2 = 32'd2;
#10;

// R-Type (sub) {8}
ALUOp = 2'b10;
funct = 6'b100010;
ReadData1 = 32'd10;
ReadData2 = 32'd2;
#10;

// R-Type (AND) 
ALUOp = 2'b10;
funct = 6'b100100;
ReadData1 = 32'd10;
ReadData2 = 32'd2;
#10;

// R-Type (OR) 
ALUOp = 2'b10;
funct = 6'b100101;
ReadData1 = 32'd10;
ReadData2 = 32'd2;
#10;

// R-Type (SLT) {true}
ALUOp = 2'b10;
funct = 6'b101010;
ReadData1 = 32'd2;
ReadData2 = 32'd10;
#10;

// R-Type (SLT) {false}
ALUOp = 2'b10;
funct = 6'b101010;
ReadData1 = 32'd10;
ReadData2 = 32'd2;
#10;


$stop;

end

endmodule

