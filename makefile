all: SingleCycleProcessor

# source /softwares/setup/synopsys/setup.vcs.bash

SingleCycleProcessor: SingleCycleProc.v ALU.v immgen.v InstructionMemory.v SingleCycleControl.v RegisterFile.v DataMemory.v NextPCLogic.v SingleCycleProcTest.v
	vcs -full64 SingleCycleProc.v ALU.v immgen.v InstructionMemory.v SingleCycleControl.v RegisterFile.v DataMemory.v NextPCLogic.v SingleCycleProcTest.v


clean:
	rm -rf *.daidir
