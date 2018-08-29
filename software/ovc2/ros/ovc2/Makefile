BIN=bin
NAME=ovc2_cli
OUT=$(BIN)/$(NAME)

LDFLAGS=-g -L/opt/ros/kinetic/lib -lrostime
CFLAGS=-O2 -g --std=c++14 -I/opt/ros/kinetic/include

SRCS=cli.cpp ovc2.cpp lightweightserial.cpp
OBJS=$(SRCS:%.cpp=$(BIN)/%.o)

default: $(BIN) $(OUT)

clean:
	rm -rf bin

$(BIN):
	mkdir -p $(BIN)

$(BIN)/%.o: %.cpp ovc2.h lightweightserial.h
	g++ $(CFLAGS) -c $< -o $@

$(OUT): $(OBJS)
	g++ $(OBJS) $(LDFLAGS) -o $(OUT)

run: $(OUT)
	@echo "================================================="
	@$(OUT)
	@echo "================================================="
