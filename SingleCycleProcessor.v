`timescale 1ns / 1ps 

module SingleCycleProcessor(
    output reg [63:0] currentPC,
    output [63:0] dataMemoryOut,
    input CLK,
    input [63:0] startPC,
    input reset
);
    // Next PC connection
    wire [63:0] nextPC;
    // Instruction Memory connection
    wire [31:0] instruction;
    // Instruction parts
    wire [4:0] rd;
    wire [4:0] rn;
    wire [4:0] rm;
    wire [10:0] opcode;
    // Control module connections
    wire regSrcSelect;
    wire [2:0] aluOp;
    wire memtoReg;
    wire aluSrc;
    wire memRead;
    wire memWrite;
    wire regWrite;
    wire unconditionalBranch;
    wire conditionalBranch;
    wire [2:0] immGenOp;
    // Register file connections
    wire [63:0] regA;
    wire [63:0] regB;
    wire [63:0] regWriteData;
    // ALU connections
    wire [63:0] aluOut;
    wire zero;
    // Immediate Generator connection
    wire [63:0] imm64, aluInputTwo;
    // Data Memory connection
    wire [63:0] readData;
    
    InstructionMemory instrMem(
        .instruction(instruction),
        .address(currentPC),
        .CLK(CLK)
    );

    NextPCLogic nextPCLogic(
        .currentPC(currentPC),
        .imm64(imm64),
        .unconditionalBranch(unconditionalBranch),
        .conditionalBranch(conditionalBranch),
        .ALUzero(zero),
        .nextPC(nextPC),
        .CLK(CLK)
    );

    always @(negedge CLK) begin
        if (!reset)  // Active-low reset is convention in hardware design due to less noise when pulling a signal down to 0
            currentPC <= startPC;
        else
            currentPC <= nextPC;
end
    assign rd = instruction[4:0];
    assign rn = instruction[9:5];
    assign #2 rm = regSrcSelect ? instruction[4:0] : instruction[20:16];
    assign opcode = instruction[31:21];

    Control controlUnit(
        .regSrcSelect(regSrcSelect),
        .aluOp(aluOp),
        .memtoReg(memtoReg),
        .aluSrc(aluSrc),
        .memRead(memRead),
        .memWrite(memWrite),
        .regWrite(regWrite),
        .unconditionalBranch(unconditionalBranch),
        .conditionalBranch(conditionalBranch),
        .immGenOp(immGenOp),
        .opcode(opcode)
    );

    RegisterFile regFile(
        .BusW(regWriteData),
        .RA(rn),
        .RB(rm),
        .RW(rd),
        .WriteEnable(regWrite),
        .Clk(CLK),
        .BusA(regA),
        .BusB(regB)
    );

    ImmediateGenerator immGen64(
        .ctrl(immGenOp),
        .imm26(instruction[25:0]),
        .imm64(imm64),
        .CLK(CLK)
    );

    assign #2 aluInputTwo = aluSrc ? imm64 : regB;

    ALU alu(
        .ctrl(aluOp),
        .A(regA),
        .B(aluInputTwo),
        .zero(zero),
        .C(aluOut)
    );

    DataMemory dataMem(
        .EnableRead(memRead),
        .EnableWrite(memWrite),
        .Clock(CLK),
        .Address(aluOut),
        .WriteData(regB),
        .ReadData(readData)
    );

    assign #2 dataMemoryOut = memtoReg ? readData : aluOut;
    assign regWriteData = dataMemoryOut;
endmodule