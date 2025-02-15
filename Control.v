/*
Single Cycle Processor Control module implementation

Basically a giant switch-case: Map control signals to opcodes

Input:
    - Instruction: 32 bit instruction
Output: 
    - regSrcSelect: Determines which bit index range the second operand should come from. Its location differs for load/store instructions
    - MemtoReg: Determines the data source for register write. Data written to the register file can come from RAM or the ALU.
    - aluOp: ALU operation to perform
    - aluSrc: Determines if 1 of the ALU operands should come from the register file or immediate generator. Latter is for instructions containing immediates
    - memRead: Enables Data Memory module RAM read ops
    - memWrite: Enables Data Memory module RAM write ops
    - regWrite: Enables data write register writes
    - unConditionalBranch: 1 bit signal to indicate that the current instruction is an unconditional branch. This drives the nextPC calculation
    - conditionalBranch: 1 bit signal to indicate that the current instruction is a conditionalBranch.
    - immGenOp: 3 bit control signal for the immediate generator module. This signal determines the bit index range of the immediate, which depends on the instruction

*/

`define OPCODE_ADDREG 11'b10001011000
`define OPCODE_ADDIMM 11'b1001000100?

`define OPCODE_SUBREG 11'b11001011000
`define OPCODE_SUBIMM 11'b1101000100?

`define OPCODE_ANDREG 11'b10001010000
`define OPCODE_ANDIMM 11'b1001001000?

`define OPCODE_ORREG 11'b10101010000
`define OPCODE_ORIMM 11'b1011001000?

`define OPCODE_B       11'b?00101?????
`define OPCODE_CBZ     11'b?011010????

`define OPCODE_LDUR 11'b11111000010
`define OPCODE_STUR 11'b11111000000

module Control(
    output reg regSrcSelect,
    output reg [2:0] aluOp, 
    output reg memtoReg,
    output reg aluSrc,
    output reg memRead,
    output reg memWrite,
    output reg regWrite,
    output reg unconditionalBranch,
    output reg conditionalBranch,
    output reg Branch,
    output reg [2:0] immGenOp,
    input [10:0] opcode
);
always @(*) begin
    casez (opcode)
        `OPCODE_LDUR: begin
            regSrcSelect <= 1'bx;
            aluSrc <= 1'b1;
            memtoReg <= 1'b1;
            regWrite <= 1'b1;
            memRead  <= 1'b1;
            memWrite <= 1'b0;
            unconditionalBranch <= 1'b0;
            conditionalBranch <= 1'b0;
            aluOp <= 3'b000;
            immGenOp <= 3'b001;
        end

        `OPCODE_STUR: begin
            regSrcSelect <= 1'b1;
            aluSrc <= 1'b1;
            memtoReg <= 1'bx;
            regWrite <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b1;
            unconditionalBranch <= 1'b0;
            conditionalBranch <= 1'b0;
            aluOp <= 3'b000;
            immGenOp <= 3'b001;
        end
        `OPCODE_ADDREG: begin
            regSrcSelect <= 1'b0;
            aluSrc <= 1'b0;
            memtoReg <= 1'b0;
            regWrite <= 1'b1;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            unconditionalBranch <= 1'b0;
            conditionalBranch <= 1'b0;
            aluOp <= 3'b000;
            immGenOp <= 3'bxxx;
        end
        `OPCODE_SUBREG: begin
            regSrcSelect <= 1'b0;
            aluSrc <= 1'b0;
            memtoReg <= 1'b0;
            regWrite <= 1'b1;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            unconditionalBranch <= 1'b0;
            conditionalBranch <= 1'b0;
            aluOp <= 3'b001;
            immGenOp <= 3'bxxx;
        end
        `OPCODE_ANDREG: begin
            regSrcSelect <= 1'b0;
            aluSrc <= 1'b0;
            memtoReg <= 1'b0;
            regWrite <= 1'b1;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            unconditionalBranch <= 1'b0;
            conditionalBranch <= 1'b0;
            aluOp <= 3'b010;
            immGenOp <= 3'bxxx;
        end
        `OPCODE_ORREG: begin
            regSrcSelect <= 1'b0;
            aluSrc <= 1'b0;
            memtoReg <= 1'b0;
            regWrite <= 1'b1;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            unconditionalBranch <= 1'b0;
            conditionalBranch <= 1'b0;
            aluOp <= 3'b011;
            immGenOp <= 3'bxxx;
        end
        `OPCODE_CBZ: begin
            regSrcSelect <= 1'b1;
            aluSrc <= 1'b0;
            memtoReg <= 1'bx;
            regWrite <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            unconditionalBranch <= 1'b0;
            conditionalBranch <= 1'b1; 
            aluOp <= 3'b100;
            immGenOp <= 3'b011;
        end
        `OPCODE_B: begin
            regSrcSelect <= 1'bx;
            aluSrc <= 1'bx;
            memtoReg <= 1'bx;
            regWrite <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            unconditionalBranch <= 1'b1;
            conditionalBranch <= 1'b0;
            aluOp <= 3'bxxx;
            immGenOp <= 3'b010;
        end
        `OPCODE_ADDIMM: begin
            regSrcSelect <= 1'b1;
            aluSrc <= 1'b1;
            memtoReg <= 1'b0;
            regWrite <= 1'b1;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            unconditionalBranch <= 1'b0;
            conditionalBranch <= 1'b0;
            aluOp <= 3'b000;
            immGenOp <= 3'b000;
        end
        `OPCODE_SUBIMM: begin
            regSrcSelect <= 1'b1;
            aluSrc <= 1'b1;
            memtoReg <= 1'b0;
            regWrite <= 1'b1;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            unconditionalBranch <= 1'b0;
            conditionalBranch <= 1'b0;
            aluOp <= 3'b001;
            immGenOp <= 3'b000;
        end
        default: begin
            regSrcSelect <= 1'bx;
            aluSrc <= 1'bx;
            memtoReg <= 1'bx;
            regWrite <= 1'b0;
            memRead <= 1'b0;
            memWrite <= 1'b0;
            unconditionalBranch <= 1'b0;
            conditionalBranch <= 1'b0;
            aluOp <= 3'bxxx;
            immGenOp <= 3'bxxx;
        end
    endcase
end

endmodule
