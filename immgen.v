`timescale 1ns / 1ps

module ImmGenerator(Imm64,Imm26,Ctrl);
  output reg[63:0] Imm64;
  input [25:0] Imm26;
  input [2:0] Ctrl;

  reg extBit;

  always @(*)
  begin
  case (Ctrl[2:0])
  3'b000: //I type instruction
  begin
      extBit = 0;
      Imm64 = {{52{extBit}}, Imm26[21:10]};
  end

  3'b001: // load/store
  begin
      extBit = Imm64[20];
      Imm64 = {{55{extBit}}, Imm26[20:12]};
  end

  3'b010: // unconditional branch
  begin
      extBit = Imm26[25];
      Imm64 = {{38{extBit}}, Imm26[25:0]};
  end

  3'b011: // conditional branch
  begin
      extBit = Imm26[23];
      Imm64 = {{44{extBit}}, Imm26[23:5]};
  end

  3'b100: // MOVZ, LSR = 0
  begin
      extBit = 0;
      Imm64 = {{48{extBit}}, Imm26[20:5]};
  end

    3'b101: // MOVZ, LSR = 16
  begin
      extBit = 0;
      Imm64 = {{32{extBit}}, Imm26[20:5], {16{extBit}}};
  end

    3'b110: // MOVZ, LSR = 32
  begin
      extBit = 0;
      Imm64 = {{16{extBit}}, Imm26[20:5], {32{extBit}}};
  end

    3'b111: // MOVZ, LSR = 64
  begin
      extBit = 0;
      Imm64 = {Imm26[20:5], {48{extBit}}};
  end


  default:
  begin
      Imm64 = 64'b0;
  end
  endcase
  end
endmodule
