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
TEST_BYTECODE = test/compiled/hello_world.odaric

run_tests: $(COMPILER_OUT) $(VM_OUT)
	odaric $(TEST_SOURCE) out:$(TEST_BYTECODE)
	odari $(TEST_BYTECODE) -debug
	
exp: $(VM_OUT)
	odari $(TEST_BYTECODE) -super-secret-flag -verbose