module mux4_behavioral(
    input I0, I1, I2, I3,
    input S0, S1,
    output reg Y
);

always @(*) begin
    if (S1 == 0 && S0 == 0)
        Y = I0;
    else if (S1 == 0 && S0 == 1)
        Y = I1;
    else if (S1 == 1 && S0 == 0)
        Y = I2;
    else
        Y = I3;
end

endmodule
