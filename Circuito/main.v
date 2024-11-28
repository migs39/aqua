module main (
    input wire        clock,
    input wire        reset,
    input wire        iniciar,
    input wire        echo1,
    input wire        echo2,
    input wire        echo3,
    input wire        RX,
    input wire        switch_teste_in,
    input wire        troca_hex,
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
    output wire [6:0] hex3,
    output wire [6:0] hex4,
    output wire [6:0] hex5,
    output wire       pronto,
    output wire       db_iniciar,
    output wire       db_fim_medida,
    output wire       switch_teste_out,
    output wire       db_abre_valvula,
    output wire       db_manual,
    output wire       db_abre_auto,
    output wire       db_fecha_auto
);

    // Sinais internos
    wire        s_iniciar;
    wire [11:0] s_medida ;
    wire [3:0]  s_estado ;
    wire [3:0]  s_sensor ;

    wire [3:0]  s_h0;
    wire [3:0]  s_h1;
    wire [3:0]  s_h2;
    wire [3:0]  s_h3;
    wire [3:0]  s_h4;
    wire [3:0]  s_h5;
    
    wire [7:0] db_nv_alto;
    wire [7:0] db_nv_baixo;
    wire [7:0] db_nv_crit;
 
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
        .db_fim_medida(db_fim_medida),
        .db_manual(db_manual),
        .db_abre_auto(db_abre_auto),
        .db_fecha_auto(db_fecha_auto),
        .db_nv_alto(db_nv_alto),
        .db_nv_baixo(db_nv_baixo),
        .db_nv_crit(db_nv_crit)
    );

    mux_2x1_n #(
        .BITS(4)
    ) muxH0(
        .D1(db_nv_baixo[3:0]),
        .D0(s_medida[3:0]),
        .SEL(troca_hex),
        .MUX_OUT(s_h0)
    );

    mux_2x1_n #(
        .BITS(4)
    ) muxH1(
        .D1(db_nv_baixo[7:4]),
        .D0(s_medida[7:4]),
        .SEL(troca_hex),
        .MUX_OUT(s_h1)
    );

    mux_2x1_n #(
        .BITS(4)
    ) muxH2(
        .D1(db_nv_alto[3:0]),
        .D0(s_medida[11:8]),
        .SEL(troca_hex),
        .MUX_OUT(s_h2)
    );

    mux_2x1_n #(
        .BITS(4)
    ) muxH3(
        .D1(db_nv_alto[7:4]),
        .D0(4'b0000),
        .SEL(troca_hex),
        .MUX_OUT(s_h3)
    );

    mux_2x1_n #(
        .BITS(4)
    ) muxH4(
        .D1(db_nv_crit[3:0]),
        .D0(s_sensor),
        .SEL(troca_hex),
        .MUX_OUT(s_h4)
    );

    mux_2x1_n #(
        .BITS(4)
    ) muxH5(
        .D1(db_nv_crit[7:4]),
        .D0(s_estado),
        .SEL(troca_hex),
        .MUX_OUT(s_h5)
    );

    // Displays para medida (4 dígitos BCD)
    hexa7seg H0 (
        .hexa   (s_h0), 
        .display(hex0         )
    );
    hexa7seg H1 (
        .hexa   (s_h1), 
        .display(hex1         )
    );
    hexa7seg H2 (
        .hexa   (s_h2), 
        .display(hex2          )
    );


    // Sinal de depuração (estado da UC)
    hexa7seg H3 (
        .hexa   (s_h3), 
        .display(hex3)
    );

    hexa7seg H5 (
        .hexa   (s_h5), 
        .display(hex5)
    );

    hexa7seg H4 (
        .hexa   (s_h4 ), 
        .display(hex4)
    );



    assign db_iniciar   = iniciar;
    assign switch_teste_out = switch_teste_in;
    assign db_abre_valvula = abre_valvula;

endmodule