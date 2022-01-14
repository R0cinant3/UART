`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/13/2022 06:41:37 PM
// Design Name: 
// Module Name: clock_divider
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


module clock_divider
    #(
        parameter INPUT_FREQUENCY = 100000000,
        parameter OUTPUT_FREQUENCY = 1
      )
    (
    input i_clk,
    output o_clk
    );
        
    localparam CLOCK_CYCLES = INPUT_FREQUENCY / (2*OUTPUT_FREQUENCY) - 1;
    integer counter_value = 0;
    
    reg r_divided_clk = 0;
    
    always @(posedge i_clk) begin
        if(counter_value <  CLOCK_CYCLES)
            counter_value <= counter_value + 1;
        else begin
            counter_value <= 0;
            r_divided_clk <= ~r_divided_clk;
        end
    end   
    
    assign o_clk = r_divided_clk;
 
endmodule
