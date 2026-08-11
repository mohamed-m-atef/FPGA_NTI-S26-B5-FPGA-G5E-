module ALU_Control (
    input  [1:0] ALUOp,
    input  [5:0] funct,
    output reg [2:0] ALUControl
);

always @ (*)
begin
case (ALUOp)

//lw / sw
2'b00: ALUControl = 3'b010; //add

//beq 
2'b01 : ALUControl = 3'b110; //sub
//R-type
2'b10:
begin
case (funct)
	6'b100000:ALUControl =3'b010;  //ADD
        6'b100010:ALUControl =3'b110;  //SUB
        6'b100100:ALUControl =3'b000;  //AND
        6'b100101:ALUControl =3'b001;  //OR
        6'b101010:ALUControl =3'b111;   //slt
	default:   ALUControl = 3'b000;
endcase
end

default : ALUControl = 3'b000;

endcase
end
endmodule







module ALU_32 (
input [31:0] A,
input [31:0] B,
input  [2:0] ALUControl,
output reg [31:0]out,
output Zero
);

always @(*)
begin
case (ALUControl)
	3'b000 : out = A&B;	//AND
	3'b001 : out = A|B;	//OR
	3'b010 : out = A+B;	//ADD
	3'b110 : out = A-B;	//SUB
	3'b111: out = ($signed(A) < $signed(B)) ? 32'b1 : 32'b0; // SLT
	default: out = 32'b0;		//Default
	
endcase

end

assign Zero = (out == 32'b0);

endmodule


module TOP_MODULE (
input [1:0] ALUOp,
input [5:0] funct,
input [31:0] ReadData1,
input [31:0] ReadData2,
output [31:0] ALUResult,
output Zero
);
wire [2:0] ALUControl;


ALU_Control ALU_C (.ALUOp(ALUOp),.funct(funct),.ALUControl(ALUControl));
ALU_32 ALU (.A(ReadData1),.B(ReadData2),.ALUControl(ALUControl),.out(ALUResult),.Zero(Zero));

endmodule


