/* --------------------------------------------------------------------------
 *  Arquivo   : interface_hcsr04_fd-PARCIAL.v
 * --------------------------------------------------------------------------
 *  Descricao : CODIGO PARCIAL DO fluxo de dados do circuito de interface  
 *              com sensor ultrassonico de distancia
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */
 
module interface_hcsr04_fd (
    input wire         clock,
	 input wire         conta_timeout,
    input wire         pulso,
    input wire         zera,
    input wire         gera,
    input wire         registra,
    output wire        fim_medida,
    output wire        trigger,
    output wire        fim,
    output wire [11:0] distancia,
	 output wire        timeout
);

    // Sinais internos
    wire [11:0] s_medida;

    // (U1) pulso de 10us (??? clocks)
    gerador_pulso #(
        .largura( 500 ) 
    ) U1 (
        .clock ( clock ),
        .reset ( zera ),
        .gera  ( gera ),
        .para  ( 1'b0 ), 
        .pulso ( trigger ),
        .pronto(  ) // fim nao tem saida, colocamos por colocar
    );
	 
	 contador_m #(
        .M (100000000),
        .N (27)
    ) contador_2s_timeout (
        .clock   (clock     ),
        .zera_as (1'b0      ),
        .zera_s  (zera      ),
        .conta   (conta_timeout),
        .Q       (          ),  // s_resto (desconectado)
        .fim     (timeout   ),  // fim (desconectado)
        .meio    (          )
    );

    // (U2) medida em cm (R=2941 clocks)
    contador_cm #(
        .R(2941), 
        .N(12)
    ) U2 (
        .clock  ( clock ),
        .reset  ( zera ),
        .pulso  ( pulso ),
        .digito2( s_medida[11:8] ),
        .digito1( s_medida[7:4] ),
        .digito0( s_medida[3:0] ),
        .fim    ( fim ), // colocamos apos ver jpa
        .pronto ( fim_medida )
    );

    // (U3) registrador
    registrador_n #(
        .N(12)
    ) U3 (
        .clock  ( clock ),
        .clear  ( zera ),
        .enable ( registra ),
        .D      ( s_medida ),
        .Q      ( distancia )
    );

endmodule
