`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/12 10:12:18
// Design Name: 
// Module Name: MIPS_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module MIPS_tb(
    );
    
    reg step, mem, cont, inc, dec, rst;
    wire [15:0] led;
    wire [7:0] an, seg;
    wire clk;
    integer m;
    initial
    begin
        for (m = 0; m < 100_000_000; m = m + 1)
            #5;
    end
    assign clk = (m % 2) ? 1 : 0;
    
    initial
    begin
        cont = 1; #10;     
    end
    
    initial
    begin
        mem = 1; #100;
    end
    
    initial
    begin
        rst = 1; #20;
        rst = 0; #100;
    end
    
    initial
    begin
        inc = 1; dec = 0; #10;
    end
    
    MIPS DUT (.cont(cont), .step(step), .mem(mem), .inc(inc), .dec(dec), .clk(clk), .rst(rst), .led(led), .seg(seg), .an(an));
    
endmodule
