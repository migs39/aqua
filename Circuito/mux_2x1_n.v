module mux_2x1_n #(
    parameter BITS = 4
) (
    input  [BITS-1:0] D1,
    input  [BITS-1:0] D0,
    input             SEL,
    output [BITS-1:0] MUX_OUT
);

    assign MUX_OUT = (SEL == 1'b1) ? D1 :
                     (SEL == 1'b0) ? D0 :
                     {BITS{1'b1}}; // default 

endmodule