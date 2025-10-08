module ColorInversion(pixel_in, colorinversed);
input[11:0] pixel_in;
output[11:0] colorinversed;

assign colorinversed = ~pixel_in;

endmodule