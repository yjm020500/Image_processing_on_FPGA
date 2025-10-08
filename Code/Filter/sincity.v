module sincity(
    input wire [11:0] pixel_in,
    output wire [11:0] pixel_out
    );
    
    wire [3:0] pixel_ready;
    
    assign pixel_ready=(299*pixel_in[11:8] + 587*pixel_in[7:4] + 114*pixel_in[3:0])/1000;
    
    assign pixel_out = ((pixel_in[11:8]> 4'b1010) && (pixel_in[7:4]< 4'b1000)&&(pixel_in[3:0]< 4'b1000)) ? 
                   {pixel_in[11:8], 4'h0, 4'h0}:
                   {pixel_ready, pixel_ready, pixel_ready};

endmodule