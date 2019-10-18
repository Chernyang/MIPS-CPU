module DDU(
    input cont,
    input step,
    input mem,  
    input inc,  
    input dec,  
    input clk,
    input rst,  
    input clk1,
    input [7:0] pc,
    input [31:0] mem_data,  
    input [31:0] reg_data,  
    output reg run,
    output [7:0] addr,  
    output [15:0] led,  //in the front,it's addr;in the rear,it's pc
    output reg [7:0] an,  
    output reg [7:0] seg  
);

    reg [7:0] reg_file [7:0];
    wire [31:0] data;
    reg [7:0] addri, addrd;
    integer m;
    reg [7:0] N0 = 8'b1100_0000, N1 = 8'b1111_1001, N2 = 8'b1010_0100, N3 = 8'b1011_0000, N4 = 8'b1001_1001,
        N5 = 8'b1001_0010, N6 = 8'b1000_0010, N7 = 8'b1111_1000, N8 = 8'b1000_0000, N9 = 8'b1001_0000,
        Na = 8'b1000_1000, Nb = 8'b1000_0011, Nc = 8'b1100_0110, Nd = 8'b1010_0001, Ne = 8'b1000_0100,
        Nf = 8'b1000_1110;

    assign led = {addr, pc};
    assign data = mem ? mem_data : reg_data;

    reg [26:0] counter_run;
    always @ (posedge clk1)
    begin
        if(cont == 1'b1)
            run <= 1'b1;
        else begin
            if(step == 1'b1) begin
                if(counter_run <= 27'd10) begin
                    run <= 1'b0;
                    counter_run <= counter_run + 27'd1;
                end else begin
                    run <= 1'b1;         
                    counter_run <= 27'd0;
                end
            end else
                run <= 1'b0;
        end
    end

    always @ (posedge dec, posedge rst)
    begin
        if (rst)
            addrd <= 0;
        else if (dec)
            addrd <= addrd + 1;
    end
    
    always @ (posedge inc, posedge rst)
    begin
        if (rst)
            addri <= 0;
        else if (inc) begin
            if (mem) begin
                if (addri == 255)
                    addri <= 255;
                else
                    addri <= addri + 1;
            end
            else
                addri <= addri + 1; 
        end  
    end

    assign addr = addri - addrd;

    always @ (data)
    begin
        case (data[31:28])
            4'h0: reg_file[7] = N0;
            4'h1: reg_file[7] = N1;
            4'h2: reg_file[7] = N2;
            4'h3: reg_file[7] = N3;
            4'h4: reg_file[7] = N4;
            4'h5: reg_file[7] = N5;
            4'h6: reg_file[7] = N6;
            4'h7: reg_file[7] = N7;
            4'h8: reg_file[7] = N8;
            4'h9: reg_file[7] = N9;
            4'ha: reg_file[7] = Na;
            4'hb: reg_file[7] = Nb;
            4'hc: reg_file[7] = Nc;
            4'hd: reg_file[7] = Nd;
            4'he: reg_file[7] = Ne;
            4'hf: reg_file[7] = Nf;
            default: reg_file[7] = 8'b1111_1111;
        endcase
        case (data[27:24])
            4'h0: reg_file[6] = N0;
            4'h1: reg_file[6] = N1;
            4'h2: reg_file[6] = N2;
            4'h3: reg_file[6] = N3;
            4'h4: reg_file[6] = N4;
            4'h5: reg_file[6] = N5;
            4'h6: reg_file[6] = N6;
            4'h7: reg_file[6] = N7;
            4'h8: reg_file[6] = N8;
            4'h9: reg_file[6] = N9;
            4'ha: reg_file[6] = Na;
            4'hb: reg_file[6] = Nb;
            4'hc: reg_file[6] = Nc;
            4'hd: reg_file[6] = Nd;
            4'he: reg_file[6] = Ne;
            4'hf: reg_file[6] = Nf;
            default: reg_file[6] = 8'b1111_1111;
        endcase
        case (data[23:20])
            4'h0: reg_file[5] = N0;
            4'h1: reg_file[5] = N1;
            4'h2: reg_file[5] = N2;
            4'h3: reg_file[5] = N3;
            4'h4: reg_file[5] = N4;
            4'h5: reg_file[5] = N5;
            4'h6: reg_file[5] = N6;
            4'h7: reg_file[5] = N7;
            4'h8: reg_file[5] = N8;
            4'h9: reg_file[5] = N9;
            4'ha: reg_file[5] = Na;
            4'hb: reg_file[5] = Nb;
            4'hc: reg_file[5] = Nc;
            4'hd: reg_file[5] = Nd;
            4'he: reg_file[5] = Ne;
            4'hf: reg_file[5] = Nf;
            default: reg_file[5] = 8'b1111_1111;
        endcase      
        case (data[19:16])
            4'h0: reg_file[4] = N0;
            4'h1: reg_file[4] = N1;
            4'h2: reg_file[4] = N2;
            4'h3: reg_file[4] = N3;
            4'h4: reg_file[4] = N4;
            4'h5: reg_file[4] = N5;
            4'h6: reg_file[4] = N6;
            4'h7: reg_file[4] = N7;
            4'h8: reg_file[4] = N8;
            4'h9: reg_file[4] = N9;
            4'ha: reg_file[4] = Na;
            4'hb: reg_file[4] = Nb;
            4'hc: reg_file[4] = Nc;
            4'hd: reg_file[4] = Nd;
            4'he: reg_file[4] = Ne;
            4'hf: reg_file[4] = Nf;
            default: reg_file[4] = 8'b1111_1111;
        endcase  
        case (data[15:12])
            4'h0: reg_file[3] = N0;
            4'h1: reg_file[3] = N1;
            4'h2: reg_file[3] = N2;
            4'h3: reg_file[3] = N3;
            4'h4: reg_file[3] = N4;
            4'h5: reg_file[3] = N5;
            4'h6: reg_file[3] = N6;
            4'h7: reg_file[3] = N7;
            4'h8: reg_file[3] = N8;
            4'h9: reg_file[3] = N9;
            4'ha: reg_file[3] = Na;
            4'hb: reg_file[3] = Nb;
            4'hc: reg_file[3] = Nc;
            4'hd: reg_file[3] = Nd;
            4'he: reg_file[3] = Ne;
            4'hf: reg_file[3] = Nf;
            default: reg_file[3] = 8'b1111_1111;
        endcase   
        case (data[11:8])
            4'h0: reg_file[2] = N0;
            4'h1: reg_file[2] = N1;
            4'h2: reg_file[2] = N2;
            4'h3: reg_file[2] = N3;
            4'h4: reg_file[2] = N4;
            4'h5: reg_file[2] = N5;
            4'h6: reg_file[2] = N6;
            4'h7: reg_file[2] = N7;
            4'h8: reg_file[2] = N8;
            4'h9: reg_file[2] = N9;
            4'ha: reg_file[2] = Na;
            4'hb: reg_file[2] = Nb;
            4'hc: reg_file[2] = Nc;
            4'hd: reg_file[2] = Nd;
            4'he: reg_file[2] = Ne;
            4'hf: reg_file[2] = Nf;
            default: reg_file[2] = 8'b1111_1111;
        endcase 
        case (data[7:4])
            4'h0: reg_file[1] = N0;
            4'h1: reg_file[1] = N1;
            4'h2: reg_file[1] = N2;
            4'h3: reg_file[1] = N3;
            4'h4: reg_file[1] = N4;
            4'h5: reg_file[1] = N5;
            4'h6: reg_file[1] = N6;
            4'h7: reg_file[1] = N7;
            4'h8: reg_file[1] = N8;
            4'h9: reg_file[1] = N9;
            4'ha: reg_file[1] = Na;
            4'hb: reg_file[1] = Nb;
            4'hc: reg_file[1] = Nc;
            4'hd: reg_file[1] = Nd;
            4'he: reg_file[1] = Ne;
            4'hf: reg_file[1] = Nf;
            default: reg_file[1] = 8'b1111_1111;               
        endcase  
        case (data[3:0])
            4'h0: reg_file[0] = N0;
            4'h1: reg_file[0] = N1;
            4'h2: reg_file[0] = N2;
            4'h3: reg_file[0] = N3;
            4'h4: reg_file[0] = N4;
            4'h5: reg_file[0] = N5;
            4'h6: reg_file[0] = N6;
            4'h7: reg_file[0] = N7;
            4'h8: reg_file[0] = N8;
            4'h9: reg_file[0] = N9;
            4'ha: reg_file[0] = Na;
            4'hb: reg_file[0] = Nb;
            4'hc: reg_file[0] = Nc;
            4'hd: reg_file[0] = Nd;
            4'he: reg_file[0] = Ne;
            4'hf: reg_file[0] = Nf;
            default: reg_file[0] = 8'b1111_1111;               
        endcase           
    end

    //Seven code segments driven,display diffierent numbers
    always @ (posedge clk)
    begin
        if (m < 100_000)
            m <= m + 1;
        else begin
            m <= 0;
            if (an[7]) begin
                an <= {an[6:0], 1'b1};
            end
            else
                an <= 8'b1111_1110;
        end
        case (an)
            8'b1111_1110: begin
                seg <= reg_file[0];
            end
            8'b1111_1101: begin
                seg <= reg_file[1];
            end
            8'b1111_1011: begin
                seg <= reg_file[2];
            end
            8'b1111_0111: begin
               seg <= reg_file[3];
            end
            8'b1110_1111: begin
               seg <= reg_file[4];
           end
            8'b1101_1111: begin
                seg <= reg_file[5];
            end
            8'b1011_1111: begin
                seg <= reg_file[6];
            end
            8'b0111_1111: begin
                seg <= reg_file[7];
            end  
            default: begin
                seg <= 8'b1111_1111;
            end                                                                      
        endcase        
    end    

endmodule // DDU