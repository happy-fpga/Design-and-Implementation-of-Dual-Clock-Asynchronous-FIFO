module gray_to_bin #(parameter WIDTH = 4) (
    input [WIDTH-1:0] gray,
    output reg [WIDTH-1:0] bin
);
    integer i;
    
    always @* begin
        bin[WIDTH-1] = gray[WIDTH-1]; // MSB remains the same
        for (i = WIDTH-2; i >= 0; i = i - 1) begin
            bin[i] = bin[i+1] ^ gray[i];
        end
    end
endmodule


module bin_to_gray #(parameter WIDTH = 4) (
    input [WIDTH-1:0] bin,
    output [WIDTH-1:0] gray
);
    assign gray = (bin >> 1) ^ bin;
endmodule
