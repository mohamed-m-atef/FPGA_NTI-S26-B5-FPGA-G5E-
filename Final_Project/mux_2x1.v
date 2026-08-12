module mux_2x1
#(parameter width=16)(
  input wire [width-1:0] A,
  input wire [width-1:0] B,
  
  input wire  Sel,
  output reg [width-1:0] out

);

always@(*)
begin
    out = (Sel==0 )? A : B;
end 

endmodule