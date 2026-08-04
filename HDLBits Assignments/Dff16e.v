module top_module (
    input clk,
    input resetn,
    input [1:0] byteena,
    input [15:0] d,
    output reg [15:0] q
);
    always @(posedge clk)
        begin
            if (resetn ==1)
                begin
            if (byteena ==2'b11) begin
             q<=d;
        end
            else if(byteena == 2'b10)
                begin
                    q[15:8]<= d[15:8]; 
                end
            else if(byteena == 2'b01)
                begin
                    q[7:0]<= d[7:0]; 
                end
            else
                begin
                end
                end
            else
                begin
                q<=16'b0000000000000000;
                end
        end

endmodule
