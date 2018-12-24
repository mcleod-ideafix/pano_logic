/*
 * Simple VGA test for Pano Logic
 * Copyright (c) 2018 Miguel Angel Rodriguez Jodar.
 * 
 * This program is free software: you can redistribute it and/or modify  
 * it under the terms of the GNU General Public License as published by  
 * the Free Software Foundation, version 3.
 *
 * This program is distributed in the hope that it will be useful, but 
 * WITHOUT ANY WARRANTY; without even the implied warranty of 
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License 
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

`timescale 1ns / 1ns
`default_nettype none

module fondo (
  input wire [10:0] hc,
  input wire [10:0] vc,
  input wire display_enable,
  output reg [7:0] r,
  output reg [7:0] g,
  output reg [7:0] b
  );

  always @* begin
    if (display_enable == 1'b1) begin
      r = hc[7:0] ^ vc[7:0];
      g = hc[7:0] ^ vc[7:0];
      b = {hc[7], vc[7], 6'b000000};
    end
    else begin
      r = 8'h00;
      g = 8'h00;
      b = 8'h00;
    end
  end
endmodule

`default_nettype wire