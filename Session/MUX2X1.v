module MUX2X1 
(
  input wire [3:0] A, [3:0] B, S,
  //input wire B,
  //input wire S,
  output F
);
  // Data flow
  assign F = S? B : A;
  /*
  // Behavioral 1
  always@(*)
    begin
	  case(S)
	    1'b1: F = B;
		1'b0: F = A;
		default: F = A;
	  endcase
	end
  // Behavioral 2
  always@(*)
    begin
      if(S)
	    F = B;
	  else
	    F = A;
	end  
 
  // GL
  wire NS, AND_B_S, AND_A_NS;
 
  and AND1 (AND_B_S, B, S);
  not not1 (NS, S);
  and AND2 (AND_A_NS, A, NS);
  or  OR1  (F, AND_B_S, AND_A_NS);
  */
endmodule
