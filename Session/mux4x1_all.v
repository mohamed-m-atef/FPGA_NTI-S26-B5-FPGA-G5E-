module MUX4X1_ALL (
input wire A,
input wire B,
input wire C,
input wire D,
input wire [1:0]S,

output wire F_GL,
output wire F_STRUCT,
output wire F_Behav,
output wire F_Data
);

MUX4X1_GL M_GL
