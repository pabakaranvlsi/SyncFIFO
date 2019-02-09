# Makefile for simulation and synthesis


help:
	@echo "***************************************************************************"
	@echo "	Make script for UART - 16550 - Transmitter simulation and Synthesis"
	@echo "***************************************************************************"
	@echo " Enter \"make run\" -  for compile and generate simulation executiable "
	@echo ""
	@echo ""	
	@echo " Enter \"make syn\" - for synthesis using Synopsys Design compiler "
	@echo ""
	@echo ""
	@echo "***************************************************************************"	
run:
	./Scripts/_run

syn:
	./Scripts/_syn

clean:
	rm -rf *~ ./simv ./csrc ./simv.daidir ./inter.vpd ./ucli.key \
	DVEfiles ./Scripts/*~ ./command.log ./default.svf ./*/*~
