module top_module ( input clk, input d, output q );
wire q0,q1;
    my_dff D1(clk,d,q0);
    my_dff D2(clk,q0,q1);
    my_dff D3(clk,q1,q);
endmodule
