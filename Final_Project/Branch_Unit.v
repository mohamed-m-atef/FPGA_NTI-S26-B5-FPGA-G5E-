module Branch_Unit(
input wire Branch,
input wire Zero,

output wire Branch_Result

);


assign Branch_Result = Branch & Zero;


endmodule 
