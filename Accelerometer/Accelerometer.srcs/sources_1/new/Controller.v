`timescale 1ns / 1ps

module Controller   (input CLK100MHZ, input START, input RST, input ACL_MISO, output reg ACL_MOSI, 
                    output reg ACL_SCLK, output reg ACL_CSN, output reg [15:0] LED);
     localparam readXaxisData = 16'h0a20;
     
     localparam     init = 0,
                    write = 1,
                    read = 2,
                    display = 3;
     
     reg [1:0] currentState, nextState;      
     reg [5:0] currentCount, nextCount;
     reg [7:0] measuredXAxis;         
    // module ClockDivider(input clk, input rst, output reg clkOut);
    ClockDivider clk0(CLK100MHZ, RST, ACL_SCLK);     
    // module Accelerometer(input spiClk, input int1, input int2, output reg MISO, output reg MOSI, output reg CSN);
    Accelerometer acc(ACL_SCLK, 0, 0, ACL_MISO, ACL_MOSI, ACL_CSN);
    
    always @ (posedge CLK100MHZ, posedge RST)
    begin
        if (RST == 1)
        begin
            currentState <= init;
            currentCount <= 0;
        end
        
        else
        begin
            currentState <= nextState;
            currentCount <= nextCount;
        end 
    end
    
    //always @ (*)
    always @ (posedge ACL_SCLK)
    begin
        case (currentState)
            init : begin
                nextCount <= 0;
                nextState <= write;
            end
            
            write : begin
                assign ACL_CSN = 0;
                if (nextCount < 16)
                begin
                    assign ACL_MOSI = readXaxisData & (16'h0001 << currentCount);
                    nextCount <= nextCount + 1;
                    nextState <= currentState;
                end
                
                else
                begin
                    nextCount <= 0;
                    nextState <= read;
                end
            end
            
            read : begin
                if (nextCount < 8)
                begin
                    measuredXAxis <= measuredXAxis || (ACL_MISO << currentCount);
                    nextCount <= nextCount + 1;
                    nextState <= currentState;
                end
                
                else
                begin
                    assign ACL_CSN = 1;
                    nextCount <= 0;
                    nextState <= display;
                end
            end
            
            display : begin
                LED <= measuredXAxis;
            end
            
            default : begin
                nextState <= init;
            end
        endcase 
    end
                       
endmodule
