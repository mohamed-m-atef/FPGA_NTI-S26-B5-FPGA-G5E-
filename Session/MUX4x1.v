module andgate (a,b,d,c);
input a,b,d;
output c;
assign c = a&b&d;
endmodule
module orgate (a,b,c,d,e);
input a,b,c,d;
output e;
assign e = a|b|c|d;
endmodule
module notgate (a,b);
input a;
output b;
assign b =~a ;
endmodule

module mux_four_one (s0,s1,i0,i1,i2,i3,out);
input s0,s1,i0,i1,i2,i3;
output out;
wire w1,w2,w3,w4,w5,w6;
notgate G1 (s0,w1);
notgate G2 (s1,w2);
andgate G3 (s0,s1,i3,w3);
andgate G4 (w1,s1,i2,w4);
andgate G5 (s0,w2,i1,w5);
andgate G6 (w1,w2,i0,w6);
orgate G7(w3,w4,w5,w6,out);
endmodule
