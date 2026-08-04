module and_gate_2in (a,b ,c);
input a ,b;
output c;
assign c = a & b;
endmodule 

module and_gate_3in (a,b ,c,d);
input a ,b,c;
output d;
assign d = a & b &c;
endmodule 

module or_gate (a ,b ,c);
input a ,b;
output c;
assign c= a|b;
endmodule

module not_gate (a,b);
input a;
output b;
assign b =~a;
endmodule

module xor_gate (a ,b ,c);
input a ,b;
output c;
assign c= a^b;
endmodule

module decoder (
input A0,
input A1,
input en,
output d0,
output d1,
output d2,
output d3
);
wire not_a , not_b ;
not_gate N1 (.a(A0),.b(not_a));
not_gate N2 (.a(A1),.b(not_b));
and_gate_3in AND1 (.a(not_a) , .b(not_b), .c(w_en) , .d(d0));
and_gate_3in AND2 (.a(not_a) , .b(A1), .c(w_en) , .d(d1));
and_gate_3in AND3 (.a(A0) , .b(not_b), .c(w_en) , .d(d2));
and_gate_3in AND4 (.a(A0) , .b(A1), .c(w_en) , .d(d3));
endmodule

module register_32(
input clk,
input [31:0] w_data,
input load,
input rst,
output reg [31:0] q
);
always@(posedge clk or posedge rst)
begin
if (rst)
q<=32'b0;
else if (load)
q<=w_data;
end
endmodule

module driver (
input [31:0] data,
input enable,
output [31:0] out
);
assign out = enable ? data : 32'bz;
endmodule

module top_Module_register_file(
input [31:0] w_data,
input w_addr_0,
input w_addr_1,
input w_en,
input clk,
input reset_reg,
input r_en,
input r_addr_0,
input r_addr_1,
output [31:0] r_data
);
wire d0,d1,d2,d3,d4,d5,d6,d7;
wire [31:0]w1;
wire [31:0]w2;
wire [31:0]w3;
wire [31:0]w4;

decoder DEC_wirte (
.A0(w_addr_0),
.A1(w_addr_1),
.en(w_en),
.d0(d0),
.d1(d1),
.d2(d2),
.d3(d3)
);

register_32 REG_1 (.w_data(w_data),.clk(clk),.rst(reset_reg),.load(d0),.q(w1));
register_32 REG_2 (.w_data(w_data),.clk(clk),.rst(reset_reg),.load(d1),.q(w2));
register_32 REG_3 (.w_data(w_data),.clk(clk),.rst(reset_reg),.load(d2),.q(w3));
register_32 REG_4 (.w_data(w_data),.clk(clk),.rst(reset_reg),.load(d3),.q(w4));

decoder DEC_read (
.A0(r_addr_0),
.A1(r_addr_1),
.en(r_en),
.d0(d4),
.d1(d5),
.d2(d6),
.d3(d7)
);

driver DRIVER_1(.data(w1),.enable(d4),.out(r_data));
driver DRIVER_2(.data(w2),.enable(d5),.out(r_data));
driver DRIVER_3(.data(w3),.enable(d6),.out(r_data));
driver DRIVER_4(.data(w4),.enable(d7),.out(r_data));

endmodule
