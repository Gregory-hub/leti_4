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

module svo_tcard #( `SVO_DEFAULT_PARAMS )
(
	input clk, resetn,

	// output stream
	//   tuser[0] ... start of frame
	output reg out_axis_tvalid,
	input out_axis_tready,
	output reg [SVO_BITS_PER_PIXEL-1:0] out_axis_tdata,
	output reg [0:0] out_axis_tuser
);
	`SVO_DECLS
        
	function integer best_y_params;
		input integer n, which;
		integer best_y_blk;
		integer best_y_off;
		integer best_y_gap;
		begin
			best_y_blk = 0;
			best_y_gap = 0;
			best_y_off = 0;

			if (SVO_VER_PIXELS == 480) begin
				best_y_blk = 3;
				best_y_gap = 1;
				best_y_off = 1;
			end

			if (SVO_VER_PIXELS == 600) begin
				best_y_blk = 3;
				best_y_gap = 2;
				best_y_off = 2;
			end

			if (SVO_VER_PIXELS == 768) begin
				best_y_blk = 4;
				best_y_gap = 3;
				best_y_off = 2;
			end

			if (SVO_VER_PIXELS == 1080) begin
				best_y_blk = 6;
				best_y_gap = 2;
				best_y_off = 5;
			end

			if (which == 1) best_y_params = best_y_blk;
			if (which == 2) best_y_params = best_y_gap;
			if (which == 3) best_y_params = best_y_off;
		end
	endfunction

	reg [`SVO_XYBITS-1:0] hcursor;
	reg [`SVO_XYBITS-1:0] vcursor;

	reg [SVO_BITS_PER_RED-1:0] r;
	reg [SVO_BITS_PER_GREEN-1:0] g;
	reg [SVO_BITS_PER_BLUE-1:0] b;
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
    reg [7:0] r_;
    reg [7:0] g_;
    reg [7:0] b_;
    reg [7:0] color_intensity = 8'd255;   

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
		else
		if (!out_axis_tvalid || out_axis_tready)
		begin        
            case (dout)
                0: begin
                       r = r_;
                       b = b_;
                       g = g_;
                   end
                default: begin r=0; g=0; b = dout * 50; end 
            endcase

            
			out_axis_tvalid <= 1;
			out_axis_tdata <= {b, g, r};
				
			out_axis_tuser[0] <= !hcursor && !vcursor;

			if (hcursor == SVO_HOR_PIXELS-1)
			begin
				hcursor <= 0;
				if (vcursor == SVO_VER_PIXELS-1) begin
                    vcursor <= 0;
                    
                    case (state)
                        RED: begin
                            // Уменьшаем красный, увеличиваем зелёный
                            if (color_intensity > 0) begin
                                color_intensity <= color_intensity - COLOR_CHANGE_SPEED;
                                r_ <= color_intensity;
                                g_ <= 8'd255 - color_intensity;
                                b_ <= 8'd0;
                            end else begin
                                state <= GREEN;
                                color_intensity <= 8'd255;
                            end
                        end

                        GREEN: begin
                            // Уменьшаем зелёный, увеличиваем синий
                            if (color_intensity > 0) begin
                                color_intensity <= color_intensity - COLOR_CHANGE_SPEED;
                                r_ <= 8'd0;
                                g_ <= color_intensity;
                                b_ <= 8'd255 - color_intensity;
                            end else begin
                                state <= BLUE;
                                color_intensity <= 8'd255;
                            end
                        end

                        BLUE: begin
                            // Уменьшаем синий, увеличиваем красный
                            if (color_intensity > 0) begin
                                color_intensity <= color_intensity - COLOR_CHANGE_SPEED;
                                r_ <= 8'd255 - color_intensity;
                                g_ <= 8'd0;
                                b_ <= color_intensity;
                            end else begin
                                state <= RED;
                                color_intensity <= 8'd255;
                            end
                        end
                    endcase
                    end
				else vcursor <= vcursor + 1;
			end
			else hcursor <= hcursor + 1;
		end
	end
endmodule
