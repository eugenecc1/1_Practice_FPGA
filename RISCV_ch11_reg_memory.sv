module regfile (
    input logic clk,
    input logic we,
    input logic [4:0] srcreg1_num,
    input logic [4:0] srcreg2_num,
    input logic [4:0] dstreg_num,
    input logic [31:0] dstreg_value,
    output logic [31:0] srcreg1_value,
    output logic [31:0] srcreg2_value
);

    logic [31:0] regfile [1:31];  // 1-31レジスタ

    always_ff @(posedge clk) begin
        if (we) regfile[dstreg_num] <= dstreg_value;
    end
    
    assign srcreg1_value = (srcreg1_num == 5'd0) ? 32'd0 : regfile[srcreg1_num];
    assign srcreg2_value = (srcreg2_num == 5'd0) ? 32'd0 : regfile[srcreg2_num];

endmodule

module imem (
    input logic clk,
    input logic [31:0] addr,
    output logic [31:0] rd_data
);

    logic [31:0] mem [0:2047];  // 8KiB(13bitアドレス空間)
    logic [10:0] addr_sync;  // 8KiBを表現するための11bitアドレス(下位2bitはここでは考慮しない)
    
    initial $readmemh({MEM_DATA_PATH, "code.hex"}, mem);
     
    always_ff @(posedge clk) begin
        addr_sync <= addr[12:2];  // 読み出しアドレス更新をクロックと同期することでBRAM化
    end
    
    assign rd_data = mem[addr_sync];

endmodule

module dmem #(parameter byte_num = 2'b00) (
    input logic clk,
    input logic we,
    input logic [31:0] addr,
    input logic [7:0] wr_data,
    output logic [7:0] rd_data
);

    logic [7:0] mem [0:2047];  // 8KiB(13bitアドレス空間)
    logic [10:0] addr_sync;  // 8KiBを表現するための11bitアドレス(下位2bitはここでは考慮しない)
    
    initial begin
        unique case (byte_num)
            2'b00: $readmemh({MEM_DATA_PATH, "data0.hex"}, mem);
            2'b01: $readmemh({MEM_DATA_PATH, "data1.hex"}, mem);
            2'b10: $readmemh({MEM_DATA_PATH, "data2.hex"}, mem);
            2'b11: $readmemh({MEM_DATA_PATH, "data3.hex"}, mem);
        endcase
    end      
   
    always_ff @(posedge clk) begin
        if (we) mem[addr[12:2]] <= wr_data;  // 書き込みタイミングをクロックと同期することでBRAM化
        addr_sync <= addr[12:2];  // 読み出しアドレス更新をクロックと同期することでBRAM化
    end

    assign rd_data = mem[addr_sync];

endmodule
