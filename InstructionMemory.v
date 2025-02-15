/*
Instruction memory module. Takes in an address as input, and outputs a 32 bit instruction
*/

module InstructionMemory(output reg [31:0] instruction, input [63:0] address, input CLK);

    always @(address) begin
        case(address)
            64'h0000: instruction <= 32'h91002041; // ADD X1, X2, #8
            64'h0004: instruction <= 32'hCB000842; // SUB X2, X2, X0
            64'h0008: instruction <= 32'h8A1F0C63; // AND X3, X1, X2
            64'h000C: instruction <= 32'hAA1F14C4; // ORR X4, X1, X2
            64'h0010: instruction <= 32'hF8400C21; // LDUR X0, [X2, #12]
            64'h0014: instruction <= 32'hF8000C20; // STUR X0, [X2, #12]
            64'h0018: instruction <= 32'hB4000082; // CBZ X2, <label> [label = 0x0028]
            64'h001C: instruction <= 32'hCB000842; // SUB X2, X2, X0
            64'h0020: instruction <= 32'h91002041; // ADD X1, X2, #8
            64'h0024: instruction <= 32'hCB000842; // SUB X2, X2, X0
            64'h0028: instruction <= 32'h17FFFFFD; // B <label> [label = 0x001c]
            64'h002C: instruction <= 32'hAA1F14C4; // ORR X4, X1, X2
            default: instruction <= 32'h91002041; // ADD X1, X2, #8 
        endcase
    end

endmodule