module synchronizer #(parameter ADDR_SIZE = 4) (

    input clk,
    input rst,  //Reset

    input ack,  // Output from a different clock domain
    
//    output reg rsp,
    // output reg [ADDR_SIZE : 0] ack_lvl_pulse,
    output reg [ADDR_SIZE : 0] ack_double_FF

);


//Double synchronizer with Level to Pulse 
reg ack_1, ack_2;
// wire ack_sync;

always @(posedge clk) begin
    if (rst) begin
        // ack_lvl_pulse <= 0;
        ack_double_FF <= 0;
//        rsp           <= 0;

    end
    else begin
        ack_1   <= ack;
        ack_2   <= ack_1;
        // ack_inp <= ack_2;       // Synchronized Acknowledgement input signal
        // ack_lvl_pulse <= (~ack_inp & ack_2);
        ack_double_FF <= ack_2;
    end
end

// assign ack_lvl_pulse = (~ack_inp & ack_2);
// assign ack_double_FF = ack_2;



endmodule