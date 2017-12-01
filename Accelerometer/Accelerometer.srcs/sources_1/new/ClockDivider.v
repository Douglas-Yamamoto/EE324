`timescale 1ns / 1ps

module ClockDivider(input clk, input rst, output reg clkOut);
    parameter cycles = 50;
    reg [31:0] count;
    
    always @ (posedge clk, posedge rst)
    begin
        if (clk)
        begin
            count <= count + 1;
            
            if (count == cycles)
            begin
                count <= 0;
                clkOut <= ~clkOut;
            end
            else
            begin
                count <= count;
            end
        end
        else
        begin
            count <= 0;
            clkOut <= 0;
        end
    end

endmodule
