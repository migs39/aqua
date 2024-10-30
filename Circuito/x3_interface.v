module x3_interface (
    input wire clock,
    input wire zera,
    input wire medir,
    input wire echo1,
    input wire echo2,
    input wire echo3,
    output wire trigger1,
    output wire trigger2,
    output wire trigger3,
    output wire [11:0]s_medida1,
    output wire [11:0]s_medida2,
    output wire [11:0]s_medida3,
    output wire fim_medida,
    output wire [3:0] db_sensor
);
    wire fim_medida1;
    wire fim_medida2;
    wire fim_medida3;

    interface_hcsr04 sensor1(
        .clock(clock),
        .reset(zera),
        .medir(medir),
        .echo(echo1),
        .trigger(trigger1),
        .medida(s_medida1),
        .pronto(fim_medida1),
        .db_estado(db_sensor)
    );

    interface_hcsr04 sensor2(
        .clock(clock),
        .reset(zera),
        .medir(medir),
        .echo(echo2),
        .trigger(trigger2),
        .medida(s_medida2),
        .pronto(fim_medida2),
        .db_estado()
    );

    interface_hcsr04 sensor3(
        .clock(clock),
        .reset(zera),
        .medir(medir),
        .echo(echo3),
        .trigger(trigger3),
        .medida(s_medida3),
        .pronto(fim_medida3),
        .db_estado()
    );

    assign fim_medida = fim_medida1 & fim_medida2 & fim_medida3;

endmodule