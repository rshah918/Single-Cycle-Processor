module tb_ImmediateGenerator;

    // Test inputs and outputs
    reg [25:0] imm26;
    reg [2:0] ctrl;
    wire [63:0] imm64;
    
    // Instantiate the ImmediateGenerator
    ImmediateGenerator uut (
        .imm64(imm64),
        .imm26(imm26),
        .ctrl(ctrl)
    );

    initial begin
        // Test I-Type
        ctrl = 3'b000;
        imm26 = 26'b00000000001010101010101010;  // Example immediate
        #10;
        $display("I-Type: imm26 = %b, imm64 = %b", imm26, imm64);
        if (imm64 !== 64'b000000000000000000000000000000000000000000000000000000000101010) $display("I-Type failed!");
        else $display("I-type passed!");

        // Test D-Type
        ctrl = 3'b001;
        imm26 = 26'b00000100000000100000000000;  // Example immediate with sign bit set
        #10;
        $display("D-Type: imm26 = %b, imm64 = %b", imm26, imm64);
        if (imm64 !== 64'b0001111111111111111111111111111111111111111111111111111100000000) $display("D-Type failed!");
        else $display("D-type passed!");

        // Test B-Type
        ctrl = 3'b010;
        imm26 = 26'b11100000000000000000010101;  // Example immediate with sign bit set
        #10;
        $display("B-Type: imm26 = %b, imm64 = %b", imm26, imm64);
        if (imm64 !== 64'b1111111111111111111111111111111111111111100000000000000000010101) $display("B-Type failed!");
        else $display("B-type passed!");
        // Test CB-Type
        ctrl = 3'b011;
        imm26 = 26'b01100000000000000000111000;  // Example immediate
        #10;
        $display("CB-Type: imm26 = %b, imm64 = %b", imm26, imm64);
        if (imm64 !== 64'b0111111111111111111111111111111111111111111111000000000000000001) $display("CB-Type failed!");
        else $display("CB-type passed!");

        // Test LW-Type
        ctrl = 3'b100;
        imm26 = 26'b00000100000000000000100000;  // Example immediate with sign bit set
        #10;
        $display("LW-Type: imm26 = %b, imm64 = %b", imm26, imm64);
        if (imm64 !== 64'b1111111111111111111111111111111111111111111111111000000000000001) $display("LW-Type failed!");
        else $display("LW-type passed!");

        $display("Immediate Generator testbench completed.");
        $finish;
    end

endmodule
