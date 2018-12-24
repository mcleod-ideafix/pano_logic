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

module sprite (
  input wire clk,
  input wire [10:0] hc,   // posicion X de pantalla
  input wire [10:0] vc,   // posicion Y de pantalla
  input wire [10:0] posx, // posicion X inicial del sprite
  input wire [10:0] posy, // posicion Y inicial del sprite
  input wire [7:0] rin,   // color de pantalla
  input wire [7:0] gin,   // proveniente del
  input wire [7:0] bin,   // modulo anterior (el fondo, por ejemplo)
  output reg [7:0] rout,  // color de pantalla
  output reg [7:0] gout,  // actualizado
  output reg [7:0] bout   // segun haya que pintar o no el sprite
  );

  localparam
    TRANSPARENTE = 24'h00FF00,  // en nuestro sprite el verde es "transparente"
    TAM          = 11'd64;      // tamaño en pixeles tanto horizontal como vertical, del sprite

  reg [23:0] spr[0:255];   // memoria que guarda el sprite (16x16 posiciones de 24 bits cada posicion)
  initial begin
    $readmemh ("datos_sprite.hex", spr);  // inicializamos esa memoria desde un fichero con datos hexadecimales
  end
  
  wire [5:0] spr_x = hc - posx; // posicion X dentro de la matriz del sprite, en función de la posicion X actual de pantalla y posicion inicial X del sprite
  wire [5:0] spr_y = vc - posy; // posicion Y dentro de la matriz del sprite, en función de la posicion Y actual de pantalla y posicion inicial Y del sprite
  
  reg [23:0] color;  // color del pixel actual del sprite
  
  always @(posedge clk)
    color <= spr[{spr_y[5:2],spr_x[5:2]}];  // leemos el color del pixel y lo guardamos (la posición del pixel podría ser completamente erronea aquí)
    
  always @* begin
    if (hc >= posx && hc < (posx + TAM) && vc >= posy && vc < (posy + TAM) && color != TRANSPARENTE) begin  // si la posicion actual de pantalla está dentro de los márgenes del sprite, y el color leido del sprite no es el transparente....
      rout = color[23:16];  // en ese caso, el color de salida
      gout = color[15:8];   // es el color del pixel del sprite
      bout = color[7:0];    // que hemos leido
    end
    else begin
      rout = rin;           // si no toca pintar el sprite
      gout = gin;           // o bien el color que hemos leido es el transparente
      bout = bin;           // entonces pasamos a la salida el color que nos dieron a la entrada
    end  
  end
endmodule

`default_nettype wire