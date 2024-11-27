/* -----------------Laboratorio Digital-----------------------------------
 *  Arquivo   : registrador_n.v
 * -----------------------------------------------------------------------
 *  Descricao : registrador com numero de bits N como parametro
 *              com clear assincrono e carga sincrona
 * 
 *              baseado no codigo vreg16.v do livro
 *              J. Wakerly, Digital design: principles and practices 5e
 *
 * -----------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      11/01/2024  1.0     Edson Midorikawa  criacao
 * -----------------------------------------------------------------------
 */
 
module registrador_n_initial #(parameter N = 8, parameter [N-1:0] INIT_VALUE = 0) (
    input          clock,
    input          clear,
    input          enable,
    input  [N-1:0] D,
    output [N-1:0] Q
);

    reg [N-1:0] IQ = INIT_VALUE;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= INIT_VALUE;
        else if (enable && D != 0)
            IQ <= D;
    end

    assign Q = IQ;

endmodule
