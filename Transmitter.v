module transmitter #(parameter integer data_bits = 32)

(
    input clk,
    input rst,


    //Signals for User module interface
    input [data_bits-1:0] data, //Input data to be sent 
    input valid, //Valid signal for the input data to be sent
    output ack_synced,

    //Signals for Receive module on different clock domain
    input ack_rx,
    output reg resp,
    output reg outp


);


// Instantiate the synchronizer module
synchronizer ack_synchronizer  (
    .clk(clk),
    .rst(rst),
    .ack(ack),
    .rsp(rsp),
    .ack_lvl_pulse(ack_lvl_pulse),
    .ack_double_FF(ack_double_FF)
);

//Alias for ack_lvl_pulse
wire ack_lvl_pulse;
assign ack_sync = ack_lvl_pulse;

//Alias for ack_double_FF
wire ack_double_FF;
assign ack_2 = ack_double_FF;

//FSM for Transmit module
    parameter s0 = 2'd0;
    parameter s1 = 2'd1;
    parameter s2 = 2'd2;

    reg [1:0] state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= s0;
            outp  <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        resp = 0;
        case (state)
            s0: begin
                if (inp_data) begin
                    next_state = s1;
                end
            end
            s1: begin
                outp = inp_data;
                next_state = s2;
            end
            s2: begin
                rsp = 1;
                if (ack_sync) begin
                    next_state = s0;
                end
            end
        endcase
    end



endmodule