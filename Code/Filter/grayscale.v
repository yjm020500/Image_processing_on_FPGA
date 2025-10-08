module grayscale(pixel_in, grayscale);
input[11:0] pixel_in;
output[3:0] grayscale;

assign grayscale = (299*pixel_in[11:8] + 587*pixel_in[7:4] + 114*pixel_in[3:0])/(1000);

endmodule
