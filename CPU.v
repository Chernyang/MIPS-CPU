module CPU(
    input run,
    input clk,
    input rst,
    input [7:0] addr,
    output reg [7:0] PC,
    output [31:0] mem_data,
    output [31:0] reg_data
);

    reg [31:0] IR, MDR, A, B, ALUOut;
    wire [1:0] PCSource, ALUOp, ALUSrcB;
    wire PCWriteCond, PCWrite, MemWrite, IRWrite, RegWrite;
    wire IorD, MemtoReg, ALUSrcA,  RegDst, EorN;
    wire zero, zero2, PCEnable;
    wire [7:0] AddrMux;
    wire [4:0] WriRegMux;
    wire [27:0] IRSL;
    wire [31:0] WriDatMux, AMux, BMux, MemData, SigExt, SigExtSL, PCMux, ALURes, rd1, rd2;
    wire [2:0] ALUChoice;
    
    dist_mem_gen_0 Mem (.a(AddrMux), .d(B), .dpra(addr), .clk(clk), .we(run && MemWrite), .spo(MemData), .dpo(mem_data));

    ALU ALU (.s(ALUChoice), .a(AMux), .b(BMux), .y(ALURes), .zero(zero));

    ControlUnit CU (.clk(clk), .rst(rst), .run(run), .op(IR[31:26]), .PCWriteCond(PCWriteCond), .PCWrite(PCWrite),
        .IorD(IorD), .MemWrite(MemWrite), .MemtoReg(MemtoReg), .IRWrite(IRWrite),
        .PCSource(PCSource), .ALUOp(ALUOp), .ALUSrcB(ALUSrcB), .ALUSrcA(ALUSrcA), .RegWrite(RegWrite),
        .RegDst(RegDst), .EorN(EorN));

    Registers Regs (.ra1(IR[25:21]), .ra2(IR[20:16]), .wa(WriRegMux), .addr(addr[4:0]),
        .wd(WriDatMux), .we(run && RegWrite), .clk(clk), .rst(rst), .reg_data(reg_data), .rd1(rd1), .rd2(rd2));               

    ALUControl ALUC (.ALUOp(ALUOp), .OP(IR[31:26]), .func(IR[5:0]), .s(ALUChoice));
    
    assign AddrMux = (IorD ? ALUOut : PC) / 4;
    assign WriRegMux = RegDst ? IR[15:11] : IR[20:16];
    assign WriDatMux = MemtoReg ? MDR : ALUOut;
    assign AMux = ALUSrcA ? A : PC;
    assign BMux = (ALUSrcB > 1) ? ((ALUSrcB == 2) ? SigExt : SigExtSL) : ((ALUSrcB == 0) ? B : 4);
    assign PCMux = (PCSource > 1) ? {4'b0000, IRSL} : ((PCSource == 0) ? ALURes : ALUOut);
    assign IRSL = {IR[25:0], 2'b00};
    assign SigExt = IR[15] ? {16'b1111_1111_1111_1111, IR[15:0]} : {16'b0000_0000_0000_0000, IR[15:0]};
    assign SigExtSL = SigExt << 2;
    assign PCEnable = PCWrite | (PCWriteCond & zero2);
    assign zero2 = EorN ? zero : ~zero;

    always @ (*)
    begin
        A = rd1;
        B = rd2;
    end

    always @ (posedge clk, posedge rst)
    begin
        if (run)
        begin
            ALUOut <= ALURes;
            MDR <= MemData;
        end
        else begin
            ALUOut <= ALUOut;
            MDR <= MDR;
        end
        if (rst) begin
            PC <= 0;
        end
        else if (PCEnable && run) begin
            PC <= PCMux; 
        end      
        else PC <= PC; 
    end

    always @ (posedge clk, posedge rst)
    begin
        if (rst)
            IR <= 0;
        else if (IRWrite && run)
            IR <= MemData;
        else IR <= IR;
    end

endmodule // CPU