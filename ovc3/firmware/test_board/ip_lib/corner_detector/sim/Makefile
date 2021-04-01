BIN=bin
NAME=corner_detector_tb
OUT=$(BIN)/$(NAME)
MODULES=r s d1 dn hmux ast_detector wnd ast_7x7 ast_mask max ram_512x32
SHARED_SRCS=$(MODULES:%=../src/%.v)
SIM_SRCS=top_tb.v sim_python.v sim_clk.v shallow_fifo.v
XILINX_VIVADO ?= bogus___please_set_XILINX_VIVADO_____have_a_nice_day
VIVADO_SIM_FLAGS=$(XILINX_VIVADO)/data/verilog/src/glbl.v -y $(VIVADO_PATH)/data/verilog/src/unisims

default: $(OUT).lxt

$(BIN):
	mkdir -p $(BIN)
	touch $@

clean:
	rm -rf bin

view: 
	gtkwave $(OUT).lxt

$(OUT).vvp: $(BIN) $(SHARED_SRCS) $(SIM_SRCS)
	iverilog -Wall -DSIM -s top_tb -s glbl -o $@ -I. -y. -y../src $(VIVADO_SIM_FLAGS) top_tb.v

$(OUT).lxt: $(OUT).vvp 
	cd $(BIN) && vvp -n ../$(OUT).vvp -lxt2
