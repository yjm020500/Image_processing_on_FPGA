module select_top(clk, rst_n, bcd_data, key_valid, pixel_in, pixel_out, o_seg_d, o_seg_com,edgeon);
input clk, rst_n, key_valid;
input[4:0] bcd_data;
input[11:0] pixel_in;
output wire [11:0] pixel_out;
output [7:0] o_seg_d, o_seg_com;
output edgeon;

wire flag;
wire[3:0] grayscale, redfiltered, greenfiltered, bluefiltered; 
wire[11:0] colorinversed, sincitied, edgedetected;

seg7disp SEG(.i_rstn(rst_n), .i_clk(clk), .bcd_data(bcd_data), .o_seg_d(o_seg_com), .o_seg_com(o_seg_d));
grayscale GRAY(.pixel_in(pixel_in), .grayscale(grayscale));
RedFiltering RED(.pixel_in(pixel_in), .redfiltered(redfiltered));
greenfiltered GREEN(.pixel_in(pixel_in), .greenfiltered(greenfiltered));
bluefiltered BLUE(.pixel_in(pixel_in), .bluefiltered(bluefiltered));
ColorInversion CI(.pixel_in(pixel_in), .colorinversed(colorinversed));
sincity SC(.pixel_in(pixel_in), .pixel_out(sincitied));
edgedet ED(.clk(clk),.rst_n(rst_n),.pixel_in(pixel_in),.pixel_out(edgedetected),.flag(flag));


assign pixel_out =  ((bcd_data==5'h0) ? {grayscale,grayscale,grayscale} :
                    (bcd_data==5'h1) ? {redfiltered,8'h0} : 
                    (bcd_data==5'h2) ? {4'h0,greenfiltered,4'h0} :
                    (bcd_data==5'h3) ? {8'h0, bluefiltered} :
                    (bcd_data==5'h4) ? {4'h0,greenfiltered,bluefiltered} :
                    (bcd_data==5'h5) ? {redfiltered,4'h0,bluefiltered} :
                    (bcd_data==5'h6) ? {redfiltered,greenfiltered,4'h0} :
                    (bcd_data==5'h7) ? colorinversed :
                    (bcd_data==5'h8) ? edgedetected :
                    (bcd_data==5'h9) ? sincitied : pixel_in);
                    
assign edgeon = (bcd_data==5'h8) ? flag : 0;

endmodule