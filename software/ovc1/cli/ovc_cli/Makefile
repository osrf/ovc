BIN=bin
NAME=cli
OUT=$(BIN)/$(NAME)

LDFLAGS=-g
CFLAGS=-O2 -g

SRCS=main.cpp
OBJS=$(SRCS:%.cpp=$(BIN)/%.o)

default: $(BIN) $(OUT)

clean:
	rm -rf bin

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
