/*
 *  SVO - Simple Video Out FPGA Core
 *
 *  Copyright (C) 2014  Clifford Wolf <clifford@clifford.at>
 *  
 *  Permission to use, copy, modify, and/or distribute this software for any
 *  purpose with or without fee is hereby granted, provided that the above
 *  copyright notice and this permission notice appear in all copies.
 *  
 *  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 *  WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 *  ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 *  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 *  ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 *  OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 */

`timescale 1ns / 1ps
`include "svo_defines.vh"

module svo_tcard #( `SVO_DEFAULT_PARAMS ) (
	input clk, resetn,

	// output stream
	//   tuser[0] ... start of frame
	output reg out_axis_tvalid,
	input out_axis_tready,
	output reg [SVO_BITS_PER_PIXEL-1:0] out_axis_tdata,
	output reg [0:0] out_axis_tuser
);
	`SVO_DECLS

	reg [`SVO_XYBITS-1:0] hcursor;
	reg [`SVO_XYBITS-1:0] vcursor;

    wire [17:0] ad = (hcursor < 160 || hcursor >= 480) ? 0 : vcursor * 320 + hcursor - 160;
    wire [1:0] dout;
    
    Gowin_pROM mem
    (
    .dout(dout), //output [1:0] dout
    .clk(clk), //input clk
    .oce(1'b1), //input oce
    .ce(1'b1), //input ce
    .reset(1'b0), //input reset
    .ad(ad) //input [17:0] ad
    );
    
	reg [SVO_BITS_PER_RED-1:0] r;
	reg [SVO_BITS_PER_GREEN-1:0] g;
	reg [SVO_BITS_PER_BLUE-1:0] b;
    
    reg [8:0] H = 'b0;
    reg [7:0] S = 'd128;
    reg [7:0] V = 'd128;
    reg [7:0] color_intensity = 8'd255;

    reg [2:0] h;
    reg [7:0] v_min;
    reg [7:0] v_inc;
    reg [7:0] v_dec;
    reg [7:0] a;
    
    localparam RED = 2'b00;
    localparam GREEN = 2'b01;
    localparam BLUE = 2'b10;
    localparam COLOR_CHANGE_SPEED = 1;
    
    reg [1:0] state = RED;
    
	always @(posedge clk)
	begin
		if (!resetn)
		begin
			hcursor <= 0;
			vcursor <= 0;

			out_axis_tvalid <= 0;
			out_axis_tdata <= 0;
			out_axis_tuser <= 0;
		end
		else if (!out_axis_tvalid || out_axis_tready)
		begin
            case (dout)
                0: begin
                    h = (H / 'd60) % 'd6;
                    v_min = ('d256 - S) * V / 'd256;
                    a = (V - v_min) * H % 60 / 60;
                    v_inc = v_min + a;
                    v_dec = V - a;
                    case (h)
                        0: begin
                            r = V;
                            g = v_inc;
                            b = v_min;
                        end
                        1: begin
                            r = v_dec;
                            g = V;
                            b = v_min;
                        end
                        2: begin
                            r = v_min;
                            g = V;
                            b = v_inc;
                        end
                        3: begin
                            r = v_min;
                            g = v_dec;
                            b = V;
                        end
                        4: begin
                            r = v_inc;
                            g = v_min;
                            b = V;
                        end
                        5: begin
                            r = V;
                            g = v_min;
                            b = v_dec;
                        end
                    endcase
                end
                default: begin r=0; g=0; b = dout * 50; end 
            endcase
            
			out_axis_tvalid <= 1;
			out_axis_tdata <= {b, g, r};
            
			out_axis_tuser <= !hcursor && !vcursor;

            H <= (H == 360) ? 'b0 : H + COLOR_CHANGE_SPEED;

			if (hcursor == SVO_HOR_PIXELS-1)
			begin
				hcursor <= 0;
				if (vcursor == SVO_VER_PIXELS-1) begin
                    vcursor <= 0;
                end
				else vcursor <= vcursor + 1;
			end
			else hcursor <= hcursor + 1;
		end
	end
endmodule
