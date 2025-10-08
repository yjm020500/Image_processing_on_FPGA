module ram_320x240(clk, rst_n, pixel_in, pixel_out, flag);
input clk, rst_n;
input[3:0] pixel_in;
output reg[35:0] pixel_out;
output reg flag;

reg[3:0] ram[0:319][0:2];
reg[9:0] i;
integer k = -2;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        i<=1'b0; 
    end
    else begin
        if(i<319) begin
            i<=i+1'b1;
        end
        else begin
            i<=1'b0;
        end
    end
end 

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        k<=-2;
    end
    else begin
        if(k==76799) begin//end
                k<=-2;
        end
        else begin
            k<=k+1;
        end
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ram[i][2]<=0;
    end
    else begin
        ram[i][0] <= ram[i][1];
        ram[i][1] <= ram[i][2];
        ram[i][2] <= pixel_in;   
    end    
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        pixel_out <= 0;
    end
    else begin
        if(k<320) begin
            pixel_out <= 0;
        end
        else if(k==320) begin //처음왼쪽 i==0
            pixel_out <= {16'b0,ram[i][1],ram[i+1][1],4'b0,ram[i][2],ram[i+1][2]};
            flag<=1'b1;
        end
        else if(k==636) begin //처음 오른쪽 i==639
            pixel_out <= {12'b0,ram[i-1][1],ram[i][1],4'b0,ram[i-1][2],ram[i][2],4'b0};
        end
        else if(k<640) begin //처음 중간
            pixel_out <= {12'b0,ram[i-1][1],ram[i][1],ram[i+1][1],ram[i-1][2],ram[i][2],ram[i+1][2]};
        end
        else if(i==0&&k<76480) begin //중간 왼쪽
            pixel_out <= {4'b0,ram[i][0],ram[i+1][0],4'b0,ram[i][1],ram[i+1][1],4'b0,ram[i][2],ram[i+1][2]};
        end
        else if(i==639&&k<76480) begin//중간 오른쪽
            pixel_out <= {ram[i-1][0],ram[i][0],4'b0,ram[i-1][1],ram[i][1],4'b0,ram[i-1][2],ram[i][2],4'b0};
        end
        else if(k<76480) begin//중간 중간
            pixel_out <= {ram[i-1][0],ram[i][0],ram[i+1][0],ram[i-1][1],ram[i][1],ram[i+1][1],ram[i-1][2],ram[i][2],ram[i+1][2]};
        end
        else if(i==0) begin//끝 왼쪽
            pixel_out <= {4'b0,ram[i][0],ram[i+1][0],4'b0,ram[i][1],ram[i+1][1],12'b0};
        end
        else if(i==639) begin//끝 오른쪽
            pixel_out <= {ram[i-1][0],ram[i][0],4'b0,ram[i-1][1],ram[i][1],16'b0};
        end
        else begin //끝 중간
            pixel_out <= {ram[i-1][0],ram[i][0],ram[i+1][0],ram[i-1][1],ram[i][1],ram[i+1][1],12'b0};
        end
    end
end

endmodule