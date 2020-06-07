`timescale 1ns / 1ps

module NextPCLogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
       	input [63:0] CurrentPC, SignExtImm64;
       	input Branch, ALUZero, Uncondbranch;

       	output reg [63:0] NextPC;

       	reg [63:0] tempImm64;

    always @(*) begin

    	tempImm64 = SignExtImm64 << 2; // leftshift by 2 bits

    	// if unconditional branch
       	if(Uncondbranch) begin
       		NextPC  <= CurrentPC + tempImm64; // add immediate to current pc
       	end
       	else if(Branch) begin // if conditional branch
       		if(ALUZero == 1) begin // it was zero therefore should jump
       			NextPC <= CurrentPC + tempImm64;
       		end
       		else begin
       			NextPC <= CurrentPC + 4; // if evaluates to false
       		end
       	end
       	else begin // just move onto the next instruction normally
       		NextPC <= CurrentPC + 4;
       	end
   	end

endmodule
