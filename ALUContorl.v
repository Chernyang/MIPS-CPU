module ALUControl(
    input [1:0] ALUOp,
    input [5:0] OP,
    input [5:0] func,
    output reg [2:0] s
);

//  s == 0 --add; s == 1 --sub; s == 2 --or; s == 3 --xor; s == 4 --nor; s == 5 --slt;
    always @ (*)
    begin
        if (ALUOp == 2'b00)
            s = 0;
        else if (ALUOp == 2'b01)
            s = 1;
        else if (ALUOp == 2'b10) begin
            if (func == 6'b100000)
                s = 0;
            else if (func == 6'b100010)
                s = 1;
            else if (func == 6'b100100)
                s = 2;
            else if (func == 6'b100101)
                s = 3;
            else if (func == 6'b100110)
                s = 4;
            else if (func == 6'b100111)
                s = 5;
            else if (func == 6'b101010)
                s = 6;
            else s = 0;
        end
        else if (ALUOp == 2'b11) begin
            if (OP == 6'b001000)
                s = 0;
            else if (OP == 6'b001100)
                s = 2;
            else if (OP == 6'b001101)
                s = 3;
            else if (OP == 6'b001110)
                s = 4;
            else if (OP == 6'b001010)
                s = 6;
            else s = 0;
        end
    end

endmodule // ALUControl