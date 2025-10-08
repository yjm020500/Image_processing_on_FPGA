module RedFiltering(pixel_in, redfiltered);
input[11:0] pixel_in;
output[3:0] redfiltered;

assign redfiltered = pixel_in[11:8];//red


endmodule
