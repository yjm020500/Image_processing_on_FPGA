module ov7670_capture (
    input wire pclk,
    input wire vsync,
    input wire href,
    input wire [7:0] d,
    output reg [16:0] addr,
    output reg [11:0] dout,
    output reg we
);
    reg [15:0] pixel_data=0;
    reg byte_toggle=0;
    reg [10:0] display_half_counter=0;
    
    parameter MAX_ADDR = 76800;
    
    always @(posedge pclk) begin
        if (vsync) begin
            addr <= 0;
            we <= 0;
            byte_toggle<=0;
//            display_half_counter<=0;
     
        end else if (href && (addr < MAX_ADDR)) begin
            byte_toggle <= ~byte_toggle;
            if (byte_toggle) begin
 //               if((display_half_counter >= 960)||(display_half_counter<320)) begin
 //                       addr <= addr;       // pixel addr 올리는 것을 멈춤
 //                       pixel_data <= pixel_data;       // 받는 데이터도 고정
 //                   end
 //               else begin
                    pixel_data[7:0] <= d;
//                    end
                end else begin
//                if((display_half_counter >= 960)||(display_half_counter<320)) begin
 //                   pixel_data <= pixel_data;
   //                 end
 //               else begin
                    pixel_data[15:8] <= d;
                    dout <= {pixel_data[15:12], pixel_data[10:7], pixel_data[4:1]};
                    addr <= addr + 1;
                    we <= 1;
 //                   end
                end
  //              display_half_counter <= display_half_counter+1;
            end else begin
  //          display_half_counter<=0;
        end
    end
endmodule