module edge_filtering(clk, pixel_in, pixel_out);//2clk 소모
input clk;
input[35:0] pixel_in;
output [11:0] pixel_out;

//filter_tap = {8'h02, 8'h01, 8'h00, 
//              8'h01, 8'h00, 8'hff, 
//              8'h00, 8'hff, 8'hfe};

reg signed [15:0] gx, gy; // 4+5+4
reg [3:0] grad;

always @(posedge clk) begin
        // Sobel 필터의 x방향 커널을 적용
        gx <= (pixel_in[35:32] * -1) + (pixel_in[31:28] * 0) + (pixel_in[27:24] * 1) +
             (pixel_in[23:20] * -2) + (pixel_in[19:16] * 0) + (pixel_in[15:12] * 2) +
             (pixel_in[11:8] * -1) + (pixel_in[7:4] * 0) + (pixel_in[3:0] * 1);
end

always @(posedge clk) begin
    gy <= (pixel_in[35:32] * 1) + (pixel_in[31:28] * 2) + (pixel_in[27:24] * 1) +
             (pixel_in[23:20] * 0) + (pixel_in[19:16] * 0) + (pixel_in[15:12] * 0) +
             (pixel_in[11:8] * -1) + (pixel_in[7:4] * -2) + (pixel_in[3:0] * -1);
end

always @(posedge clk) begin
    // 결과값을 8비트로 클리핑 (염두에 두어야 할 범위 내에서)
      // pixel_out <= (gx > 255) ? 255 : (gx < 0) ? 0 : gx[7:0];
      //pixel_out <= (gy > 255) ? 255 : (gy < 0) ? 0 : gy[7:0];
      grad <= (((gx > 15) ? 15 : (gx < 0) ? 0 : gx[3:0])/2) + (((gy > 15) ? 15 : (gy < 0) ? 0 : gy[3:0])/2);
end

assign pixel_out = {grad,grad,grad};

/*
always @(posedge clk) begin
        // Sobel 필터의 x방향 커널을 적용
        gx <= (pixel_in[71:64] * -1) + (pixel_in[63:56] * 0) + (pixel_in[55:48] * 1) +
             (pixel_in[47:40] * -2) + (pixel_in[39:32] * 0) + (pixel_in[31:24] * 2) +
             (pixel_in[23:16] * -1) + (pixel_in[15:8] * 0) + (pixel_in[7:0] * 1);
end

always @(posedge clk) begin
    gy <= (pixel_in[71:64] * 1) + (pixel_in[63:56] * 2) + (pixel_in[55:48] * 1) +
             (pixel_in[47:40] * 0) + (pixel_in[39:32] * 0) + (pixel_in[31:24] * 0) +
             (pixel_in[23:16] * -1) + (pixel_in[15:8] * -2) + (pixel_in[7:0] * -1);
end

always @(posedge clk) begin
    // 결과값을 8비트로 클리핑 (염두에 두어야 할 범위 내에서)
      // pixel_out <= (gx > 255) ? 255 : (gx < 0) ? 0 : gx[7:0];
      //pixel_out <= (gy > 255) ? 255 : (gy < 0) ? 0 : gy[7:0];
      grad <= 0.5*((gx > 15) ? 15 : (gx < 0) ? 0 : gx[3:0]) + 0.5*((gy > 15) ? 15 : (gy < 0) ? 0 : gy[3:0]);
end

assign pixel_out = {grad,grad,grad};
*/
endmodule