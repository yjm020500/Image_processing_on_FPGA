module OV7670_to_VGA (
    input wire clk,             // FPGA 메인 클럭 (10MHz)
    input wire rst,             // 리셋 신호
    input wire OV7670_PCLK,     // OV7670 픽셀 클럭
    input wire OV7670_VSYNC,    // OV7670 프레임 동기 신호
    input wire OV7670_HREF,     // OV7670 라인 동기 신호
    input wire [7:0] OV7670_D,  // OV7670 데이터
    input btn,                  // 버튼
    input wire [4:0] key_in,
    output wire OV7670_XCLK,    // OV7670 시스템 클럭
    output wire OV7670_RESET,   // OV7670 리셋 신호
    output wire OV7670_PWDN,    // OV7670 전원 관리
    output wire [3:0] vga_red,  // VGA 빨간색 출력
    output wire [3:0] vga_green,// VGA 초록색 출력
    output wire [3:0] vga_blue, // VGA 파란색 출력
    output wire vga_hsync,      // VGA 수평 동기 신호
    output wire vga_vsync,       // VGA 수직 동기 신호
    output wire sioc,
    output wire siod,
    output init_done,
    output wire [3:0] key_out,
    output wire [7:0] o_seg_d, o_seg_com
);

    // 내부 신호 정의
    wire [17:0] capture_addr;    // OV7670 캡처 주소
    wire [11:0] capture_data;    // OV7670 픽셀 데이터
    wire capture_we;             // OV7670 데이터 쓰기 활성화
    wire [16:0] frame_addr;      // VGA 프레임 주소
    wire [11:0] frame_pixel;     // VGA 픽셀 데이터
    wire clk25;                  // 25MHz 클럭 (VGA용)
    wire [11:0] filtered_pixel;
    wire edgeon;

    // 클럭 생성
    clk_wiz_0 clk_gen (
        .clk_in1(clk),
        .resetn(rst),
        .clk_out1(clk25)
    );
    
    assign OV7670_XCLK = ~clk25;  // OV7670 XCLK에 25MHz 클럭 연결
    assign OV7670_RESET = 1;     // OV7670 리셋 비활성화
    assign OV7670_PWDN = 0;      // OV7670 전원 항상 켜짐



    i2c_ov7670_init i2c_init (
        .clk(clk25),
        .start(~btn),
        .sioc(sioc),  // I2C Clock 연결
        .siod(siod),  // I2C Data 연결
        .done(init_done)
    );
    
    // OV7670 데이터 캡처
    ov7670_capture cap (
        .pclk(OV7670_PCLK),
        .vsync(OV7670_VSYNC),
        .href(OV7670_HREF),
        .d(OV7670_D),
        .addr(capture_addr),
        .dout(capture_data),
        .we(capture_we)
    );

    // 프레임 버퍼 메모리
    blk_mem_gen_0 frame_buffer (
        .clka(OV7670_PCLK),
        .wea(capture_we),
        .addra(capture_addr),
        .dina(capture_data),
        .clkb(clk25),
        .addrb(frame_addr),
        .doutb(frame_pixel)
    );
    
    filtering_top ft0(
    .clk(clk25),
    .rst_n(rst),
    .key_in(key_in),
    .key_out(key_out),
    .pixel_in(frame_pixel),
    .pixel_out(filtered_pixel),
    .o_seg_d(o_seg_d),
    .o_seg_com(o_seg_com),
    .edgeon(edgeon)
    );

    // VGA 컨트롤러
    vga_controller vga (
        .clk(clk25),
        .edgeon(edgeon),
        .frame_addr(frame_addr),
        .frame_pixel(filtered_pixel),
        .vga_red(vga_red),
        .vga_green(vga_green),
        .vga_blue(vga_blue),
        .vga_hsync(vga_hsync),
        .vga_vsync(vga_vsync)
    );

endmodule