`timescale 1ns/1ps

/*
Next PC Logic implementation

Calculate the memory address of the next instruction. This involves decoding branch instructions to determine the next address. If the current
    instruction is not a branch instruction, then simply increment the PC

Inputs:
    - 64 bit immediate
    - Current PC
    - Unconditional Branch
    - Conditional Branch
    - ALUzero

Outputs:
    - Next PC

Logic:

If unconditional branch, then nextPC = currentPC + imm64 << 2. Unconditional branch immediates are WORD offsets, not byte offsets. So we multiply by 4 to get the byte offset.
If conditional branch, then nextPC = currentPC + imm64 << 2 ONLY IF aluZero is true. This means that the branch is taken, and we should perform a jump.
In all other cases, nextPC = currentPC + 4 bytes
*/

module NextPCLogic(
    output reg [63:0] nextPC,
    input [63:0] currentPC,
    input [63:0] imm64,
    input unconditionalBranch,
    input conditionalBranch,
    input ALUzero,
    input CLK
);
    reg [63:0] byteImm64;
    always @(*) begin
        byteImm64 = imm64 << 2;
        // Unconditional Branch
        if (unconditionalBranch) begin
            nextPC = currentPC +  byteImm64;
        end
        // Conditional Branch
        else if (conditionalBranch) begin
            // Jump if conditional branch is taken
            if (ALUzero) begin
                nextPC = currentPC + byteImm64;
            end
            // Conditional branch not taken, move to next instruction
            else begin
                nextPC = currentPC + 4;
            end
        end
        // Default, not a branch instruction
        else begin
                nextPC = currentPC + 4;  
        end
    end

endmodule

