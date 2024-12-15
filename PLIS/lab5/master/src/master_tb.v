`timescale 1ns / 1ns

module master_tb();

reg clk;
reg transmit_button;
reg [3:0] data_buttons;
wire [3:0] led_output;
wire sclk;
wire mosi;
wire ss;


master r(
    .clk(clk), 
    .data_buttons(data_buttons),
    .transmit_button(transmit_button),
    .led_output(led_output),
    .sclk(sclk), 
    .mosi(mosi),
    .ss(ss)
);

initial
begin
	clk = 'b0;
    transmit_button = 'b1;
    data_buttons = 4'b1111;
    
	#100 data_buttons[0] = 'b0;
	#100 data_buttons[1] = 'b1;
	#100 data_buttons[2] = 'b1;
	#100 data_buttons[3] = 'b0;

    #100 transmit_button = 'b0;
    #100 transmit_button = 'b1;
end

initial forever #(5) clk = !clk;

initial #1000 $finish;

initial
begin
  $dumpfile("./master_out.vcd");
  $dumpvars(0, master_tb);
end

endmodule