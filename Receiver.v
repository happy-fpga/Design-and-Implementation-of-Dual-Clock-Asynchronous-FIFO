module Receiver();







     // FSM for Receiver
    parameter s0 = 1'd0;
    parameter s1 = 1'd1;

    reg state, next_state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= s0;
            ack   <= 0;
            outp_data <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        ack = 0;
        case (state)
            s0: begin
                if (rx_data) begin
                    outp_data = rx_data;
                    next_state = s1;
                end
            end
            s1: begin
                ack = 1;
                next_state = s0;
            end
        endcase
    end


endmodule