module controle_recepcao_serial (
    input reg clock,
    input reg reset,
    input reg RX,
    output wire [11:0]nv_crit,
    output wire [11:0]nv_alto,
    output wire [11:0]nv_baixo,
    output wire manual,
    output wire abrir_valv
);

    wire [7:0] dados;
    wire [5:0]nv_crit_wire;
    wire [5:0]nv_alto_wire;
    wire [5:0]nv_baixo_wire;
    wire out0;
    wire out1;
    wire out2;
    wire out3;

    rx_serial_8N1 recepcao(
        .clock(clock)      ,
        .reset(reset)      ,
        .RX(RX)         ,
        .pronto()     ,
        .dados_ascii(dados),
        .db_clock()   , 
        .db_tick()    ,
        .db_dados()   ,
        .db_estado()       
    );

    registrador_n_initial #(
        .N(6),
        .INIT_VALUE(6'b011011)
    ) critico (
        .clock  ( clock ),
        .clear  ( reset ),
        .enable ( out2 ),
        .D      ( dados[5:0] ),
        .Q      ( nv_crit_wire )
    );

    dec2hex conv_critico(
        .decimal(nv_crit_wire),
        .hex_out(nv_crit) 
    );

    registrador_n_initial #(
        .N(6),
        .INIT_VALUE(6'b011000)
    ) alto (
        .clock  ( clock ),
        .clear  ( reset ),
        .enable ( out1 ),
        .D      ( dados[5:0] ),
        .Q      ( nv_alto_wire )
    );

    dec2hex conv_alto(
        .decimal(nv_alto_wire),
        .hex_out(nv_alto) 
    );


    registrador_n_initial #(
        .N(6),
        .INIT_VALUE(6'b001100)
    ) baixo (
        .clock  ( clock ),
        .clear  ( reset ),
        .enable ( out0 ),
        .D      ( dados[5:0] ),
        .Q      ( nv_baixo_wire )
    );

    dec2hex conv_baixo(
        .decimal(nv_baixo_wire),
        .hex_out(nv_baixo) 
    );


    registrador_n_initial #(
        .N(1),
        .INIT_VALUE(0)
    ) modo (
        .clock  ( clock ),
        .clear  ( reset ),
        .enable ( out3 ),
        .D      ( dados[5] ),
        .Q      ( manual )
    );

    registrador_n_initial #(
        .N(1),
        .INIT_VALUE(0)
    ) valv (
        .clock  ( clock ),
        .clear  ( reset ),
        .enable ( out3 ),
        .D      ( dados[4] ),
        .Q      ( abrir_valv )
    );
    

    mux_1x4 seletor(
        .sel(dados[7:6]),       
        .out0(out0),       
        .out1(out1),       
        .out2(out2),       
        .out3(out3) 
    );
endmodule