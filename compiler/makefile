ODIN = odin
OUT = ../odaric.exe
SRC = src/
SRC_FILES = $(SRC)/*.odin

all: $(OUT)

$(OUT): $(SRC_FILES)
	$(ODIN) build $(SRC) -out:$(OUT)

run: $(OUT)
	./$(OUT)

debug: $(SRC_FILES)
	$(ODIN) build $(SRC) -out:$(OUT) -debug
	gdb $(OUT)