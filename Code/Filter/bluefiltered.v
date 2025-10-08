module bluefiltered(pixel_in, bluefiltered);
input[11:0] pixel_in;
output[3:0] bluefiltered;

assign bluefiltered = pixel_in[3:0];

endmodule
