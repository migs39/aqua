module mux_4x1_n #(
    parameter BITS = 4
) (
    input  [BITS-1:0] D3,
    input  [BITS-1:0] D2,
    input  [BITS-1:0] D1,
    input  [BITS-1:0] D0,
    input  [1:0]      SEL,
    output [BITS-1:0] MUX_OUT
);

    assign MUX_OUT = (SEL == 2'b11) ? D3 :
                     (SEL == 2'b10) ? D2 :
                     (SEL == 2'b01) ? D1 :
                     (SEL == 2'b00) ? D0 :
                     {BITS{1'b1}}; // default 

endmodule