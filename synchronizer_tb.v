module synchronizer_tb;

// Testbench signals
reg clk;
reg rst;
reg ack;
//wire rsp;
wire ack_lvl_pulse;
wire ack_double_FF;

// Instantiate the synchronizer module
synchronizer uut (
    .clk(clk),
    .rst(rst),
    .ack(ack),
//    .rsp(rsp),
    .ack_lvl_pulse(ack_lvl_pulse),
    .ack_double_FF(ack_double_FF)
);

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk; // 10ns clock period
end

// Test stimulus
initial begin
    // Initialize signals
    rst = 1;
    ack = 0;

    // Release reset after some time
    #20 rst = 0;

    // Apply test vectors
    #10 ack = 1;
    #20 ack = 0;
    #30 ack = 1;
    #10 ack = 0;
    #40 ack = 1;
    #10 ack = 0;
    #50 $finish; // End the simulation
end

// Monitor signals
initial begin
    $monitor("Time = %0t, clk = %b, rst = %b, ack = %b, ack_lvl_pulse = %b, ack_double_FF = %b", 
             $time, clk, rst, ack, ack_lvl_pulse, ack_double_FF);
end

endmodule
