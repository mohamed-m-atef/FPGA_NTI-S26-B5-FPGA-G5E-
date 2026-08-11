module FA_GL (A,B,Cin,S,Cout);
input A,B,Cin;
output S,Cout;
wire w1,w2,w3;
xor G1(w1,A,B);
xor G2(Sum,w1,Cin);
and G3(w2,A,B);
and G4(w3,w1,Cin);
or G5(Cout,w2,w3);
endmodule
