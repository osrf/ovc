BIN=bin
NAME=console
OUT=$(BIN)/$(NAME)

LDFLAGS=-g
CFLAGS=-O2 -g

SRCS=main.cpp lightweightserial.cpp
OBJS=$(SRCS:%.cpp=$(BIN)/%.o)

default: $(BIN) $(OUT)

$(BIN):
	mkdir -p $(BIN)

$(BIN)/%.o: %.cpp
	g++ $(CFLAGS) -c $< -o $@

$(OUT): $(OBJS)
	g++ $(OBJS) $(LDFLAGS) -o $(OUT)

run: $(OUT)
	@echo "================================================="
	@$(OUT)
	@echo "================================================="
