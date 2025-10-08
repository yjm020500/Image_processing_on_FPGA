module seg7disp (
      input        i_rstn   ,
      input        i_clk    ,
      input  [4:0] bcd_data ,
      output [7:0] o_seg_d  ,
      output [7:0] o_seg_com
  );

  reg  [7:0] r_seg_d;
  reg  [7:0] r_seg_com;

  //rising edge detect & mode inversion
  always@(posedge i_clk, negedge i_rstn) begin
      if(!i_rstn) begin
          r_seg_d   <= 8'h0;
      end
      else begin
          r_seg_d   <= (bcd_data==5'h0) ? 8'h3f : //segment      "0"
                       (bcd_data==5'h1) ? 8'h06 : //segment      "1"
                       (bcd_data==5'h2) ? 8'h5b : //2
                       (bcd_data==5'h3) ? 8'h4f : //3
                       (bcd_data==5'h4) ? 8'h66 : //4
                       (bcd_data==5'h5) ? 8'h6d : //5
                       (bcd_data==5'h6) ? 8'h7d : //6
                       (bcd_data==5'h7) ? 8'h27 : //7
                       (bcd_data==5'h8) ? 8'h7f : //8
                       (bcd_data==5'h9) ? 8'h6f : //9
                       (bcd_data==5'ha) ? 8'h5f : //a
                       (bcd_data==5'hb) ? 8'h7c : //b
                       (bcd_data==5'hc) ? 8'h58 : //c
                       (bcd_data==5'hd) ? 8'h5e : //d
                       (bcd_data==5'he) ? 8'h7b ://segment      "e"
                                          8'h71 ;//segment      "F"
      end
  end
  
  always @(posedge i_clk or negedge i_rstn) begin
      if(!i_rstn) begin
          r_seg_com <= 8'h0000_0001;
      end
      else begin
          if(r_seg_com==8'b0000_1000) begin
              r_seg_com <= 8'b0000_0001;
          end
          else begin
              r_seg_com <= r_seg_com<<1;
          end
      end
  end
  
  //assign output
  assign o_seg_d = r_seg_d;
  assign o_seg_com = r_seg_com;

  
  
endmodule