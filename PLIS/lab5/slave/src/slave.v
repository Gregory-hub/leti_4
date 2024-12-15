module slave(
    input clk,
    input sclk,
    input mosi,
    input ss,
    output reg [3:0] led_output
);
localparam DATA_SIZE = 4;
reg [DATA_SIZE-1:0] data;
reg [1:0] bit_counter;

initial begin
    bit_counter <= 0;
    data <= 'b1111;
end

always @(posedge clk) begin
    if (ss == 0 && sclk == 0) begin
        data[bit_counter] <= mosi;
        if (bit_counter == DATA_SIZE - 1) begin
            bit_counter <= 0;
        end
        else begin
            bit_counter <= bit_counter + 1'b1;
        end
    end
    
    led_output <= data;
end

endmodule
