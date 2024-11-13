module valvula (
    input manual,
    input abre_auto,
    input fecha_auto,
    input abre_manual,
    output wire abre_valvula,
    output wire db_manual,
    output wire db_abre_auto,
    output wire db_fecha_auto
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
    assign db_manual = manual;
    assign db_abre_auto = abre_auto;
    assign db_fecha_auto = fecha_auto;

endmodule
