`timescale 1ns / 1ps


module uart_rx_tb();
   
    parameter c_CLK_RATE = 100000000;
    parameter c_BAUD_RATE = 115200;    
    parameter c_CLKS_PER_BIT = c_CLK_RATE/c_BAUD_RATE;
    parameter c_WORD_LENGTH = 8;
    
    parameter c_CLK_PERIOD_NS = 1000000000/c_CLK_RATE;
    parameter c_BIT_PERIOD = 8600;
    
    parameter c_TEST_VALUE = 8'h37;
    
    integer i = 0;
    
    reg r_rst_n = 1;
    reg r_clk = 0;
    reg r_rx_serial = 1;
    reg [c_WORD_LENGTH-1:0] r_data = c_TEST_VALUE;
    wire w_rx_valid;
    wire [c_WORD_LENGTH-1:0] w_rx_byte;
    
    uart_rx
    #(  
    .CLK_RATE(c_CLK_RATE),
    .BAUD_RATE(c_BAUD_RATE),
    .WORD_LENGTH(c_WORD_LENGTH)
    ) uart_rx_inst
    (
    .i_rst_n(r_rst_n),
    .i_clk(r_clk),
    .i_rx_serial(r_rx_serial),
    .o_rx_valid(w_rx_valid),
    .o_rx_byte(w_rx_byte)
    );
    
    always 
        #(c_CLK_PERIOD_NS/2) r_clk <= !r_clk;
        
    initial begin
        @(posedge r_clk);
        
        r_rx_serial <= 1'b0;
        #(c_BIT_PERIOD);
        #1000;
        
        for(i = 0; i < c_WORD_LENGTH; i = i + 1) begin
            r_rx_serial <= r_data[i];
            #(c_BIT_PERIOD);
        end
        
        r_rx_serial <= 1'b1;
        #(c_BIT_PERIOD);
        
        @(posedge r_clk);
        
        if(w_rx_byte == c_TEST_VALUE)
            $display("Test Passed - Correct Byte Received");
        else
            $display("Test Failed - Incorrect Byte Received");
    end

endmodule