module filtering_top(clk, rst_n, key_in, key_out, pixel_in, pixel_out, o_seg_d, o_seg_com, edgeon);
input clk, rst_n;
input [4:0] key_in;
input [11:0] pixel_in;
output [3:0] key_out;
output [11:0] pixel_out;
output[7:0] o_seg_d, o_seg_com;
output edgeon;
 
wire[4:0] w_bcd_data;
wire w_key_valid;
wire w_pls_1k;

key_func_top KEYFUNC(.i_rstn(rst_n), .i_clk(clk), .i_pls_1k(w_pls_1k), .i_key_in(key_in), .o_key_out(key_out), .o_bcd_data(w_bcd_data), .o_key_valid(w_key_valid));
clk_pls CLKPLS(.i_clk(clk),.i_rstn(rst_n), .o_pls_1k(w_pls_1k));
select_top SELECT(.clk(clk), .rst_n(rst_n), .bcd_data(w_bcd_data), .key_valid(w_key_valid), .pixel_in(pixel_in), .pixel_out(pixel_out), .o_seg_d(o_seg_d), .o_seg_com(o_seg_com),.edgeon(edgeon));

endmodule
