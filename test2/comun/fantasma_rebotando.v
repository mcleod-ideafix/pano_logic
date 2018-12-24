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

module fantasma_rebotando (
  input wire clk,     // 25 MHz (a no ser que uses otro ModeLine (ver videosyncs.v)
  output wire [7:0] r,
  output wire [7:0] g,
  output wire [7:0] b,
  output wire hsync,
  output wire vsync
  );

  wire [10:0] hc, vc;     // posicion actual X,Y de la pantalla
  wire display_enable;    // la posicion X,Y anterior es válida
  wire [7:0] rfondo, gfondo, bfondo;  // color de fondo
  wire [10:0] posx, posy; // posicion X,Y de la esquina superior izquierda del sprite

  videosyncs sincronismos (
    .clk(clk),
    .hs(hsync),   // se generan los dos
    .vs(vsync),   // pulsos de sincronismo
    .hc(hc),  // este módulo también genera
    .vc(vc),  // los valores X,Y de pantalla
    .display_enable(display_enable)  // los valores X,Y anteriores son válidos
    );

  fondo los_cuadraditos (
    .hc(hc),
    .vc(vc),
    .display_enable(display_enable),
    .r(rfondo),  // color de fondo
    .g(gfondo),  // generado por
    .b(bfondo)   // este módulo
    );
    
  sprite el_fantasma (
    .clk(clk),
    .hc(hc),
    .vc(vc),
    .posx(posx),
    .posy(posy),
    .rin(rfondo),  // si no hay que pintar sprite 
    .gin(gfondo),  // entonces se pintara el color
    .bin(bfondo),  // que se ponga como entrada
    .rout(r),  // color de salida, que puede ser
    .gout(g),  // o bien el color de un pixel del sprite
    .bout(b)   // o bien el color de fondo, que proviene de arriba
    );
    
  update actualiza_pos_fantasma (
    .clk(clk),
    .vsync(vsync),  // señal que usaremos para saber cuándo toca actualizar la posición
    .posx(posx),    // posicion X de la esquina superior izquierda del sprite
    .posy(posy)     // posicion Y de la esquina superior izquierda del sprite
    );    

endmodule

`default_nettype wire