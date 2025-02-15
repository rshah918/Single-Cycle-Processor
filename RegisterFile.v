/*
Module to read and write to cpu registers.

Input: 
    - RA, RB: Indices of the registers to be read
    - RW: Index of register to write to
    - BusW: Data to write into register writeReg

    - Clk: Clock signal
    - WriteEnable: Signal to enable register write-mode
    
Output:
    - BusA, BusB: Contents of registers A and B

Other implementations dont let you write to register 31... Im gonna allow it until I know why I shouldnt
*/


module RegisterFile(output reg [63:0] BusA, output reg [63:0] BusB, input [63:0] BusW, input [4:0] RA, input [4:0] RB, input [4:0] RW, input WriteEnable, input Clk);
    reg [63:0] registerFile[31:0]; // 32 registers, each 64 bits wide
    
    // Initialize all registers to 0 at the beginning of simulation
    integer i;
    initial begin
        for (i = 0; i < 32; i = i + 1) begin
            registerFile[i] = 64'b0;
        end
    end

    always @(*) begin
            BusA = registerFile[RA];
            BusB = registerFile[RB];
        end
    always @(negedge Clk) begin
            if (WriteEnable == 1)
                registerFile[RW] <= BusW;
        end
endmodule