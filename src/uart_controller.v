`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2022 11:30:12 AM
// Design Name: 
// Module Name: uart_controller
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


module uart_controller(
    input i_clk,
    input i_uart_rx,
    input i_rst_n,
    output o_segment_a,
    output o_segment_b,
    output o_segment_c,
    output o_segment_d,
    output o_segment_e,
    output o_segment_f,
    output o_segment_g,
    output o_anode_1,
    output o_anode_2,
    output o_anode_3,
    output o_anode_4,
    output o_anode_5,
    output o_anode_6,
    output o_anode_7,
    output o_anode_8
    );
    
    wire w_rx_valid;
    wire [7:0] w_rx_byte;
    
    reg [3:0] r_num = 0;
    reg [1:0] r_refresh_counter = 0;
    
    wire w_clk_10kHz;
    wire w_segment_a;
    wire w_segment_b;
    wire w_segment_c;
    wire w_segment_d;
    wire w_segment_e;
    wire w_segment_f;
    wire w_segment_g;
    
    reg r_anode_1;
    reg r_anode_2;
    reg r_anode_3;
    reg r_anode_4;
    reg r_anode_5;
    reg r_anode_6;
    reg r_anode_7;
    reg r_anode_8;

    parameter c_DIVIDED_FREQ = 10000;
    parameter c_BASE_FREQ = 100000000;
    
    always @(posedge w_clk_10kHz) begin
        if(r_refresh_counter == 3)
            r_refresh_counter <= 0;
        else
            r_refresh_counter <= r_refresh_counter + 1;
    end
    
    always @(r_refresh_counter) begin
        r_anode_1 <= 1'b1;
        r_anode_2 <= 1'b1;
        r_anode_3 <= 1'b1;
        r_anode_4 <= 1'b1;
        r_anode_5 <= 1'b1;
        r_anode_6 <= 1'b1;
        r_anode_7 <= 1'b1;
        r_anode_8 <= 1'b1;
        case(r_refresh_counter)
            2'b00 : 
                begin
                    r_num <= w_rx_byte[7:4];
                    r_anode_1 <= 1'b0;
                    r_anode_5 <= 1'b0;
                end
            2'b01 : 
                begin
                    r_num <= w_rx_byte[3:0];
                    r_anode_2 <= 1'b0;
                    r_anode_6 <= 1'b0;               
                end
            2'b10 :
                begin
                    r_num <= 4'b0000;
                    r_anode_3 <= 1'b0;
                    r_anode_7 <= 1'b0;                
                end
            2'b11 :
                begin
                    r_num <= 4'b0000;
                    r_anode_4 <= 1'b0;
                    r_anode_8 <= 1'b0;               
                end
        endcase 
    end
    
    
    binary_to_7segment binary_to_7segment_inst
        (
            .i_clk(i_clk),
            .i_binary_num(r_num),
            .o_segment_a(w_segment_a),
            .o_segment_b(w_segment_b),
            .o_segment_c(w_segment_c),
            .o_segment_d(w_segment_d),
            .o_segment_e(w_segment_e),
            .o_segment_f(w_segment_f),
            .o_segment_g(w_segment_g)
        );
        
    clock_divider 
        #(
            .INPUT_FREQUENCY(c_BASE_FREQ), 
            .OUTPUT_FREQUENCY(c_DIVIDED_FREQ)
        ) clock_divider_inst1
        (
            .i_clk(i_clk),
            .o_clk(w_clk_10kHz)
        );
        
    uart_rx 
    #(
        .CLK_RATE(100000000),
        .BAUD_RATE(115200),
        .WORD_LENGTH(8)
    ) uart_rx_inst
    (
        .i_rst_n(i_rst_n),
        .i_clk(i_clk),
        .i_rx_serial(i_uart_rx),
        .o_rx_valid(w_rx_valid),
        .o_rx_byte(w_rx_byte)
    );
    assign o_anode_1 = r_anode_1;
    assign o_anode_2 = r_anode_2;
    assign o_anode_3 = r_anode_3;
    assign o_anode_4 = r_anode_4;
    assign o_anode_5 = r_anode_5;
    assign o_anode_6 = r_anode_6;
    assign o_anode_7 = r_anode_7;
    assign o_anode_8 = r_anode_8;

    assign o_segment_a = ~w_segment_a;
    assign o_segment_b = ~w_segment_b;
    assign o_segment_c = ~w_segment_c;
    assign o_segment_d = ~w_segment_d;
    assign o_segment_e = ~w_segment_e;
    assign o_segment_f = ~w_segment_f;
    assign o_segment_g = ~w_segment_g;
    
    
endmodule
