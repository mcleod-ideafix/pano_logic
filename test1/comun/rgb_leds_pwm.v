/* 
 * LED PWM test for Pano Logic
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

module rgb_leds_pwm (
  input wire clk,  // 25 ó 125 MHz
  output wire red,
  output wire green,
  output wire blue
  );
  
  reg [7:0] vred = 8'd0, vgreen = 8'd0, vblue = 8'd0;
  
  pwm pwm_red (
    .clk(clk),
    .d(vred),
    .o(red)
  );
  
  pwm pwm_green (
    .clk(clk),
    .d(vgreen),
    .o(green)
  );

  pwm pwm_blue (
    .clk(clk),
    .d(vblue),
    .o(blue)
  );
  
  reg [17:0] clkdiv = 18'd0;
  // cuenta 262144 ciclos de reloj. Hace que la FSM se active cada 262144/25000 milisegundos = 10,4 ms
  
  localparam
    NEGRO    = 4'd0,
    AZUL     = 4'd1,
    ROJO     = 4'd2,
    MAGENTA  = 4'd3,
    VERDE    = 4'd4,
    CYAN     = 4'd5,
    AMARILLO = 4'd6,
    BLANCO   = 4'd7,
    PAUSA    = 4'd8;    
  reg [3:0] estado = AZUL;
  reg [3:0] retorno_pausa = NEGRO;
  reg [7:0] cntpausa = 8'd0;
  
  always @(posedge clk) begin
    clkdiv <= clkdiv + 18'd1;
    if (clkdiv == 18'd0) begin
      case (estado)
        AZUL:
          begin
            retorno_pausa <= ROJO;
            if (vblue != 8'd255)
              vblue <= vblue + 8'd3;
            else
              estado <= PAUSA;
          end
        ROJO:
          begin
            retorno_pausa <= MAGENTA;
            if (vred != 8'd255) begin
              vred <= vred + 8'd3;
              vblue <= vblue + 8'hFD;
            end
            else
              estado <= PAUSA;
          end
        MAGENTA:
          begin
            retorno_pausa <= VERDE;
            if (vblue != 8'd255)
              vblue <= vblue + 8'd3;
            else
              estado <= PAUSA;
          end
        VERDE:
          begin
            retorno_pausa <= CYAN;
            if (vgreen != 8'd255) begin
              vgreen <= vgreen + 8'd3;
              vblue <= vblue + 8'hFD;
              vred <= vred + 8'hFD;
            end
            else
              estado <= PAUSA;
          end
        CYAN:
          begin
            retorno_pausa <= AMARILLO;
            if (vblue != 8'd255)
              vblue <= vblue + 8'd3;
            else
              estado <= PAUSA;
          end
        AMARILLO:
          begin
            retorno_pausa <= BLANCO;
            if (vred != 8'd255) begin
              vred <= vred + 8'd3;
              vblue <= vblue + 8'hFD;
            end
            else
              estado <= PAUSA;
          end
        BLANCO:
          begin
            retorno_pausa <= NEGRO;
            if (vblue != 8'd255)
              vblue <= vblue + 8'd3;
            else
              estado <= PAUSA;
          end
        NEGRO:
          begin
            retorno_pausa <= AZUL;
            if (vgreen != 8'd0) begin
              vgreen <= vgreen + 8'hFD;
              vblue <= vblue + 8'hFD;
              vred <= vred + 8'hFD;
            end
            else
              estado <= PAUSA;
          end
        PAUSA:
          begin
            cntpausa <= cntpausa + 8'd1;
            if (cntpausa == 8'd255)
              estado <= retorno_pausa;
          end
      endcase    
    end
  end
endmodule

module pwm (
  input wire clk,
  input wire [7:0] d,
  output reg o
  );
  
  reg [7:0] cnt = 8'd0;
  initial o = 1'b1;
  always @(posedge clk) begin
    cnt <= cnt + 8'd1;
    if (cnt == 8'd255)
      if (d == 8'd0)
        o <= 1'b0;
      else
        o <= 1'b1;
    else if (cnt >= d)
      o <= 1'b0;
  end
endmodule
