`timescale 1ns / 1ps

module Accelerometer();
/*  
Input clock 1-5 MHz
SPI Commands
    0x0A: write register
    0x0B: read register
    0x0D: read FIFO
    
    Read & Write Commands
    </CS down> <command byte (read or write command)> <Address byte><Data byte> <Optional additionaal data byte for multi-byte></CS up>
    - where CS is ACL_CSN

    ACL_MISO
    ACL_MOSI
    ACL_SCLK
    ACL_CSN
    ACL_INT[1]
    ACL_INT[2]
*/



endmodule
