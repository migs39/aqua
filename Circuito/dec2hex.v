module dec2hex (
    input [5:0] decimal,     // Entrada decimal de 6 bits (valores de 0 a 63)
    output reg [11:0] hex_out // Saída hexadecimal de 3 dígitos (4 bits para cada dígito)
);

    reg [3:0] dezena;  // Dígito da dezena (4 bits)
    reg [3:0] unidade;  // Dígito da unidade (4 bits)

    always @(*) begin
        // Converte o valor decimal diretamente para hexadecimal
        dezena = decimal / 10;   // Calcula a dezena
        unidade = decimal % 10;  // Calcula a unidade
        hex_out = {4'b0000, dezena, unidade};
    end

endmodule