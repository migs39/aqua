module mux_1x4 (
    input [1:0] sel,       // 2-bit selector
    output reg out0,       // Output for input 0
    output reg out1,       // Output for input 1
    output reg out2,       // Output for input 2
    output reg out3        // Output for input 3
);

    always @(*) begin
        // Reset all outputs to 0
        out0 = 1'b0;
        out1 = 1'b0;
        out2 = 1'b0;
        out3 = 1'b0;

        // Set the appropriate output based on the selector
        case (sel)
            2'b00: out0 = 1'b1; // Set out0 when sel is 00
            2'b01: out1 = 1'b1; // Set out1 when sel is 01
            2'b10: out2 = 1'b1; // Set out2 when sel is 10
            2'b11: out3 = 1'b1; // Set out3 when sel is 11
            default: begin
                out0 = 1'b0; // Default case to avoid latches
                out1 = 1'b0;
                out2 = 1'b0;
                out3 = 1'b0;
            end
        endcase
    end

endmodule