module MIPS(
    input cont,
    input step,
    input mem,
    input inc,
    input dec,
    input clk,
    input rst,
    output [15:0] led,
    output [7:0] an,
    output [7:0] seg
    );

    wire run, clk1;
    wire [7:0] pc, addr;
    wire [31:0] mem_data, reg_data;
    
    integer k;
    always @ (posedge clk)
    begin
        if (k < 10_000_000)
            k = k + 1;
        else
            k = 0;
    end
    assign clk1 = (k > 5_000_000);
    
    DDU DDU (.cont(cont), .step(step), .mem(mem), .inc(inc), .dec(dec), .clk(clk), .clk1(clk1), .rst(rst),
        .pc(pc), .mem_data(mem_data), .reg_data(reg_data), .run(run), .addr(addr),
        .led(led), .an(an), .seg(seg));

    CPU CPU (.run(run), .clk(clk1), .rst(rst), .addr(addr), .PC(pc), .mem_data(mem_data),
        .reg_data(reg_data));

endmodule
