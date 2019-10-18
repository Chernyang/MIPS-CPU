module Memory(
    input MemRead,
    input MemWrite,
    input IRWrite,
    input rst,
    input clk,
    input [7:0] addr,
    input [7:0] Address,
    input [31:0] WriteData,
    output reg [31:0] IR,
    output reg [31:0] MDR,
    output [31:0] mem_data
);

    reg [31:0] regs [255:0];

    always @ (posedge clk)
    begin
        if (MemRead) begin
            MDR <= regs[Address];
            if (IRWrite)
                IR <= regs[Address];
        end
        else if (MemWrite)
            regs[Address] <= WriteData;
    end
    
    always @ (posedge clk, posedge rst)
    begin
        if (rst)
            $readmemh("D:/Course/COD/Lab/Lab5_CPU/MIPS/project_1.srcs/sources_1/new/inst_rom.coe", regs);
    end

    assign mem_data = regs[addr];

endmodule // Memory