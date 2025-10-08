module edgedet(clk, rst_n, pixel_in, pixel_out, flag);
input clk, rst_n;
input[11:0] pixel_in;
output[11:0] pixel_out;
output flag;

wire [3:0]grayscale;
wire[35:0] w_pixel_kernel;

assign grayscale = (299*pixel_in[11:8] + 587*pixel_in[7:4] + 114*pixel_in[3:0])/(1000);

ram_320x240 U0(.clk(clk), .rst_n(rst_n), .pixel_in(grayscale), .pixel_out(w_pixel_kernel), .flag(flag));
edge_filtering U1(.clk(clk), .pixel_in(w_pixel_kernel), .pixel_out(pixel_out));



endmodule