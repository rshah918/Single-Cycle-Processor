`timescale 1ns / 1ps

module NextPCLogic_tb;

    // Inputs
    reg [63:0] currentPC;
    reg [63:0] imm64;
    reg unconditionalBranch;
    reg conditionalBranch;
    reg ALUzero;

    // Outputs
    wire [63:0] nextPC;

    // Instantiate the unit under test (UUT)
    NextPCLogic uut (
        .nextPC(nextPC),
        .currentPC(currentPC),
        .imm64(imm64),
        .unconditionalBranch(unconditionalBranch),
        .conditionalBranch(conditionalBranch),
        .ALUzero(ALUzero)
    );

    // Test procedure
    initial begin
        // Apply stimulus and monitor output
        
        // Test 1: Unconditional branch
        currentPC = 64'h0000_0000_0000_1000;  // Current PC = 0x1000
        imm64 = 64'h0000_0000_0000_0004;      // Immediate = 4 (word offset)
        unconditionalBranch = 1;              // Unconditional branch
        conditionalBranch = 0;
        ALUzero = 0;                          // ALU zero does not matter here
        #10; // Wait 10 time units
        $display("Test 1 - nextPC: %h (Expected: 0x1000 + 0x10 = 0x1010)", nextPC);
        
        // Test 2: Conditional branch (ALUzero = 1, branch taken)
        unconditionalBranch = 0;
        conditionalBranch = 1;
        ALUzero = 1;                          // ALU zero, branch taken
        imm64 = 64'h0000_0000_0000_0004;      // Immediate = 4 (word offset)
        currentPC = 64'h0000_0000_0000_2000;  // Current PC = 0x2000
        #10;
        $display("Test 2 - nextPC: %h (Expected: 0x2000 + 0x10 = 0x2010)", nextPC);

        // Test 3: Conditional branch (ALUzero = 0, branch not taken)
        ALUzero = 0;                          // ALU zero, branch not taken
        conditionalBranch = 1;

        #10;
        $display("Test 3 - nextPC: %h (Expected: 0x2000 + 0x04 = 0x2004)", nextPC);

        // Test 4: No branch, just next instruction
        unconditionalBranch = 0;
        ALUzero = 0;                          // Not conditional branch
        imm64 = 64'h0000_0000_0000_0000;      // Immediate = 0 (no offset)
        currentPC = 64'h0000_0000_0000_3000;  // Current PC = 0x3000
        #10;
        $display("Test 4 - nextPC: %h (Expected: 0x3000 + 0x04 = 0x3004)", nextPC);

        // Test 5: Unconditional branch with larger offset
        currentPC = 64'h0000_0000_0000_4000;  // Current PC = 0x4000
        imm64 = 64'h0000_0000_0000_0010;      // Immediate = 16 (word offset)
        unconditionalBranch = 1;              // Unconditional branch
        ALUzero = 0;                          // ALU zero does not matter here
        #10;
        $display("Test 5 - nextPC: %h (Expected: 0x4000 + 0x40 = 0x4040)", nextPC);
        
        // Test 6: ALUzero = 1 with larger immediate value
        currentPC = 64'h0000_0000_0000_5000;  // Current PC = 0x5000
        imm64 = 64'h0000_0000_0000_0020;      // Immediate = 32 (word offset)
        unconditionalBranch = 0;
        ALUzero = 1;                          // ALU zero, branch taken
        #10;
        $display("Test 6 - nextPC: %h (Expected: 0x5000 + 0x80 = 0x5080)", nextPC);
        
        // Test 7: ALUzero = 0 with larger immediate value
        ALUzero = 0;                          // ALU zero, branch not taken
        #10;
        $display("Test 7 - nextPC: %h (Expected: 0x5000 + 0x04 = 0x5004)", nextPC);
        
        // End of simulation
        $finish;
    end
endmodule
