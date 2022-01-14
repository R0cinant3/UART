`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2022 11:30:12 AM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx
    #(
    parameter CLK_RATE = 100000000,
    parameter BAUD_RATE = 115200,
    parameter WORD_LENGTH = 8
    )
    (
    input i_rst_n,
    input i_clk,
    input i_rx_serial,
    output o_rx_valid,
    output [WORD_LENGTH-1:0] o_rx_byte
    );
    
    
localparam CLKS_PER_BIT = CLK_RATE/BAUD_RATE;

localparam IDLE = 3'b000;
localparam RX_START = 3'b001;
localparam RX_DATA = 3'b010;
localparam RX_STOP = 3'b011;
localparam WAIT = 3'b100;

reg [$clog2(CLKS_PER_BIT)-1:0] r_clk_count;
reg [$clog2(WORD_LENGTH)-1:0] r_bit_index; 
reg [2:0] state = IDLE;
reg r_rx_valid;
reg [WORD_LENGTH-1:0] r_rx_byte;

always @(posedge i_clk or negedge i_rst_n)
    begin
        if(~i_rst_n) begin
        
        end
        else begin
            r_clk_count <= r_clk_count + 1;
            case(state)
                IDLE:
                    begin
                        r_clk_count <= 0;
                        r_rx_valid <= 1'b0;
                        r_bit_index <= 0;
                        if(i_rx_serial == 1'b0)
                            state <= RX_START;
                        else
                            state <= IDLE;
                    end
                RX_START:
                    begin
                        if(r_clk_count == (CLKS_PER_BIT-1)/2) begin
                            if(i_rx_serial == 1'b0) begin
                                state <= RX_DATA;
                                r_clk_count <= 0;
                            end else
                                state <= IDLE;
                        end else
                            state <= RX_START;
                    end 
                RX_DATA:
                    begin
                        if(r_clk_count < CLKS_PER_BIT-1)
                            state <= RX_DATA;
                        else begin
                            r_clk_count <= 0;
                            r_bit_index <= r_bit_index + 1;
                            r_rx_byte[r_bit_index] <= i_rx_serial;
                            if(r_bit_index < 7)
                                state <= RX_DATA;
                            else begin
                                r_bit_index <= 0;
                                state <= RX_STOP;
                            end
                        end
                    end
                RX_STOP:
                    begin
                        if(r_clk_count < CLKS_PER_BIT-1)
                            state <= RX_STOP;
                        else begin
                            r_clk_count <= 0;
                            state <= WAIT;
                            r_rx_valid <= 1'b1;
                        end
                    end
                WAIT:
                    begin
                        r_rx_valid <= 1'b0;
                        state <= IDLE;
                    end 
                default:
                    state <= IDLE;
            endcase       
        end
    end
    
    assign o_rx_valid = r_rx_valid;
    assign o_rx_byte = r_rx_byte;
endmodule