module DataMemory_tb;

    reg [63:0] WriteData;
    reg [63:0] Address;
    reg Clock;
    reg EnableRead;
    reg EnableWrite;
    wire [63:0] ReadData;

    // Instantiate the module
    DataMemory uut (
        .ReadData(ReadData),
        .WriteData(WriteData),
        .Address(Address),
        .Clock(Clock),
        .EnableRead(EnableRead),
        .EnableWrite(EnableWrite)
    );

    // Clock generator
    initial Clock = 0;
    always #5 Clock = ~Clock;

    // Test sequence
    initial begin
        // Initialize signals
        WriteData = 64'h0;
        Address = 64'h0;
        EnableRead = 0;
        EnableWrite = 0;

        // Wait for the clock to stabilize
        #10;

        // Test Case 1: Write data to memory
        WriteData = 64'hDEADBEEFCAFEBABE;
        Address = 64'h10;
        EnableWrite = 1;
        EnableRead = 0;
        #10; // Wait for one clock cycle
        EnableWrite = 0;

        // Verify the write operation indirectly via a read
        EnableRead = 1;
        #10; // Wait for one clock cycle
        EnableRead = 0;

        if (ReadData !== 64'hDEADBEEFCAFEBABE) begin
            $display("Test Case 1 Failed: Expected 64'hDEADBEEFCAFEBABE, got %h", ReadData);
        end else begin
            $display("Test Case 1 Passed");
        end

        // Test Case 2: Read data from memory
        EnableRead = 1;
        #10; // Wait for one clock cycle
        EnableRead = 0;

        if (ReadData !== 64'hDEADBEEFCAFEBABE) begin
            $display("Test Case 2 Failed: Expected 64'hDEADBEEFCAFEBABE, got %h", ReadData);
        end else begin
            $display("Test Case 2 Passed");
        end

        // Test Case 3: Overwrite data
        WriteData = 64'h1122334455667788;
        EnableWrite = 1;
        #10; // Wait for one clock cycle
        EnableWrite = 0;

        // Read back overwritten data
        EnableRead = 1;
        #10; // Wait for one clock cycle
        EnableRead = 0;

        if (ReadData !== 64'h1122334455667788) begin
            $display("Test Case 3 Failed: Expected 64'h1122334455667788, got %h", ReadData);
        end else begin
            $display("Test Case 3 Passed");
        end

        // End simulation
        $stop;
    end
endmodule
