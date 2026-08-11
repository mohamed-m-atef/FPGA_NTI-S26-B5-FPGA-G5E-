`default_nettype none
`timescale 1ns/1ps
module decoder2x4 #
(
	parameter N=4;
)
(
input wire [($clog2(N))-1:0]A,
input wire en,
output reg [N-1:0]F
);

always@(*)
begin
//inital value
F= {N{1'b0}};
if (en)
begin
F[A] = 1'b1;
end
end
endmodule

module decoder2x4_tb;
//TB parameter
//localparam N_tb=4
//TB signals
reg [($clog2(N_tb))-1:0]A;
reg en;
wire [N_tb-1:0] F;
decoder2x4 decod
#(.N(N_tb))
(
.A(A),
.en(en),
.F(F)
);
inital
begin
$dumpfile("dump.vcd");
$dumpvars(0,decoder2x4_tb);
en = 1'b0;
A= 2'b01;
#10
en = 1'b1;
A= 2'b11;
#10
/*en = 1'b1;
A= 2'b00;
#10
en = 1'b1;
A= 2'b00;
#10*/
en = 1'b1;
A= 2'b00;
#10
en = 1'b1;
A= 2'b01;
#10
en = 1'b1;
A= 2'b10;
#10
en = 1'b1;
A= 2'b11;
#10
end


endmodule
