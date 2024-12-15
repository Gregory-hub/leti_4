module master(
    input clk,
    input [3:0] data_buttons,
    input transmit_button,
    output reg [3:0] led_output,
    output reg sclk,
    output reg mosi,
    output reg ss
);
localparam DATA_SIZE = 4;
wire [DATA_SIZE-1:0] data = data_buttons;
reg transmit_button_prev;
reg [1:0] bit_counter;

initial begin
    transmit_button_prev <= 1;
    bit_counter <= 0;
    mosi <= 0;
    sclk <= 1;
    ss <= 1;
end

always @(posedge clk) begin
    if (!transmit_button && transmit_button_prev) begin
        ss <= 'b0;
        transmit_button_prev <= 'b0;
    end
    
    if (transmit_button && !transmit_button_prev) begin
        transmit_button_prev <= 'b1;
    end
    
    if (ss == 0) begin
        if (sclk == 0) begin
            if (bit_counter == DATA_SIZE - 1) begin
                ss <= 1;
                bit_counter <= 0;
            end
            else begin
                bit_counter <= bit_counter + 1'b1;
            end
        end
        else begin
            mosi <= data[bit_counter];
        end

        sclk <= ~sclk;
    end
    
    led_output <= data;
end

endmodule
