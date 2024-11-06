`timescale 1ns/1ns

module aqua_tb;

    // Declaração de sinais
    reg         clock_in = 0;
    reg         reset_in = 0;
    reg         iniciar_in = 0;
    reg         echo_in_1 = 0;
    reg         echo_in_2 = 0;
    reg         echo_in_3 = 0;
    reg         RX_in = 0;
    wire        trigger_out_1;
    wire        trigger_out_2;
    wire        trigger_out_3;
    wire        buzzer_alta_out;
    wire        buzzer_baixa_out;
    wire        abre_valvula_out;
    wire [6:0]  hex0_out;
    wire [6:0]  hex1_out;
    wire [6:0]  hex2_out;
    wire        saida_serial_out;
    wire        pronto_out;
    wire        db_iniciar_out;
    wire        db_fim_medida_out;
    wire [6:0]  db_estado_out;
    wire [6:0]  db_estado_sensor_out;

    // Componente a ser testado (Device Under Test -- DUT)
    main dut (
        .clock(clock_in),
        .reset(reset_in),
        .iniciar(iniciar_in),
        .echo1(echo_in_1),
        .echo2(echo_in_2),
        .echo3(echo_in_3),
        .RX(RX_in),
        .trigger1(trigger_out_1),
        .trigger2(trigger_out_2),
        .trigger3(trigger_out_3),
        .buzzer_alta(buzzer_alta_out),
        .buzzer_baixa(buzzer_baixa_out),
        .abre_valvula(abre_valvula_out),
        .saida_serial(saida_serial_out),
        .hex0(hex0_out),
        .hex1(hex1_out),
        .hex2(hex2_out),
        .pronto(pronto_out),
        .db_iniciar(db_iniciar_out),
        .db_fim_medida(db_fim_medida_out),
        .db_estado(db_estado_out),
        .db_sensor(db_estado_sensor_out)
    );


    // Configurações do clock
    parameter clockPeriod = 20; // clock de 50MHz
    // Gerador de clock
    always #(clockPeriod/2) clock_in = ~clock_in;

    // Array de casos de teste (estrutura equivalente em Verilog)
    reg [31:0] casos_teste_dist [0:3][0:2]; // 4 elements, each containing 3 values of 32-bit
    integer caso;

    // Largura do pulso
    reg [31:0] larguraPulso1; // Usando 32 bits para acomodar tempos maiores
    reg [31:0] larguraPulso2; // Usando 32 bits para acomodar tempos maiores
    reg [31:0] larguraPulso3; // Usando 32 bits para acomodar tempos maiores

    // Geração dos sinais de entrada (estímulos)
    initial begin
        $display("Inicio das simulacoes");

        // Inicialização do array de casos de teste
        casos_teste_dist[0][0] = 4353; //  4353us (74cm)
        casos_teste_dist[0][1] = 4353;
        casos_teste_dist[0][2] = 4353;

        casos_teste_dist[1][0] = 5899; // 5899us (100,29cm) truncar para 100cm
        casos_teste_dist[1][1] = 5899;
        casos_teste_dist[1][2] = 5899;

        casos_teste_dist[2][0] = 5882; // 5882us (100cm)
        casos_teste_dist[2][1] = 5882;
        casos_teste_dist[2][2] = 5882;

        casos_teste_dist[3][0] = 1167;
        casos_teste_dist[3][1] = 1167;
        casos_teste_dist[3][2] = 1167;  // 1167us (20cm) 


        // Valores iniciais
        iniciar_in = 0;
        echo_in_1  = 0;
        echo_in_2  = 0;
        echo_in_3  = 0;

        // Reset
        caso = 0; 
        #(2*clockPeriod);
        reset_in = 1;
        #(2_000); // 2 us
        reset_in = 0;
        @(negedge clock_in);

        // Espera de 100us
        #(100_000); // 100 us
        
        iniciar_in = 1;
        #(100_000); // 100 us
        // Loop pelos casos de teste
        for (caso = 1; caso < 5; caso = caso + 1) begin
            // 1) Determina a largura do pulso echo
            $display("Caso de teste %0d", caso);
            larguraPulso1 = casos_teste_dist[caso-1][0]*1000; // 1us=1000
            larguraPulso2 = casos_teste_dist[caso-1][1]*1000; // 1us=1000
            larguraPulso3 = casos_teste_dist[caso-1][2]*1000; // 1us=1000

            // 2) Espera por 2s (tempo para ativacao)
            #(2_000_000); // 2 s
            
            // 3) Espera por 400us (tempo entre trigger e echo)
            #(400_000); // 400 us

            // 4) Gera pulso de echo
            echo_in_1 = 1;
            echo_in_2 = 1;
            echo_in_3 = 1;
            #(larguraPulso1);
            echo_in_1 = 0;
            #(larguraPulso2-larguraPulso1)
            echo_in_2 = 0;
            #(larguraPulso3-larguraPulso2)
            echo_in_3 = 0;

            // 5) Espera final da medida
            wait (pronto_out == 1'b1);

            $display("Fim do caso %0d", caso);
        end

        // Fim da simulação
        $display("Fim das simulacoes");
        caso = 99; 
        $stop;
    end

endmodule
