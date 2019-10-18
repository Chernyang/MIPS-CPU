module Registers #(parameter ADDR = 5, SIZE = 32, NUM = 1 << ADDR) (
    input [ADDR:1] ra1,
    input [ADDR:1] ra2,
    input [ADDR:1] wa,
    input [ADDR:1] addr,
    input [SIZE:1] wd,
    input we,
    input clk,
    input rst,
    output [SIZE:1] reg_data,
    output [SIZE:1] rd1,
    output [SIZE:1] rd2
);
    
    reg [SIZE:1] regs [NUM-1:0];
    integer i;
    
    always @ (posedge rst, posedge clk)
    begin
    if (rst)
        for (i = 0; i < NUM; i = i + 1) begin
            regs[i] <= 0;
        end
     else if (we) begin
        regs[wa] <= wd;
     end
    end

    assign reg_data = regs[addr];
    assign rd1 = regs[ra1];
    assign rd2 = regs[ra2];

endmodule 