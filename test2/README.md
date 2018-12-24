# test2. Simple VGA test
This is a simple VGA pattern test. It features a 640x480@60 Hz VGA output with a XOR-generated background and a (very famous) moving sprite bouncing around the screen.

tld_pano_g1.v can be used as a basis for any other VGA related design with the Pano G1, as it can generate a valid 25 MHz clock signal that can be used inside a design and at the same time outputs that clock signal to the VGA DAC. BLANK is held high so it is responsability of the VGA generator to shutdown R,G and B when in blanking period.
