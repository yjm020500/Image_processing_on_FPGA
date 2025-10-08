module greenfiltered(pixel_in, greenfiltered);
input[11:0] pixel_in;
output[11:0] greenfiltered;

assign greenfiltered = pixel_in[7:4];

endmodule
