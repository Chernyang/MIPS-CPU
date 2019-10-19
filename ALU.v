module ALU(
    input [2:0] s,
    input [31:0] a,
    input [31:0] b,
    output reg [31:0] y,
    output reg zero
    );

    parameter ADD = 0, SUB = 1, AND = 2, OR = 3, XOR = 4, NOR = 5, SLT = 6;
    always @ (*)
    begin
      case (s)
        ADD:
        begin
            y = a + b;
            if (a + b == 0) 
                zero = 1;
            else
                zero = 0;
        end
        SUB:
        begin
            y = a + ~b + 32'd1;  
            if (a + ~b + 32'd1 == 0)
                zero = 1;  
            else
                zero = 0;  
        end
        AND:
        begin
            y = a & b;
            if (a & b == 0)
                zero = 1;
            else
                zero = 0;
        end
        OR:
        begin
            y = a | b;
            if (a | b == 0)
                zero = 1;
            else
                zero = 0;            
        end
        XOR:
        begin
            y = (~a & b) | (a & ~b);
            if (((a & b) | (~a & ~b)) == 0)
                zero = 1;
            else 
                zero = 0;
        end
        NOR:
        begin
            y = ~(a | b);
            if (~(a | b) == 0)
                zero = 1;
            else
                zero = 0;
        end
        SLT:
        begin
            if (a[31] == 0 && b[31] == 0) begin
                y = (a < b) ? 1 : 0;
                zero = (a < b) ? 0 : 1;
            end
            if (a[31] == 1 && b[31] == 1) begin
                y = (a < b) ? 1 : 0;
                zero = (a < b) ? 0 : 1;
            end
            if (a[31] == 0 && b[31] == 1) begin
                y = 0;
                zero = 1;
            end
            if (a[31] == 1 && b[31] == 0) begin
                y = 1;
                zero = 0;
            end
        end
        default: begin
            y = 0;
            zero = 0;
        end
      endcase
    end
    
endmodule
