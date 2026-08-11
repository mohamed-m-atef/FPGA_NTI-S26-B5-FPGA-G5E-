module XOR (A,B,C);
input A,B;
output C;
assign C=A^B;
endmodule

module AND (A,B,C);
input A,B;
output C;
assign C=A&B;
endmodule


module OR (A,B,C);
input A,B;
output C;
assign C=A|B;
endmodule

module FA_str (A,B,Cin,S,Cout);
input A,B,Cin;
output S,Cout;
wire w1,w2,w3;
XOR X1 (A,B,w1);
XOR X2 (w1,Cin,S);
AND A1 (A,B,w2);
AND A2 (w1,Cin,w3);
OR O1 (w2,w3,Cout);
endmodule

