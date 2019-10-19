module ControlUnit(
    input clk,
    input rst,
    input run,
    input [5:0] op,
    output reg PCWriteCond,
    output reg PCWrite,
    output reg IorD,
    output reg MemWrite,
    output reg MemtoReg,
    output reg IRWrite,
    output reg [1:0] PCSource,
    output reg [1:0] ALUOp,
    output reg [1:0] ALUSrcB,
    output reg ALUSrcA,
    output reg RegWrite,
    output reg RegDst,
    output reg EorN
);

    parameter Start = 0, InsFet = 1, InsDec = 2, MemAdrCom = 3, RExe = 4, IExe = 5, BeqCom = 6, 
    BneCom = 7, JumCom = 8, LwMemAcc = 9, SwMemAcc = 10, Rcom = 11, Icom = 12, WriBac = 13;
    reg [3:0] curr_state, next_state;

    always @ (posedge clk, posedge rst)
    begin
        if (rst)
            curr_state <= Start;
        else if (run)
            curr_state <= next_state;
        else curr_state <= curr_state;
    end

    always @ (*)
    begin
        case (curr_state)
            Start: begin
                next_state = InsFet;
            end
            InsFet: begin
                next_state = InsDec;
            end
            InsDec: begin
                if (op[5] == 1) begin
                        next_state = MemAdrCom;
                end
                else if (op == 6'b00_0000) begin
                        next_state = RExe;
                end
                else if (op[3] == 1) begin
                        next_state = IExe;
                end
                else if (op == 6'b00_0100) begin
                        next_state = BeqCom;
                end
                else if (op == 6'b00_0101) begin
                        next_state = BneCom;
                end
                else if (op == 6'b00_0010) begin
                        next_state = JumCom;
                end
                else next_state = InsFet;
            end
            MemAdrCom: begin
                if (op == 6'b10_0011) begin
                    next_state = LwMemAcc;
                end
                else if (op == 6'b10_1011) begin
                    next_state = SwMemAcc;
                end
                else next_state = InsFet;
            end
            RExe: begin
                next_state = Rcom;
            end
            IExe: begin
                next_state = Icom;
            end
            BeqCom: begin
                next_state = InsFet;
            end
            BneCom: begin
                next_state = InsFet;
            end
            JumCom: begin
                next_state = InsFet;
            end
            LwMemAcc: begin
                next_state = WriBac;
            end
            SwMemAcc: begin
                next_state = InsFet;
            end
            Rcom: begin
                next_state = InsFet;
            end
            Icom: begin
                next_state = InsFet;
            end
            WriBac: begin
                next_state = InsFet;
            end
            default: next_state = InsFet;
        endcase
    end

    always @ (curr_state)
    begin
        case (curr_state)
            Start: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b0;
                
                IorD = 1'bx;
                MemtoReg = 1'bx;
                PCSource = 2'bxx;
                ALUOp = 2'bxx;
                ALUSrcB = 2'bxx;
                ALUSrcA = 1'bx;
                RegDst = 1'bx;
                EorN = 1'bx;
            end
            InsFet: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b1;
                MemWrite = 1'b0;
                IRWrite = 1'b1;
                RegWrite = 1'b0;

                IorD = 1'b0;
                MemtoReg = 1'bx;
                PCSource = 2'b00;
                ALUOp = 2'b00;
                ALUSrcB = 2'b01;
                ALUSrcA = 1'b0;
                RegDst = 1'bx;
                EorN = 1'bx;
            end
            InsDec: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b0;

                IorD = 1'bx;
                MemtoReg = 1'bx;
                PCSource = 2'bxx;
                ALUOp = 2'b00;
                ALUSrcB = 2'b11;
                ALUSrcA = 1'b0;
                RegDst = 1'bx;
                EorN = 1'bx;
            end
            MemAdrCom: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b0;

                IorD = 1'bx;
                MemtoReg = 1'bx;
                PCSource = 2'bxx;
                ALUOp = 2'b00;
                ALUSrcB = 2'b10;
                ALUSrcA = 1'b1;
                RegDst = 1'bx;
                EorN = 1'bx;
            end 
            RExe: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b0;

                IorD = 1'bx;
                MemtoReg = 1'bx;
                PCSource = 2'bxx;
                ALUOp = 2'b10;
                ALUSrcB = 2'b00;
                ALUSrcA = 1'b1;
                RegDst = 1'bx;
                EorN = 1'bx;
            end
            IExe: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b0;

                IorD = 1'bx;
                MemtoReg = 1'bx;
                PCSource = 2'bxx;
                ALUOp = 2'b11;
                ALUSrcB = 2'b10;
                ALUSrcA = 1'b1;
                RegDst = 1'bx;
                EorN = 1'bx;
            end
            BeqCom: begin
                PCWriteCond = 1'b1;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b1;
                RegWrite = 1'b0;

                IorD = 1'bX;
                MemtoReg = 1'bx;
                PCSource = 2'b01;
                ALUOp = 2'b01;
                ALUSrcB = 2'b00;
                ALUSrcA = 1'b1;
                RegDst = 1'bX;
                EorN = 1'b1;
            end
            BneCom: begin
                PCWriteCond = 1'b1;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b0;

                IorD = 1'bX;
                MemtoReg = 1'bx;
                PCSource = 2'b01;
                ALUOp = 2'b01;
                ALUSrcB = 2'b00;
                ALUSrcA = 1'b1;
                RegDst = 1'bx;
                EorN = 1'b0;
            end
            JumCom: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b1;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b0;
                
                IorD = 1'bx;
                MemtoReg = 1'bx;
                PCSource = 2'b10;
                ALUOp = 2'bxx;
                ALUSrcB = 2'bxx;
                ALUSrcA = 1'bx;
                RegDst = 1'bx;
                EorN = 1'bx;
            end
            LwMemAcc: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b0;
                
                IorD = 1'b1;
                MemtoReg = 1'bx;
                PCSource = 2'bxx;
                ALUOp = 2'bxx;
                ALUSrcB = 2'bxx;
                ALUSrcA = 1'bx;
                RegDst = 1'bx;
                EorN = 1'bx;
            end
            SwMemAcc: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                MemWrite = 1'b1;
                IRWrite = 1'b0;
                RegWrite = 1'b0;
                
                IorD = 1'b1;
                MemtoReg = 1'bx;
                PCSource = 2'bxx;
                ALUOp = 2'bxx;
                ALUSrcB = 2'bxx;
                ALUSrcA = 1'bx;
                RegDst = 1'bx;
                EorN = 1'bx;
            end
            Rcom: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b1;
                
                IorD = 1'bx;
                MemtoReg = 1'b0;
                PCSource = 2'bxx;
                ALUOp = 2'bxx;
                ALUSrcB = 2'bxx;
                ALUSrcA = 1'bx;
                RegDst = 1'b1;
                EorN = 1'bx;
            end
            Icom: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b1;
                
                IorD = 1'bx;
                MemtoReg = 1'b0;
                PCSource = 2'bxx;
                ALUOp = 2'bxx;
                ALUSrcB = 2'bxx;
                ALUSrcA = 1'bx;
                RegDst = 1'b0;
                EorN = 1'bx;
            end
            WriBac: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b1;
                
                IorD = 1'bx;
                MemtoReg = 1'b1;
                PCSource = 2'bxx;
                ALUOp = 2'bxx;
                ALUSrcB = 2'bxx;
                ALUSrcA = 1'bx;
                RegDst = 1'b0;
                EorN = 1'bx;
            end
            default: begin
                PCWriteCond = 1'b0;
                PCWrite = 1'b0;
                MemWrite = 1'b0;
                IRWrite = 1'b0;
                RegWrite = 1'b0;
                
                IorD = 1'bx;
                MemtoReg = 1'bx;
                PCSource = 2'bxx;
                ALUOp = 2'bxx;
                ALUSrcB = 2'bxx;
                ALUSrcA = 1'bx;
                RegDst = 1'bx;
                EorN = 1'bx;
            end
        endcase
    end

endmodule // ControlUnit