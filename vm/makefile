ODIN = odin
BIN = ../odari
OUT = $(BIN)
SRC = src/
SRC_FILES = $(SRC)/*.odin

ifeq ($(OS),Windows_NT)
	OUT = $(BIN).exe
endif

all: $(OUT)

$(OUT): $(SRC_FILES)
	$(ODIN) build $(SRC) -out:$(OUT)

run: $(OUT)
	./$(OUT)

debug: $(SRC_FILES)
	$(ODIN) build $(SRC) -out:$(OUT) -debug
	gdb $(OUT)