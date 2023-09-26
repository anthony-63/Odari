COMPILER_OUT = odaric
VM_OUT = odari

all: $(COMPILER_OUT) $(VM_OUT)

$(COMPILER_OUT):
	@echo "---------- BUILDING COMPILER ----------"
	make -C compiler -B

$(VM_OUT):
	@echo "------------- BUILDING VM -------------"
	make -C vm -B

TEST_SOURCE = test/language/test.odari
TEST_BYTECODE = test/compiled/test.odaric

run_tests: $(COMPILER_OUT) $(VM_OUT)
	odaric $(TEST_SOURCE) $(TEST_BYTECODE) -verbose -debug
	# odari $(TEST_BYTECODE) -debug