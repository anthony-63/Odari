COMPILER_OUT = odaric
VM_OUT = odari

all: $(COMPILER_OUT) $(VM_OUT)

$(COMPILER_OUT):
	@echo "---------- BUILDING COMPILER ----------"
	make -C compiler -B

$(VM_OUT):
	@echo "------------- BUILDING VM -------------"
	make -C vm -B


run_tests: $(COMPILER_OUT) $(VM_OUT)
	odaric test/test.odari out:test/test.odaric
	odari test/test.odaric -debug -verbose