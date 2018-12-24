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

module tld_pano_g1 (
  input wire osc_clk,
  output wire led_red,
  output wire led_green,
  output wire led_blue
  );
  
  wire red, green, blue;
  assign led_red = ~red;          // estos leds son
  assign led_green = ~green;      // activos a nivel
  assign led_blue = ~blue;        // bajo
  
  rgb_leds_pwm las_lucecitas (
    .clk(osc_clk),  // 100 MHz
    .red(red),       
    .green(green),   
    .blue(blue)      
  );
endmodule
