module ALU_tb;
    reg [63:0] A, B;         // Test inputs
    reg [2:0] ctrl;          // Operation selector
    wire [63:0] C;           // Result
    wire zero;               // Zero flag

    // Instantiate the ALU
    ALU alu_inst (
        .C(C),
        .zero(zero),
        .A(A),
        .B(B),
        .ctrl(ctrl)
    );

    initial begin
        $display("Starting ALU Testbench...");
        $display("Time\tA\t\t\tB\t\t\tCtrl\tC\t\t\tZero");

        // Test ADD
        A = 63'h0000_0005; B = 63'h0000_0003; ctrl = 3'b000;
        #10 $display("%0t\t%h\t%h\t%b\t%h\t%b", $time, A, B, ctrl, C, zero);

        // Test SUB
        A = 63'h0000_0005; B = 63'h0000_0005; ctrl = 3'b001;
        #10 $display("%0t\t%h\t%h\t%b\t%h\t%b", $time, A, B, ctrl, C, zero);

        // Test AND
        A = 63'hF0F0_F0F0; B = 63'h0F0F_0F0F; ctrl = 3'b010;
        #10 $display("%0t\t%h\t%h\t%b\t%h\t%b", $time, A, B, ctrl, C, zero);

        // Test OR
        A = 63'hF0F0_F0F0; B = 63'h0F0F_0F0F; ctrl = 3'b011;
        #10 $display("%0t\t%h\t%h\t%b\t%h\t%b", $time, A, B, ctrl, C, zero);

        // Test PASSB
        A = 63'hAAAA_AAAA; B = 63'h5555_5555; ctrl = 3'b100;
        #10 $display("%0t\t%h\t%h\t%b\t%h\t%b", $time, A, B, ctrl, C, zero);

        // Test Default
        ctrl = 3'b111;
        #10 $display("%0t\t%h\t%h\t%b\t%h\t%b", $time, A, B, ctrl, C, zero);

        $display("ALU Testbench completed.");
        $finish;
    end
endmodule
