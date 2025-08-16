// It will give appropriate read pointer value, by also noticing the current write pointer

module read_pointer #(parameter ADDR_SIZE = 4)
(  
    input [ADDR_SIZE :0] w_ptr,
	input r_en, r_clk, r_rst_n,

    output reg empty,
	output [ADDR_SIZE-1:0] r_addr,
	output reg [ADDR_SIZE :0] r_ptr

);

reg [ADDR_SIZE:0] rbin;
wire [ADDR_SIZE:0] gray_next, bin_next;

assign bin_next = rbin + (~empty & r_en);    //upate readpointer only when Read is enabled and FIFO is not empty
bin_to_gray #(ADDR_SIZE+1) bin2gray (
    .bin(bin_next),
    .gray(gray_next)
); 

// Update binary counter and Gray code pointer
always @(posedge r_clk or negedge r_rst_n) begin
    if (!r_rst_n) begin
        rbin <= 0;
        r_ptr <= 0;
    end else begin
        rbin <= bin_next;
        r_ptr <= gray_next;
    end
end

// Memory read-address pointer (okay to use binary to address memory)
assign r_addr = rbin[ADDR_SIZE-1:0];

// FIFO empty when the next rptr == synchronized wptr or on reset
wire empty_temp;
assign empty_temp = (gray_next == w_ptr);

always @(posedge r_clk or negedge r_rst_n) begin
    if (!r_rst_n) begin
        empty <= 1'b1;
    end else begin
        empty <= empty_temp;
    end
end


endmodule