module flip_flop(
    input clock,
    input set,
    input reset,
    output signal
)
    reg out;
    always@(posedge clock or posedge reset)begin
        if (reset) begin
            out <= 0;
        end else if (set) begin
            out <= 1;
        end
    end

    assign signal <= out;
endmodule