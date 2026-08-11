module FA_Behavioral (A,B,Cin,S,Cout);
input A,B,Cin;
output reg S,Cout;
always@(*)
begin
S =A^B^Cin;
Cout = (A&B)|(Cin&(A^B));
end
endmodule
