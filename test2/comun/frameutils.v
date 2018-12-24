`timescale 1ns / 1ns
`default_nettype none

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:55:08 08/25/2018 
// Design Name: 
// Module Name:    frameutils 
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

// Modulo frame grabber
module framegrabber (
  input wire clk,
	input wire [10:0] hc,
	input wire [10:0] vc,
	input wire [7:0] r,
	input wire [7:0] g,
	input wire [7:0] b,
	input wire hsync,
	input wire vsync
	);
	
	parameter HTOTAL = 800;
  parameter VTOTAL = 525;
  parameter HSYNCPOL = 0;  // 0 = polaridad negativa, 1 = polaridad positiva
  parameter VSYNCPOL = 0;  // 0 = polaridad negativa, 1 = polaridad positiva
  
  integer nframes;
	integer f;
   initial begin
	  f = $fopen ("fotograma.rgb","wb");
    nframes = 0;
	end
	
	always @(posedge clk) begin
    if (vc == VTOTAL-1 && hc == HTOTAL-1)
      nframes <= nframes + 1;
	  if (nframes > 0) begin
      if (hsync == HSYNCPOL || vsync == VSYNCPOL)
        $fwrite (f, "%c%c%c", 64, 64, 64);  // SYNC de color gris
	    else begin
			  $fwrite (f, "%c%c%c", r, g, b);
        if (vc == VTOTAL-1 && hc == HTOTAL-1) begin          
          $fclose (f);
          $display ("Fotograma volcado. Fin de la simulacion");
		      $finish;
        end 
      end
	  end
	end  
endmodule

module animgrabber (
  input wire clk,
	input wire [10:0] hc,
	input wire [10:0] vc,
	input wire [7:0] r,
	input wire [7:0] g,
	input wire [7:0] b,
	input wire hsync,
	input wire vsync
	);

	parameter HTOTAL = 800;
  parameter VTOTAL = 525;
  parameter HSYNCPOL = 0;  // 0 = polaridad negativa, 1 = polaridad positiva
  parameter VSYNCPOL = 0;  // 0 = polaridad negativa, 1 = polaridad positiva
  parameter MAXFRAMES = 60;

  integer nframes;
	integer f, res;
   initial begin
    $timeformat(-3, 2, " ms", 10);   // mostrar tiempo escalado a ms (10^-3), con 2 decimales de precision, usando " ms" como sufijo, y ocupando todo 10 caracteres
	  f = $fopen ("anim.raw","wb");
    nframes = 0;
	end

//   reg [23:0] framebuffer[0:HTOTAL*VTOTAL-1];
//   integer i;
// 	always @(posedge clk) begin
//     if (vc == VTOTAL-1 && hc == HTOTAL-1)
//       nframes = nframes + 1;
//     if (hsync == HSYNCPOL || vsync == VSYNCPOL)
//       framebuffer[vc*HTOTAL+hc] = 24'h404040;
// 	  else begin
// 	    framebuffer[vc*HTOTAL+hc] = {r,g,b};
//       if (vc == VTOTAL-1 && hc == HTOTAL-1) begin
//         for (i=0;i<HTOTAL*VTOTAL;i=i+1) begin
//           res = $fputc(framebuffer[i][23:16], f);
//           res = $fputc(framebuffer[i][15:8], f);
//           res = $fputc(framebuffer[i][7:0], f);
//         end
//         $display ("%t : Fotograma %4d", $realtime, nframes);
//         if (nframes == MAXFRAMES) begin
//           $fclose (f);
//           $finish;
//         end
//       end
//     end
// 	end

	always @(posedge clk) begin
    if (vc == VTOTAL-1 && hc == HTOTAL-1)
      nframes <= nframes + 1;
    if (nframes > 0) begin
      if (hsync == HSYNCPOL || vsync == VSYNCPOL) begin
        res = $fputc(8'h40, f);
        res = $fputc(8'h40, f);  // SYNC de color gris oscurillo
        res = $fputc(8'h40, f);
      end
      else begin
        res = $fputc(r, f);
        res = $fputc(g, f);
        res = $fputc(b, f);
        if (vc == VTOTAL-1 && hc == HTOTAL-1) begin
          $display ("%t : Fotograma %4d", $realtime, nframes);
          if (nframes == MAXFRAMES) begin
            $fclose (f);
            $finish;
          end
        end
      end
    end
	end

endmodule

`default_nettype wire