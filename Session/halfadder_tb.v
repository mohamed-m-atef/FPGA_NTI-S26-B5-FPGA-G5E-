`timescale 1ns / 1ps
module half_adder_tb;
reg a;
reg b;
wire sum;
wire carry;
half_adder HA (.a(a),.b(b),.sum(sum) , .carry(carry));

initial 
begin
{a,b} = 2'b00;
#10;
{a,b} = 2'b01;
#10;
{a,b} = 2'b10;
#10;
{a,b} = 2'b11;
#20;
$stop;
end

endmodule
