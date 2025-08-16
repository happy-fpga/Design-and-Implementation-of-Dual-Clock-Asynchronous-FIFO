 //DATA_SIZE and ADDR_SIZE can be used to define memory of the FIFO

module FIFO #(parameter DATA_SIZE = 8 , parameter ADDR_SIZE = 6) 
(   
    //Write operations
	input w_en, w_clk, w_rst_n,     
    input [DATA_SIZE-1:0] w_data,
    
    //Read operations
    input r_en, r_clk, r_rst_n,        
    output [DATA_SIZE-1:0] r_data,
	
    output full,
	output empty
	
    );
	 
wire [ADDR_SIZE-1:0] w_addr, r_addr;
wire [ADDR_SIZE:0] w_ptr, r_ptr;
reg  [ADDR_SIZE:0] w_ptr_1, r_ptr_1;
reg [ADDR_SIZE:0] r_ptr_sync, w_ptr_sync;

//Defining memory
reg [DATA_SIZE-1:0] mem [0:1<<ADDR_SIZE-1];

//Read operation
assign r_data = mem[r_addr];

//Write operation
always @(posedge w_clk)
if (w_en && !full) mem[w_addr] <= w_data;

//Read operation will give the Empty flag
read_pointer #(.ADDR_SIZE(4)) 
    read_pointer_inst(  
            
            .w_ptr(w_ptr_sync),
	        .r_en(r_en), 
            .r_clk(r_clk),
            .r_rst_n(r_rst_n),
            .empty(empty),
	        .r_addr(r_addr),
	        .r_ptr(r_ptr)
);


 always@(posedge r_clk or negedge r_rst_n) begin

    if (!r_rst_n) begin
        r_ptr_1     <= 0;
        r_ptr_sync  <= 0;
    end 
    else begin
        r_ptr_1     <= r_ptr;
        r_ptr_sync  <= r_ptr_1;
    end

    end


//Write operation will give the Full flag
write_pointer #(.ADDR_SIZE(4)) write_pointer_inst
(
    .full(full),
    .w_addr(w_addr),
    .w_ptr(w_ptr),
    .r_ptr(r_ptr_sync),
    .w_en(w_en),
    .wclk(w_clk),
    .w_rst_n(w_rst_n)
);


always@(posedge w_clk or negedge w_rst_n) begin

    if (!w_rst_n) begin
        w_ptr_1     <= 0;
        w_ptr_sync  <= 0;
    end 
    else begin
        w_ptr_1     <= w_ptr;
        w_ptr_sync  <= w_ptr_1;
    end
end

endmodule
