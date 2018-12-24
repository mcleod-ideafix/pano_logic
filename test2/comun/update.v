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

module update (
  input wire clk,
  input wire vsync,
  output reg [10:0] posx,
  output reg [10:0] posy
  );
  
  parameter
    XMAX = 11'd640,
    YMAX = 11'd480,
    TAM  = 11'd64;
    
  initial begin
    posx = 11'd320;  // incialmente, centro de la pantalla
    posy = 11'd240;  // para una pantalla de 640x480, claro.
  end
  
  reg vsync_prev = 1'b0;
  reg dx = 1'b0;  // 0: mover a la derecha. 1: mover a la izquierda
  reg dy = 1'b0;  // 0: mover hacia abajo. 1: mover hacia arriba
  
  always @(posedge clk)
    vsync_prev <= vsync;    
  wire actualizar_ahora = vsync_prev & ~vsync;  // momento en el que vsync pasa de 1 a 0 (flanco de bajada)
  
  always @(posedge clk) begin
    if (actualizar_ahora == 1'b1) begin
      if (posx == XMAX-TAM && dx == 1'b0 || posx == 11'd1 && dx == 1'b1)  // si llegamos al borde izquierdo o derecho, cambiar sentido de movimiento horizontal
        dx <= ~dx;
      if (posy == YMAX-TAM && dy == 1'b0 || posy == 11'd1 && dy == 1'b1)  // si llegamos al borde inferior o superior, cambiar sentido de movimiento vertical
        dy <= ~dy;
      posx <= posx + {{10{dx}}, 1'b1};  // si dx=0, esto hace que se sume 00000000001 a posx. Si dx=1, esto hace que se sume 11111111111 a posx.
      posy <= posy + {{10{dy}}, 1'b1};  // lo mismo, pero con dy y posy
    end
  end
endmodule

`default_nettype wire