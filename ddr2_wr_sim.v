`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/07/26 09:34:55
// Design Name: 
// Module Name: ddr2_wr_sim
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ddr2_wr_sim(

    );
    reg clk;
    reg rst;

    reg [127:0] data;
    reg [26:0] addr;
    reg stb;
    wire ack;

    //DDR2参数
    //ddr2 parameter
    wire [15:0] ddr2_dq;
    wire [1:0] ddr2_dqs_n;
    wire [1:0] ddr2_dqs_p;
    wire [12:0] ddr2_addr;
    wire [2:0] ddr2_ba;
    wire ddr2_ras_n;
    wire ddr2_cas_n;
    wire ddr2_we_n;
    wire ddr2_ck_p;
    wire ddr2_ck_n;
    wire ddr2_cke;
    wire ddr2_cs_n;
    wire [1:0] ddr2_dm;
    wire [1:0] rdqs_n;
    wire ddr2_odt;

    reg clk_ref_i;  //MIG 参考时钟

    localparam real REFCLK_PERIOD = 2.5;

    initial
    clk_ref_i = 1'b0;
    always
    clk_ref_i = #REFCLK_PERIOD ~clk_ref_i;

    initial
    begin
        clk = 0;
        rst = 1;
        stb = 0;
        #60 
        rst = 0;
        stb = 1;

        //写入数据
        data = 128'b11110111110101011111110000110000000001110000001111110100010110111111111110110011111001110011010111110110000110000000001011000110;
        addr=27'b000000000000000000000000000;
        @(posedge ack)
        data = 128'b00000111010000011111111010000001000000111001011000000011110001110000001100100011111101001001100111111011010111001111111101111001;
        addr=27'b000000000000000000000001000;
        @(posedge ack)
        data = 128'b00000010101000010001001101100101111110111101010100000001001001110000010001011101111101011111100100001010110010011111100111010011;
        addr=27'b000000000000000000000010000;

        @(posedge ack)
        stb = 0;    //结束写入

        
    end
    
    always #5 clk = ~clk;




    ddr2_wr ddr2_wr_ins(
        .clk_in(clk),
        .rst(rst),
        //ddr2 parameter
        .ddr2_ck_p(ddr2_ck_p),
        .ddr2_ck_n(ddr2_ck_n),
        .ddr2_cke(ddr2_cke),
        .ddr2_cs_n(ddr2_cs_n),
        .ddr2_ras_n(ddr2_ras_n),
        .ddr2_cas_n(ddr2_cas_n),
        .ddr2_we_n(ddr2_we_n),
        .ddr2_dm(ddr2_dm),
        .ddr2_ba(ddr2_ba),
        .ddr2_addr(ddr2_addr),
        .ddr2_dq(ddr2_dq),
        .ddr2_dqs_p(ddr2_dqs_p),
        .ddr2_dqs_n(ddr2_dqs_n),
        .rdqs_n(rdqs_n),
        .ddr2_odt(ddr2_odt),
        .clk_ref_i(clk_ref_i),  //用于ddr
        .addr_i(addr),
        .data_i(data),
        .stb_i(stb),
        .ack_o(ack)
    );

    //仿真DDR2模型
    ddr2_model ddr2_model(
        .ck(ddr2_ck_p),
        .ck_n(ddr2_ck_n),
        .cke(ddr2_cke),
        .cs_n(ddr2_cs_n),
        .ras_n(ddr2_ras_n),
        .cas_n(ddr2_cas_n),
        .we_n(ddr2_we_n),
        .dm_rdqs(ddr2_dm),
        .ba(ddr2_ba),
        .addr(ddr2_addr),
        .dq(ddr2_dq),
        .dqs(ddr2_dqs_p),
        .dqs_n(ddr2_dqs_n),
        .rdqs_n(rdqs_n),
        .odt(ddr2_odt)
    );
endmodule
