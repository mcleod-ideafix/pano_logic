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

`timescale 1ns / 1ps
`default_nettype none

module tld_pano_g1 (
  input wire osc_clk,  // reloj de 100 MHz de la Pano Logic G1
  output wire vo_clk,
  output wire [7:0] vo_r,
  output wire [7:0] vo_g,
  output wire [7:0] vo_b,
  output wire vo_hsync,
  output wire vo_vsync,
  output wire vo_blank_
  );

  assign vo_blank_ = 1'b1;  // el blanking lo gestionaremos desde el propio generador de video

  // Metodo chusquero para generar una señal de reloj de 25 MHz a partir del reloj de 100 MHz
  // y además sacarlo por un pin externo para el DAC de video
  reg [1:0] clkdiv = 2'b00;
  always @(posedge osc_clk)
    clkdiv <= clkdiv + 2'd1;  
  assign vo_clk = clkdiv[1];  // vo_clk = osc_clk / 4 = 25 MHz  

  wire clkvideo;
  BUFG bclkvideo (   // convertimos una pobre y desolada señal en todo un reloj
    .I(clkdiv[1]),
    .O(clkvideo)
  );

  fantasma_rebotando efecto_molon (
    .clk(clkvideo),
    .r(vo_r),
    .g(vo_g),
    .b(vo_b),
    .hsync(vo_hsync),
    .vsync(vo_vsync)
  );
endmodule
