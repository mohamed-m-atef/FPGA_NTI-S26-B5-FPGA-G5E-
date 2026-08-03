module and_gate (a,b ,c);
input a ,b;
output c;
assign c = a & b;
endmodule 
module or_gate (a ,b ,c);
input a ,b;
output c;
assign c= a|b;
endmodule
module not_gate (a,c);
input a;
output c;
assign c =~a;
endmodule
module xor_gate (a ,b ,c);
input a ,b;
output c;
assign c= a^b;
endmodule

module decoder (
input f0,
input f1,
output wire w1,
output wire w2,
output wire w3,
output wire w4
);
assign w1 = ~f0 & ~f1;
assign w2 = ~f0 & f1;
assign w3 = f0 & ~f1;
assign w4 = f0 & f1;
endmodule


module logic_unit(
input A,
input B,
input w1,
input w2,
input w3,
output wire w5,
output wire w6,
output wire w7
);
wire out_A1 , out_O1 , out_N1;
and_gate A1 (.a(A),.b(B),.c(out_A1));
or_gate O1 (.a(A),.b(B),.c(out_O1));
not_gate N1 (.a(B),.c(out_N1));
and_gate A2 (.a(out_A1),.b(w1),.c(w5));
and_gate A3 (.a(out_O1),.b(w2),.c(w6));
and_gate A4 (.a(out_N1),.b(w3),.c(w7));
endmodule

module full_adder (
input A,
input B,
input Cin,
input wire w4,
output Cout,
output S
);
wire w8,w9,w10;
xor_gate X1 (.a(A),.b(B),.c(w8));
xor_gate X2 (.a(w8),.b(Cin),.c(S));
assign w9 = A & B & w4;
assign w10 = w8 & Cin & w4;
or_gate O2 (.a(w9),.b(w10),.c(Cout));
endmodule

module Top_module_ALU_1_bit (
input A,
input B,
input f0,
input f1,
input Cin,
output Cout,
output result
);
wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12;
decoder D (.f0(f0),.f1(f1),.w1(w1),.w2(w2),.w3(w3),.w4(w4));
logic_unit L (.A(A),.B(B),.w5(w5),.w6(w6),.w7(w7),.w1(w1),.w2(w2),.w3(w3));
full_adder F (.A(A),.B(B),.Cin(Cin) ,.Cout(Cout),.S(w12),.w4(w4));
and_gate A11 (.a(w12),.b(w4),.c(w11));
assign result = w5 | w6 | w7 | w11;
endmodule


