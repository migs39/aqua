module main (
    input wire        clock,
    input wire        reset,
    input wire        iniciar,
    input wire        echo1,
    input wire        echo2,
    input wire        echo3,
    input wire        RX,
    output wire       trigger1,
    output wire       trigger2,
    output wire       trigger3,
    output wire       buzzer_alta,
    output wire       buzzer_baixa,
    output wire       abre_valvula,
    output wire       saida_serial,
    output wire [6:0] hex0,
    output wire [6:0] hex1,
    output wire [6:0] hex2,
    output wire       pronto,
    output wire       db_iniciar,
    output wire       db_fim_medida,
    output wire [6:0] db_estado,
    output wire [6:0] db_sensor
);

    // Sinais internos
    wire        s_iniciar;
    wire [11:0] s_medida ;
    wire [3:0]  s_estado ;
    wire [3:0]  s_sensor ;

    wire [6:0]  s_h0_medida;
    wire [6:0]  s_h1_medida;
    wire [6:0]  s_h2_medida;

    // Circuito de interface com sensor
    circuito_projeto  main(
        .clock(clock),
        .reset(reset),
        .iniciar(iniciar),
        .echo1(echo1),
        .echo2(echo2),
        .echo3(echo3),
        .RX(RX),
        .trigger1(trigger1),
        .trigger2(trigger2),
        .trigger3(trigger3),
        .distancia(s_medida),
        .saida_serial(saida_serial),
        .buzzer_alta(buzzer_alta),
        .buzzer_baixa(buzzer_baixa),
        .pronto(pronto),
        .abre_valvula(abre_valvula),
        .db_estado(s_estado),
        .db_sensor(s_sensor),
        .db_fim_medida(db_fim_medida)
    );

    // Displays para medida (4 dígitos BCD)
    hexa7seg H0medida (
        .hexa   (s_medida[3:0]), 
        .display(hex0         )
    );
    hexa7seg H1medida (
        .hexa   (s_medida[7:4]), 
        .display(hex1         )
    );
    hexa7seg H2medida (
        .hexa   (s_medida[11:8]), 
        .display(hex2          )
    );


    // Sinal de depuração (estado da UC)
    hexa7seg H5 (
        .hexa   (s_estado ), 
        .display(db_estado)
    );

    hexa7seg H4 (
        .hexa   (s_sensor ), 
        .display(db_sensor)
    );

    assign db_iniciar   = iniciar;

endmodule