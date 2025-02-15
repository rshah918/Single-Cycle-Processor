/*
Instructions allocate between 11-26 bits for immediates depending on instruction type.

I-type instruction: bits 21-10
D-type (load/store): bits 20-12
B-type (unconditional branch) instruction: bits 25-0
CB-type (conditional branch) instruction: bits 23-5
IW (load word) instruction: bits 20-5

Inputs:
    - 26 bit immediate
    - 3 bit control signal

Output:
    - 64 bit immediate
*/
module ImmediateGenerator(output reg [63:0] imm64, input [25:0] imm26, input [2:0] ctrl, input CLK);
    always @(*) begin
        case (ctrl)
            3'b000: begin // I type instruction
                //green sheet specifies 0-extending I-type immediates.
                imm64 <= {{52{1'b0}}, imm26[21:10]};
                $display("DEBUG: IMMGEN I | imm26=%b | imm64=%h", imm26, imm64);  // Debug print

            end
            3'b001: begin // D type instruction
                imm64 <= {{52{imm26[20]}},imm26[20:12]};
                $display("DEBUG: IMMGEN D | imm26=%b | imm64=%h", imm26, imm64);  // Debug print

            end
            3'b010: begin // B type instruction
                imm64 <= {{38{imm26[25]}}, imm26[25:0]};
                $display("DEBUG: IMMGEN B | imm26=%b | imm64=%h", imm26, imm64);  // Debug print

            end
            3'b011: begin // CB type instruction
                imm64 <= {{44{imm26[23]}}, imm26[23:5]};
                $display("DEBUG: IMMGEN CBZ | imm26=%b | imm64=%h", imm26, imm64);  // Debug print

            end
            3'b100: begin // LW load word instruction
                imm64 <= {{48{imm26[20]}}, imm26[20:5]};
                $display("DEBUG: IMMGEN LW | imm26=%b | imm64=%h", imm26, imm64);  // Debug print

            end
        endcase
    end
endmodule