module top #(parameter DATA_SIZE = 8, parameter ADDR_SIZE = 4) (
    input w_clk, r_clk, w_rst_n, r_rst_n,
    input w_en, r_en,
    output [DATA_SIZE-1:0] r_data
);

    wire full, empty;
    wire [DATA_SIZE-1:0] fifo_r_data;
    reg [DATA_SIZE-1:0] w_data;
    integer i, j;
    
    // Instantiate FIFO
    FIFO #(.DATA_SIZE(DATA_SIZE), .ADDR_SIZE(ADDR_SIZE)) fifo_inst (
        .w_en(w_en),
        .w_clk(w_clk),
        .w_rst_n(w_rst_n),
        .w_data(w_data),
        .r_en(r_en),
        .r_clk(r_clk),
        .r_rst_n(r_rst_n),
        .r_data(fifo_r_data),
        .full(full),
        .empty(empty)
    );

    // RAM for sending data
    reg [DATA_SIZE-1:0] send_ram [0:DATA_SIZE-1];
    // RAM for receiving data
    reg [DATA_SIZE-1:0] recv_ram [0:DATA_SIZE-1];
    
    // Initialize sending RAM with some data
    initial begin
        
        for (i = 0; i < (DATA_SIZE); i = i + 1) begin
            send_ram[i] = i; // Example initialization
        end
    end
    
    // Initialize receiving RAM with 0s
    initial begin
      
        for (j = 0; j < (DATA_SIZE); j = j + 1) begin
            recv_ram[j] = 0;
        end
    end
    
    // Write data to FIFO from sending RAM
    reg [DATA_SIZE-1:0] write_pointer;
    always @(posedge w_clk or negedge w_rst_n) begin
        if (!w_rst_n)
            write_pointer <= 0;
        else if (w_en && !full) begin
            w_data <= send_ram[write_pointer];
            write_pointer <= write_pointer + 1'b1;
        end
    end

    // Read data from FIFO to receiving RAM
    reg [DATA_SIZE-1:0] read_pointer;
    always @(posedge r_clk or negedge r_rst_n) begin
        if (!r_rst_n)
            read_pointer <= 0;
        else if (r_en && !empty) begin
            recv_ram[read_pointer] <= fifo_r_data;
            read_pointer <= read_pointer + 1'b1;
        end
    end

    assign r_data = fifo_r_data;

    

endmodule
