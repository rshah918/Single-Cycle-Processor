/*
Data Memory Module 

Inputs: 
    - WriteData: Data to write into memory
    - Address: Address to read/write to 
    - Clock: Clock Signal
    - EnableRead: Control signal to enable mem read
    - EnableWrite: Control signal to enable mem write 
Outputs:
    - ReadData: Data read from memory


NOTE: Why in the unholy fuck do we have 2 control signals here???? This is stupid. 
    "Computer Organization and Design" by David Patterson states that only 1 of these signals
    will be enabled during any given clock cycle. So why not condense both into 1 signal??

    I am suspicious... 
    
    Alright I totally forgot that this is (simulated) hardware, signals can flucuate before stabilizing. Messy transients can erronously trigger
        downstream modules. To prevent that, we explicity add redundant control signals, setting both to 0 means this module will simply not change state. 
        
    This caused me issues when I also decided to condense unconditionalBranch and conditionalBranch signals. Inferring 
        conditional branches from both unconditionalBranch and ALUzero signals
        fails dramatically because ALUzero tends to "flicker" befor stabilzing. 
*/

module DataMemory(
    output reg [63:0] ReadData, 
    input [63:0] WriteData, 
    input [63:0] Address, 
    input Clock,
    input EnableRead,
    input EnableWrite);
    
    reg [7:0] RAM[65535:0]; // 2^64 addresses, each address contains 1 byte

    // Big Endian byte ordering!
    always @(posedge Clock)
        begin
            if (EnableRead) begin
                    ReadData[63:56] = RAM[Address];
                    ReadData[55:48] = RAM[Address+1];
                    ReadData[47:40] = RAM[Address+2];
                    ReadData[39:32] = RAM[Address+3];
                    ReadData[31:24] = RAM[Address+4];
                    ReadData[23:16] = RAM[Address+5];
                    ReadData[15:8] = RAM[Address+6];
                    ReadData[7:0] = RAM[Address+7];
            end 
            else if (EnableWrite) begin
                    RAM[Address] = WriteData[63:56];
                    RAM[Address+1] = WriteData[55:48];
                    RAM[Address+2] = WriteData[47:40];
                    RAM[Address+3] = WriteData[39:32];
                    RAM[Address+4] = WriteData[31:24];
                    RAM[Address+5] = WriteData[23:16];
                    RAM[Address+6] = WriteData[15:8];
                    RAM[Address+7] = WriteData[7:0];
            end
        end
    

endmodule