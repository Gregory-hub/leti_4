`timescale 1ns / 1ns

module slave_tb();

reg clk;
reg sclk;
reg mosi;
reg ss;
wire [3:0] led_output;


slave r(
    .clk(clk), 
    .sclk(sclk), 
    .mosi(mosi),
    .ss(ss),
    .led_output(led_output)
);

initial
begin
	clk = 'b0;
    sclk = 'b1;
    ss = 'b1;
    mosi = 'b0;
    
    #100 ss = 'b0;
    
    #10 sclk = 'b0;
    #0 mosi = 'b0;
    #10 sclk = 'b1;

    #10 sclk = 'b0;
    #0 mosi = 'b0;
    #10 sclk = 'b1;

    #10 sclk = 'b0;
    #0 mosi = 'b0;
    #10 sclk = 'b1;

    #10 sclk = 'b0;
    #0 mosi = 'b1;
    #10 sclk = 'b1;
end

initial forever #(5) clk = !clk;

initial #1000 $finish;

initial
begin
  $dumpfile("./slave_out.vcd");
  $dumpvars(0, slave_tb);
end

endmodule