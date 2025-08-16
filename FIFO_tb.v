`timescale 1ns / 1ps

module FIFO_tb;

    // Parameters
    parameter DATA_SIZE = 8;
    parameter ADDR_SIZE = 6;

    // Signals for the FIFO instance
    reg w_en, w_clk, w_rst_n;
    reg r_en, r_clk, r_rst_n;
    reg [DATA_SIZE-1:0] w_data;
    wire [DATA_SIZE-1:0] r_data;
    wire full, empty;

    // Instantiate the FIFO
    FIFO #(DATA_SIZE, ADDR_SIZE) uut (
        .w_en(w_en),
        .w_clk(w_clk),
        .w_rst_n(w_rst_n),
        .w_data(w_data),
        .r_en(r_en),
        .r_clk(r_clk),
        .r_rst_n(r_rst_n),
        .r_data(r_data),
        .full(full),
        .empty(empty)
    );

    // Clock generation
    initial begin
        w_clk = 0;
        forever #5 w_clk = ~w_clk; // 10ns period
    end

    initial begin
        r_clk = 0;
        forever #7 r_clk = ~r_clk; // 14ns period
    end

    // Test sequence
    initial begin
        // Initialize signals
        w_rst_n = 0;
        r_rst_n = 0;
        w_en = 0;
        r_en = 0;
        w_data = 0;

        // Apply reset
        #5;
        w_rst_n = 1;
        r_rst_n = 1;

        // Write some data to the FIFO
        @(posedge w_clk);
        w_en = 1;
        w_data = 8'hA1;
        @(posedge w_clk);
        w_data = 8'hB2;
        @(posedge w_clk);
        w_data = 8'hC3;
        @(posedge w_clk);
        w_data = 8'hD4;
        @(posedge w_clk);
        w_en = 0;

        // Wait for a few clock cycles
        #50;

        // Read the data back from the FIFO
        @(posedge r_clk);
        r_en = 1;
        @(posedge r_clk);
        r_en = 1;
        @(posedge r_clk);
        r_en = 1;
        @(posedge r_clk);
        r_en = 1;
        @(posedge r_clk);
        r_en = 0;

        // Wait for a few clock cycles
        #50;

        // Finish the simulation
        $stop;
    end

    // Monitor the outputs
    initial begin
        $monitor("Time: %0t | w_data: %h | r_data: %h | full: %b | empty: %b", 
                 $time, w_data, r_data, full, empty);
    end

endmodule
