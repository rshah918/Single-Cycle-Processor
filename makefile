all: SingleCycleProcessor

SingleCycleProcessor: SingleCycleProcessor.v RegisterFile.v NextPCLogic.v InstructionMemory.v ImmediateGenerator.v DataMemory.v Control.v ALU.v SingleCycleProcessor_tb.v
	iverilog -o SingleCycleProcessor SingleCycleProcessor.v RegisterFile.v NextPCLogic.v InstructionMemory.v ImmediateGenerator.v DataMemory.v Control.v ALU.v SingleCycleProcessor_tb.v

clean:
	rm -rf *.daidir
