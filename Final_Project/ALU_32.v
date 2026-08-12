

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
