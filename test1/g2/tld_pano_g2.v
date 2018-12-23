`timescale 1ns / 1ps
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:41:32 12/23/2018 
// Design Name: 
// Module Name:    tld_pano_g2 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

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
