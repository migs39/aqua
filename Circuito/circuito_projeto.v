module circuito_projeto (
    input wire clock,
    input wire reset,
    input wire iniciar,
    input wire echo1,
    input wire echo2,
    input wire echo3,
    input wire RX,
    output wire trigger1,
    output wire trigger2,
    output wire trigger3,
    output wire [11:0] distancia,
    output wire saida_serial,
    output wire buzzer_alta,
    output wire buzzer_baixa,
    output wire pronto,
    output wire abre_valvula,
    output wire [3:0] db_estado,
    output wire [3:0] db_sensor,
    output wire db_fim_medida,
    output wire db_manual,
    output wire db_abre_auto,
    output wire db_fecha_auto,
    output wire [7:0]  db_nv_crit,
    output wire [7:0]  db_nv_baixo,
    output wire [7:0]  db_nv_alto
);
    wire s_zera;
    wire s_fim_1s;
	wire s_fim_2s;
    wire s_fim_estado4;
    wire s_fim_medida;
    wire s_fim_caracter;
    wire s_fim_mensagem;
    wire s_fim_classificacao;
    wire s_conta_1s;
	wire s_conta_2s;
    wire s_conta_estado4;
    wire s_mensurar;
    wire s_envia;
    wire s_muda;
    wire s_analisa_medida;
    wire [2:0] s_medida_classificacao;
    wire s_descartar_medida;
    wire s_liga_buzzer_alta;
    wire s_liga_buzzer_baixa;
    wire s_desliga_buzzer;
    wire s_zera_vlv;
    wire abre_valvula_auto;
    wire fecha_valvula_auto;

    circuito_projeto_fd FD(
        .clock(clock),
        .echo1(echo1),
        .echo2(echo2),
        .echo3(echo3),
        .zera(s_zera),
        .conta_1s(s_conta_1s),
		.conta_2s(s_conta_2s),
        .conta_estado4(s_conta_estado4),
        .mensurar(s_mensurar),
        .envia(s_envia),
        .muda(s_muda),
        .analisa_medida(s_analisa_medida),
        .liga_buzzer_baixa(s_liga_buzzer_baixa),
        .liga_buzzer_alta(s_liga_buzzer_alta),
        .desliga_buzzers(s_desliga_buzzer),
        .zera_vlv(s_zera_vlv),
        .RX(RX),
        .abre_valvula_auto(abre_valvula_auto),
        .fecha_valvula_auto(fecha_valvula_auto),
        .fim_medida(s_fim_medida),
        .fim_carater(s_fim_caracter),
        .fim_mensagem(s_fim_mensagem),
        .fim_classificacao(s_fim_classificacao),
        .trigger1(trigger1),
        .trigger2(trigger2),
        .trigger3(trigger3),
        .distancia(distancia),
        .fim_1s(s_fim_1s),
		.fim_2s(s_fim_2s),
        .fim_estado4(s_fim_estado4),
        .saida_serial(saida_serial),
        .medida_classificacao(s_medida_classificacao),
        .descartar_medida(s_descartar_medida),
        .buzzer_alta(buzzer_alta),
        .buzzer_baixa(buzzer_baixa),
        .abrir_valv(abre_valvula),
        .db_sensor(db_sensor),
        .db_manual(db_manual),
        .db_abre_auto(db_abre_auto),
        .db_fecha_auto(db_fecha_auto),
        .db_nv_baixo(db_nv_baixo),
        .db_nv_alto(db_nv_alto),
        .db_nv_crit(db_nv_crit)
    );

    circuito_projeto_uc UC(
        .clock(clock),
        .reset(reset),
        .iniciar(iniciar),
        .fim_medida_nivel(s_fim_medida),
        .descartar_medida(s_descartar_medida),
        .medida_classificacao(s_medida_classificacao),
        .valvula_aberta(abre_valvula),
        .fim_1s(s_fim_1s),
		.fim_2s(s_fim_2s),
        .fim_estado4(s_fim_estado4),
        .fim_caracter(s_fim_caracter),
        .fim_mensagem(s_fim_mensagem),
        .fim_classificacao(s_fim_classificacao),
        .zera_vlv(s_zera_vlv),
        .zera(s_zera),
        .mensurar_nvl(s_mensurar),
        .analisa(s_analisa_medida),
        .liga_buzzer_baixa(s_liga_buzzer_baixa),
        .liga_buzzer_alta(s_liga_buzzer_alta),
        .desliga_buzzers(s_desliga_buzzer),
        .abre(abre_valvula_auto),
        .fecha(fecha_valvula_auto),
        .conta_1s(s_conta_1s),
		.conta_2s(s_conta_2s),
        .conta_estado4(s_conta_estado4),
        .envia(s_envia),
        .muda(s_muda),
        .pronto(pronto),
        .db_estado(db_estado)
    );

    assign db_fim_medida = s_fim_medida;



endmodule