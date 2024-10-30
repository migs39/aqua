module buzzer(
    input wire clock,
    input wire zera,
    input wire liga,
    input wire desliga,
    output wire sinal
);
    reg estado_buzzer;

    always @(posedge clock or posedge zera) begin
        if (zera) begin
            estado_buzzer <= 1'b0;
        end
        else begin
            if (liga) begin
                estado_buzzer <= 1'b1;  
            end
            else if (desliga) begin
                estado_buzzer <= 1'b0;  
            end
        end
    end
    
    assign sinal = estado_buzzer;
endmodule