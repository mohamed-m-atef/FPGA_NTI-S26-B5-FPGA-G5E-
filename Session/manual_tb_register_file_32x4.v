`timescale 1ns/1ps

module register_file_tb;

reg clk;
reg reset_reg;
reg[31:0]w_data;
reg w_addr_0;
reg w_addr_1;
reg w_en;
reg r_en;
reg r_addr_0;
reg r_addr_1;

wire [31:0] r_data;

top_Module_register_file DUT (
    .w_data(w_data),
    .w_addr_0(w_addr_0),
    .w_addr_1(w_addr_1),
    .w_en(w_en),
    .clk(clk),
    .reset_reg(reset_reg),
    .r_en(r_en),
    .r_addr_0(r_addr_0),
    .r_addr_1(r_addr_1),
    .r_data(r_data)
);

always #5 clk = ~clk;
initial
begin
clk =0;
reset_reg = 1;
w_en=0;
r_en=0;
w_addr_0=0;
w_addr_1=0;
r_addr_0=0;
r_addr_1=0;
w_data = 32'h00000000;

#10;
reset_reg=0;

w_en=1;
w_addr_0=0;
w_addr_1=0;
w_data = 32'h11111111;
#10

w_en=1;
w_addr_0=1;
w_addr_1=0;
w_data = 32'h22222222;
#10

w_en=1;
w_addr_0=0;
w_addr_1=1;
w_data = 32'h33333333;
#10

w_en=1;
w_addr_0=1;
w_addr_1=1;
w_data = 32'h44444444;
#10

w_en = 0;

r_en = 1;
r_addr_1 = 0;
r_addr_0 = 0;
#10;

r_addr_1 = 0;
r_addr_0 = 1;
#10;

r_addr_1 = 1;
r_addr_0 = 0;
#10;

r_addr_1 = 1;
r_addr_0 = 1;
#10;

reset_reg=1;
#10;
reset_reg=0;
r_addr_1=0;
r_addr_0=0;
#10

$stop;
end
endmodule
