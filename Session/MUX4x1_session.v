module MUX4X1(
input wire A,
input wire B,
input wire C,
input wire D,
input wire [1:0]S,

output F
);
//Data Flow
assign F= (S==2'b00)? A:
	(S==2'b00)? B:
	(S==2'b00)? C:
	(S==2'b00)? D;

always@(*)
begin
case(S)
2'b00: F = A;
2'b01: F = B;
2'b10: F = C;
2'b11: F = D;
default F=A;
endcase

end

always@(*)
begin
if (S==2B'00)
begin
	F = A;
end
else if (S==2B'01)
	F = B;
else if (S==2B'10)
	F = C;
else
	F=D;
end


wire M1_out;
wire M2_out;

MUX2X1 M1(.A(A), .B(B), .S(S[0]), .F(M1_out));
MUX2X1 M1(.A(C), .B(D), .S(S[0]), .F(M2_out));
MUX2X1 M1(.A(M1_out), .B(M2_out), .S(S[1]), .F(F));




endmodule
