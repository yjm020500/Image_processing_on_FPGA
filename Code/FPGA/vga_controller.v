module vga_controller (
    input wire clk,
    input wire edgeon,
    output reg [16:0] frame_addr=0,
    input wire [11:0] frame_pixel,
    output reg [3:0] vga_red,
    output reg [3:0] vga_green,
    output reg [3:0] vga_blue,
    output reg vga_hsync,
    output reg vga_vsync
);
    reg [9:0] h_count = 0;  // 수평 카운터
    reg [9:0] v_count = 0;  // 수직 카운터
    reg [9:0] h_count_delay = 0;  // 수평 카운터
    reg [9:0] v_count_delay = 0;  // 수직 카운터
    reg [3:0] blank =0;
    reg [3:0] rgbon =4'b1111;
    reg active_region;

    always @(posedge clk) begin
        // 수평 카운터 증가
        if (h_count < 799)
            h_count <= h_count + 1;
        else begin
            h_count <= 0;
            // 수직 카운터 증가
            if (v_count < 524)
                v_count <= v_count + 1;
            else
                v_count <= 0;
        end
        
        // 딜레이 보상을 위한 오프셋 카운터
        if (h_count >= 325) begin
            h_count_delay <= h_count - 325;
            v_count_delay <= v_count;
        end else begin
            h_count_delay <= h_count + (800 - 325);
            if (v_count == 0)
                v_count_delay <= 524;
            else
                v_count_delay <= v_count - 1;
        end

        // HSYNC 및 VSYNC 생성
 /*       
        vga_hsync <= (edgeon ? 
                      (h_count_delay >= 656 && h_count_delay < 752) : 
                      (h_count >= 656 && h_count < 752));

        vga_vsync <= (edgeon ? 
                      (v_count_delay >= 490 && v_count_delay < 492) : 
                      (v_count >= 490 && v_count < 492));
*/                      
        vga_hsync <= (h_count >= 656 && h_count < 752);  // 수평 동기
        vga_vsync <= (v_count >= 490 && v_count < 492);  // 수직 동기

        
        active_region = (h_count >= 165 && h_count < 485 && v_count >= 120 && v_count < 360);
        // 활성 구간 계산
        if (active_region) begin
            if (edgeon == 1'b0)
                frame_addr <= (v_count - 120) * 320 + (h_count - 160);
            else
                frame_addr <= (v_count_delay - 120) * 320 + (h_count_delay - 160);

            {vga_red, vga_green, vga_blue} <= frame_pixel;
        end else begin
            {vga_red, vga_green, vga_blue} <= 12'b0;
        end
    end

 /*       // 활성 구간에서 프레임 주소 및 픽셀 색상 출력
     if (h_count >= 165 && h_count < 485 && v_count >= 120 && v_count < 360) begin
         frame_addr <= (v_count - 120) * 320 + (h_count - 160);  // 1:1 매핑
         {vga_red, vga_green, vga_blue} <= frame_pixel;        // 프레임 픽셀 출력

     end else begin
         {vga_red, vga_green, vga_blue} <= 12'b0;             // 화면 외부는 검정색 처리
     end
    end
    */
endmodule