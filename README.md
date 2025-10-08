# Image_processing_on_FPGA

## 개요
  - 숭실대학교 2024년 2학기 디지털FPGA설계에서 진행한 영상 처리 프로젝트입니다.
  - JFK-200A FPGA 보드(qa~~)와 OV7670 카메라 모듈, VGA666 GPIO to VGA 컨버터를 사용하여 실시간으로 영상 처리하였습니다.
  - OV7670으로 받은 영상을 키패드를 통해 선택한 필터로 처리하여 GPIO 출력합니다.
  - 이때 이미지는 QVGA 규격이며, RGB 444입니다.
  - 선택한 필터 번호는 7-segment로 표시됩니다.
  - 출력된 GPIO 신호는 VGA666 컨버터를 통해 VGA 신호로 바뀌고, HDMI 컨버터로 최종 변환되어 모니터에 입력됩니다.
<br>

## 상세 내용
  ### 전체 구조
  <br>
    <img width="1346" height="627" alt="image" src="https://github.com/user-attachments/assets/726f1786-25e8-4d13-b5a6-45070d0f5cf4" />
  <br>
  
  - OV7670으로 읽어온 프레임을 키패드로 설정한 모드에 따라 필터 처리하여 VGA 출력합니다.<br>
  - 이때 화면은 QVGA 사이즈이며, 선택된 모드는 7-segment로 출력됩니다.
    <br>
    
  ### 카메라 세팅
  <img width="955" height="323" alt="image" src="https://github.com/user-attachments/assets/e881ec06-b6a4-4fd7-87c5-c85c875e95ed" />
  <br>
    
  - SCCB 통신을 통해 OV7670의 레지스터들에 값을 저장합니다.
  - 이때 읽어오는 값은 QVGA입니다.
  - Write할 레지스터 주소, write할 데이터 순으로 전송합니다.
  <br>
  
  ### 필터링
  <img width="566" height="581" alt="image" src="https://github.com/user-attachments/assets/d5c40646-2b33-4596-842a-ec0f315651a3" />
  <br>
  
  - 총 11개의 필터링 모드가 존재합니다.
  - 오리지널, grayscale, RGB 필터, 색상 반전, 특정 색만 강조, edge detection 등이 가능합니다.
  - Edge detection의 경우 Sobel 필터를 사용하였으며, 3개의 line memory로 전체 프레임 저장 없이 edge detection하였습니다.
  <br>
    <img width="1362" height="627" alt="image" src="https://github.com/user-attachments/assets/6d93ecb6-7655-4d11-ab22-b0f4319ef4fd" />
  <br>
  <br>
  
 ### keypad 및 7-segment
  - 키패드로 최종 출력을 선택합니다.
  - 선택된 모드는 7-segment를 통해 출력되어 어떤 모드인지 확인 가능합니다.
  <br>
  
  ### VGA
  <img width="661" height="199" alt="image" src="https://github.com/user-attachments/assets/57d0bbd2-4d62-4b4f-80ef-9c1ad09cc079" />
  <br>
  
  - RGB444 format입니다.
  - GPIO로 출력된 신호를 VGA666 컨버터를 통해 VGA 신호로 바꿉니다.
  <br>
  
  ### 결과: 영상 출력
  - 오리지널 영상 <br>
    <img width="582" height="336" alt="image" src="https://github.com/user-attachments/assets/a93baed5-a7e4-4d08-b3be-d906b5bf37e9" />
  <br>
  
  - Grayscale <br>
    <img width="622" height="378" alt="image" src="https://github.com/user-attachments/assets/807deb4e-1ee8-4f4f-829c-fe24f54f75f4" />
  <br>
  
  - RGB 필터1 <br>
    <img width="1214" height="225" alt="image" src="https://github.com/user-attachments/assets/df5dd6e2-34b0-4bd3-8c93-85f62d35607e" />
    <br>
    - 각각 R, G, B 값만 통과합니다.
  <br>
  
  - RGB 필터2 <br>
    <img width="1224" height="221" alt="image" src="https://github.com/user-attachments/assets/862f31b0-e8f0-4e7b-b2a8-9e79eb5ce8fd" />
    <br>
    - 각각 R, G, B 값만 제거합니다. 
  <br>
  
  - 특정 색만 강조 <br>
      <img width="539" height="307" alt="image" src="https://github.com/user-attachments/assets/728d9009-b5a0-4730-b494-87b818362048" />
      - 빨간색이 임계값보다 클 때만 통과, 나머지는 grayscale입니다.
    <br>
    
  - 색상 반전
      <br>
      <img width="503" height="287" alt="image" src="https://github.com/user-attachments/assets/e538a143-ea98-48ff-929d-204ba73e6d57" />
  <br>
      
  - Edge detection <br>
      <img width="498" height="273" alt="image" src="https://github.com/user-attachments/assets/450cd1dc-330b-4886-9a93-9f2fd9d8a545" />
      <br>
      - 왼쪽 화면: edge detection된 화면입니다.
      - 오른쪽 화면: grayscale 된 화면입니다.
