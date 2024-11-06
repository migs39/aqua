module valvula (
    input manual,
    input abre_auto,
    input fecha_auto,
    input abre_manual,
    output reg abre_valvula
);

    reg sig = 1'b0;

    always @(*) begin
        if (manual) begin
            sig = abre_manual; 
        end else begin
            if (abre_auto) begin
                sig = 1'b1; 
            end else if (fecha_auto) begin
                sig = 1'b0; 
            end
        end
    end

    assign abre_valvula = sig;

endmodule
