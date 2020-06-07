`timescale 1ns / 1ps

module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
	output [63:0] BusA, BusB;
	input [63:0] BusW;
	input [4:0] RA, RB, RW;
	input RegWr;
	input Clk;
	//create registers
	reg [64:0] registerfile [31:0];
	//assign output registers
	assign BusA = (RA == 31)?0:registerfile[RA];
	assign BusB = (RB == 31)?0:registerfile[RB];


		always @ (negedge Clk) //use negative edge of the clock
	begin
		if(RegWr && RW != 5'b11111) // if Reg Wr is 1 and Write address isnt to reg 31
		registerfile[RW] <= BusW;
		else if(RegWr && RW == 5'b11111)
			registerfile[RW] <= 0;
	end
endmodule
