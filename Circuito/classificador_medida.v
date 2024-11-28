module classificador_medida #(
    parameter MAX_DIFF = 12'b000000000100    // Diferença máxima entre a maior e a menor medida
)(
    input wire [11:0] nv_baixo,
    input wire [11:0] nv_alto,
    input wire [11:0] nv_crit,
    input wire clock,
    input wire zera,
    input wire iniciar,        // Sinal para iniciar o processo
    input wire [11:0] medida1,  
    input wire [11:0] medida2,
    input wire [11:0] medida3,
    output reg [11:0] media,  // Média das medidas
    output reg [2:0] medida_classificacao,  // Classificação da média
    output reg descartar_medida,  // 1 se a maior e menor medida tiverem diferença > MAX_DIFF
    output reg fim_classificacao
);

    reg [11:0] maior_medida;
    reg [11:0] menor_medida;
    reg em_operacao;  // Flag para indicar se o sistema está em operação
	reg calculo_media;  // Flag para indicar se o sistema está em operação

    always @(posedge clock or posedge zera) begin
        if (zera) begin
            media <= 0;
            medida_classificacao <= 3'b000;
            descartar_medida <= 0;
            calculo_media <= 0;
            em_operacao <= 0;
            fim_classificacao <= 0;
        end else if (iniciar && !em_operacao && !calculo_media) begin
            calculo_media <= 1;  // Inicia o processo
        end else if (calculo_media) begin
            // Cálculo da média
            media <= (medida1 + medida2 + medida3)/3;

            // Identificação da maior e menor medida
            maior_medida <= (medida1 > medida2) ? ((medida1 > medida3) ? medida1 : medida3) : ((medida2 > medida3) ? medida2 : medida3);
            menor_medida <= (medida1 < medida2) ? ((medida1 < medida3) ? medida1 : medida3) : ((medida2 < medida3) ? medida2 : medida3);

            calculo_media <= 0;
            em_operacao <= 1;
        end else if (em_operacao) begin

            // Determinação de descartar_medida
            if ((maior_medida - menor_medida) > MAX_DIFF)
                descartar_medida <= 1;
            else
                descartar_medida <= 0;

            // Classificação da média
            if (media > nv_baixo)
                medida_classificacao <= 3'b001;
            else if (media <= nv_baixo && media > nv_alto)
                medida_classificacao <= 3'b100;
            else if (media <= nv_alto && media >= nv_crit)
                medida_classificacao <= 3'b010;
            else
                medida_classificacao <= 3'b011;

            // Após o cálculo, o processo é considerado concluído
            em_operacao <= 0;  // Desativa a operação após o término do processo
            fim_classificacao <= 1;
        end
    end
endmodule

