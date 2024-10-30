module circuito_projeto_uc (
    input wire       clock,
    input wire       reset,
    input wire       iniciar,
    input wire       fim_medida_nivel,
    input wire       descartar_medida,
    input wire [2:0] medida_classificacao,
    input wire       valvula_aberta,
    input wire       fim_1s,
	input wire       fim_2s,
    input wire       fim_caracter,
    input wire       fim_mensagem,
    input wire       fim_classificacao,
    output reg       zera_vlv,
    output reg       zera,
    output reg       mensurar_nvl,
    output reg       analisa,
    output reg       liga_buzzer_baixa,
    output reg       liga_buzzer_alta,
    output reg       desliga_buzzers,
    output reg       abre,
    output reg       fecha,
    output reg       conta_1s,
	output reg       conta_2s,
    output reg       envia,
    output reg       muda,
    output reg       pronto,
    output reg [3:0] db_estado
);

    // Tipos e sinais
    reg [3:0] Eatual, Eprox;

    // Parâmetros para os estados
    parameter inicial                   = 4'b0000;
    parameter zera_valvulas             = 4'b0001;
    parameter inicio_ciclo              = 4'b0010;
    parameter preparacao                = 4'b0011;
    parameter medir_nivel               = 4'b0100;
    parameter analisa_medida            = 4'b0101;
    parameter medida_nao_critica        = 4'b0110;
    parameter medida_critica_baixa      = 4'b0111;
    parameter medida_critica_alta       = 4'b1000;
    parameter medida_critica_muito_alta = 4'b1001;
    parameter abre_valvula              = 4'b1010;
    parameter fecha_valvula             = 4'b1011;
    parameter espera_1s                 = 4'b1100;
    parameter envia_caracter            = 4'b1101;
    parameter muda_caracter             = 4'b1110;
    parameter fim_ciclo                 = 4'b1111;

    // Estado
    always @(posedge clock, posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial:
                Eprox = iniciar ? zera_valvulas : inicial;

            zera_valvulas:
                Eprox = inicio_ciclo;

            inicio_ciclo:
                Eprox = iniciar ? preparacao : inicio_ciclo;

            preparacao:
                Eprox = medir_nivel;

            medir_nivel:
                Eprox = fim_medida_nivel ? analisa_medida : medir_nivel;
            analisa_medida: begin
                if (descartar_medida) begin
                    Eprox = inicio_ciclo;
                end else if (fim_classificacao) begin
                    case (medida_classificacao)
                        3'b000: Eprox = analisa_medida;
                        3'b001: Eprox = medida_critica_baixa;
                        3'b010: Eprox = medida_critica_alta;
                        3'b011: Eprox = medida_critica_muito_alta;
                        3'b100: Eprox = medida_nao_critica;
                        default: Eprox = analisa_medida;
                    endcase
                end else begin
                    Eprox = analisa_medida;
                end
            end

            medida_nao_critica:
                Eprox = valvula_aberta ? fecha_valvula : envia_caracter;
            medida_critica_baixa:
                Eprox = valvula_aberta ? fecha_valvula : envia_caracter;
            medida_critica_alta:
                Eprox = envia_caracter;

            medida_critica_muito_alta:
                Eprox = valvula_aberta ? envia_caracter : abre_valvula;

            abre_valvula,
            fecha_valvula:
                Eprox = espera_1s;

            espera_1s:
                Eprox = fim_1s ? envia_caracter : espera_1s;

            envia_caracter:
                Eprox = fim_caracter ? (fim_mensagem ? fim_ciclo : muda_caracter) : envia_caracter;

            muda_caracter:
                Eprox = envia_caracter;

            fim_ciclo:
                Eprox = fim_2s ? inicio_ciclo : fim_ciclo;

            default:
                Eprox = inicial;
        endcase
    end

    // Saídas de controle
    always @(*) begin
        // Zerar todas as saídas
        zera_vlv          = (Eatual == zera_valvulas);
        zera              = (Eatual == preparacao);
        mensurar_nvl      = (Eatual == medir_nivel);
        analisa           = (Eatual == analisa_medida);
        liga_buzzer_alta  = ((Eatual == medida_critica_muito_alta) || (Eatual == medida_critica_alta));
        liga_buzzer_baixa = (Eatual == medida_critica_baixa);
        desliga_buzzers   = (Eatual == medida_nao_critica);
        abre              = (Eatual == abre_valvula);
        fecha             = (Eatual == fecha_valvula);
        conta_1s          = (Eatual == espera_1s);
		conta_2s          = (Eatual == fim_ciclo);
        envia             = (Eatual == envia_caracter);
        muda              = (Eatual == muda_caracter);
        pronto            = (Eatual == fim_ciclo);

        // Exibir estado atual
        case (Eatual)
            inicial:                    db_estado  = 4'b0000;
            zera_valvulas:              db_estado  = 4'b0001;
            inicio_ciclo:               db_estado  = 4'b0010;
            preparacao:                 db_estado  = 4'b0011;
            medir_nivel:                db_estado  = 4'b0100;
            analisa_medida:             db_estado  = 4'b0101;
            medida_nao_critica:         db_estado  = 4'b0110;
            medida_critica_baixa:       db_estado  = 4'b0111;
            medida_critica_alta:        db_estado  = 4'b1000;
            medida_critica_muito_alta:  db_estado  = 4'b1001;
            abre_valvula:               db_estado  = 4'b1010;
            fecha_valvula:              db_estado  = 4'b1011;
            espera_1s:                  db_estado  = 4'b1100;
            envia_caracter:             db_estado  = 4'b1101;
            muda_caracter:              db_estado  = 4'b1110;
            fim_ciclo:                  db_estado  = 4'b1111;
            default:                    db_estado  = 4'b1110;
        endcase
    end

endmodule
