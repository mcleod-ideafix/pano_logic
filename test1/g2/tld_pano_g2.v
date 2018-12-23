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

module tld_pano_g2 (
  input wire SYSCLK,
  input wire PANO_BUTTON,  // nivel bajo al pulsarlo
  output wire LED_RED,
  output wire LED_GREEN,
  output wire LED_BLUE,
  output wire GMII_RST_N  // reset de la Marvell a nivel bajo
  );
  
  assign GMII_RST_N = ~PANO_BUTTON;  
  // con el boton pulsado, se desactiva el reset de la Marvell y
  // el reloj que "ve" la FPGA pasa de 25 a 125 MHz
  // Con el boton soltado, la Marvell está reseteada y su mux
  // interno ruta el reloj de 25 MHz en lugar del de 125 MHz
  
  rgb_leds_pwm las_lucecitas (
    .clk(SYSCLK),  // 25 MHz
    .red(LED_RED),
    .green(LED_GREEN),
    .blue(LED_BLUE)
  );
endmodule
