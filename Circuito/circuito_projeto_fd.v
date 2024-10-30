module circuito_projeto_fd (
    input wire         clock,
    input wire         echo1,
    input wire         echo2,
    input wire         echo3,
    input wire         zera,
    input wire         conta_1s,
	 input wire         conta_2s,
    input wire         mensurar,
    input wire         envia,
    input wire         muda,
    input wire         analisa_medida,
    input wire         liga_buzzer_baixa,
    input wire         liga_buzzer_alta,
    input wire         desliga_buzzers,
    input wire         zera_vlv,
    output wire        fim_medida,
    output wire        fim_carater,
    output wire        fim_mensagem,
    output wire        fim_classificacao,
    output wire        trigger1,
    output wire        trigger2,
    output wire        trigger3,
    output wire [11:0] distancia,
    output wire        fim_1s,
	 output wire        fim_2s,
    output wire        saida_serial,
    output wire [2:0]  medida_classificacao,
    output wire        descartar_medida,
    output wire        buzzer_alta,
    output wire        buzzer_baixa,
    output wire [3:0]  db_sensor
);

    parameter HEXA_30 = 7'b0110000;
    parameter HEXA_23 = 7'b0100011; 

    wire s_pulso_mensurar;
    wire [6:0] s_caracter;
    wire [2:0] s_posicao;
    wire [23:0] s_asc_posicao;
    wire [1:0] s_seletor_asc;
    wire [11:0] s_media;
    wire [11:0] s_medida1;
    wire [11:0] s_medida2;
    wire [11:0] s_medida3;

    edge_detector pulsoMensurar (
        .clock(clock  ),
        .reset(reset  ),
        .sinal(mensurar  ), 
        .pulso(s_pulso_mensurar)
    );

    classificador_medida classificador (
        .clock(clock),
        .zera(zera),
        .iniciar(analisa_medida),        
        .medida1(s_medida1),  
        .medida2(s_medida2),
        .medida3(s_medida3),
        .media(s_media),  
        .medida_classificacao(medida_classificacao),  
        .descartar_medida(descartar_medida),
        .fim_classificacao(fim_classificacao) 
    );

    x3_interface sensores (
        .clock(clock),
        .zera(zera),
        .medir(s_pulso_mensurar),
        .echo1(echo1),
        .echo2(echo2),
        .echo3(echo3),
        .trigger1(trigger1),
        .trigger2(trigger2),
        .trigger3(trigger3),
        .s_medida1(s_medida1),
        .s_medida2(s_medida2),
        .s_medida3(s_medida3),
        .fim_medida(fim_medida),
        .db_sensor(db_sensor)
    );



    contador_m #(
        .M (50000),
        .N (27)
    ) contador_1s (
        .clock   (clock     ),
        .zera_as (1'b0      ),
        .zera_s  (zera      ),
        .conta   (conta_1s  ),
        .Q       (          ),  // s_resto (desconectado)
        .fim     (fim_1s    ),  // fim (desconectado)
        .meio    (          )
    );
	 
	 contador_m #(
        .M (100000),
        .N (27)
    ) contador_2s (
        .clock   (clock     ),
        .zera_as (1'b0      ),
        .zera_s  (zera      ),
        .conta   (conta_2s  ),
        .Q       (          ),  // s_resto (desconectado)
        .fim     (fim_2s    ),  // fim (desconectado)
        .meio    (          )
    );



    //--------------------------------------
    // Parte Responsavel pelo envio do ASCII
    //--------------------------------------

    contador_m #(
        .M (4),
        .N (2)
    ) contador_caracter (
        .clock   (clock     ),
        .zera_as (1'b0      ),
        .zera_s  (zera      ),
        .conta   (muda      ),
        .Q       (s_seletor_asc),  
        .fim     (fim_mensagem), 
        .meio    (          )
    );


    mux_4x1_n #(
        .BITS (7)
    ) saida_asc (
        .D3(HEXA_23),
        .D2(s_media[3:0] + HEXA_30),
        .D1(s_media[7:4] + HEXA_30),
        .D0(s_media[11:8] + HEXA_30),
        .SEL(s_seletor_asc),
        .MUX_OUT(s_caracter)
    );

    tx_serial_7O1 envia_asc(
        .clock(clock),
        .reset(zera),
        .partida(envia),   
        .dados_ascii(s_caracter),     
        .saida_serial(saida_serial),     
        .pronto(fim_carater),          
        .db_clock(),       
        .db_tick(),         
        .db_partida(),      
        .db_saida_serial(), 
        .db_estado()       
    );

    //--------------------------------------
    // Parte Responsavel pelos buzzers
    //--------------------------------------

    buzzer b1(
        .clock(clock),
        .zera(zera_vlv),
        .liga(liga_buzzer_alta),
        .desliga(desliga_buzzers),
        .sinal(buzzer_alta)  
    );

    buzzer b2(
        .clock(clock),
        .zera(zera_vlv),
        .liga(liga_buzzer_baixa),
        .desliga(desliga_buzzers),
        .sinal(buzzer_baixa)  
    );

    assign distancia = s_media;



endmodule