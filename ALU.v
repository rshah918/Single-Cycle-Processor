/*
Lets implement an ALU

inputs: 
    - A: 64 bits operand
    - B: 64 bit operand
    - op: 2 bit operation selector
output: 
    - C: 64 bit result
    - zero: 64 bit zero value
operations: ADD, SUB, AND, OR, PASSB 
*/

module ALU(
    output reg [63:0] C, 
    output zero, 
    input [63:0] A, 
    input [63:0] B, 
    input [2:0] ctrl
);
    always @(*) begin
        case (ctrl)
            3'b000: begin
                C = A + B;
                $display("DEBUG: ALU | ADD | A=%d, B=%d, Result=%d", A, B, C);
            end
            3'b001: begin
                C = A - B;
                $display("DEBUG: ALU | SUB | A=%d, B=%d, Result=%d", A, B, C);
            end
            3'b010: begin
                C = A & B;
                $display("DEBUG: ALU | AND | A=%b, B=%b, Result=%b", A, B, C);
            end
            3'b011: begin
                C = A | B;
                $display("DEBUG: ALU | OR  | A=%b, B=%b, Result=%b", A, B, C);
            end
            3'b100: begin
                C = B; // Used for MOV or similar operations.
                $display("DEBUG: ALU | MOV | B=%d, Result=%d", B, C);
            end
            default: begin
                C = 64'b0;
                $display("DEBUG: ALU | INVALID CTRL | ctrl=%b | Defaulting to 0", ctrl);
            end
        endcase
    end
    
    assign zero = (C == 64'b0);

endmodule
