BIN=bin
NAME=ovc
OUT=$(BIN)/$(NAME)
default: $(OUT).vvp
#MODULES=cmd_rx
MODULES=r s sim_clk d1 d4 dn oneshot gmux hmux ffifo \
        spi_master \
				reg_ram_iface \
        python_decoder trigger \
				imu_reader imu_reg_reader imu_host_spi \
				signature crc32 \
				wnd ram_512x32 ast_7x7 ast_mask max \
				corners ast_detector \
				timestamp image_stats \
				dma_writer dma_writer_mux metadata
SRCS=top.v $(MODULES:%=%.v)
SYNTH_SRCS=top_wrapper.v
SIM_SRCS=top_tb.v sim_python.v sim_imu.v sim_imu_ram.v sim_reg_ram.v
INTEGRATION_TESTS=corners corners_nonmax corners_image
QUARTUS_PATH ?= bogus____please_set_QUARTUS_PATH______have_a_nice_day
QUARTUS_SIM_FLAGS = $(QUARTUS_PATH)/quartus/eda/sim_lib/altera_mf.v $(QUARTUS_PATH)/quartus/eda/sim_lib/220model.v -I $(QUARTUS_PATH)/quartus/eda/sim_lib -y $(QUARTUS_PATH)/quartus/libraries/megafunctions
QUARTUS_BIN=$(QUARTUS_PATH)/quartus/bin

UNIT_TESTS=$(MODULES:%=test_%)
INTEGRATION_TEST_TARGETS=$(INTEGRATION_TESTS:%=itest_%)

default: $(OUT).lxt 

$(BIN):
	mkdir -p $(BIN)
	touch $@

clean:
	rm -rf bin

view: 
	gtkwave $(OUT).lxt

$(OUT).vvp: $(BIN) $(SRCS) $(SIM_SRCS)
	iverilog -Wall -DSIM -s top_tb -o $@ -I. $(QUARTUS_SIM_FLAGS) $(SRCS) $(SIM_SRCS)

$(OUT).lxt: $(OUT).vvp 
	cd $(BIN) && vvp -n ../$(OUT).vvp -lxt2

$(OUT).sdc: $(BIN) $(NAME).sdc
	cp $(NAME).sdc $@

$(OUT).autogen.tcl: $(BIN) $(NAME).tcl
	@echo "creating $@ ..."
	@echo "load_package flow" > $@
	@echo "project_new $(NAME) -overwrite" >> $@
	@echo "source \"../$(NAME).tcl\"" >> $@
	@echo "set_global_assignment -name TOP_LEVEL_ENTITY top_wrapper" >> $@
	@echo "set_global_assignment -name SEARCH_PATH $(PWD)" >> $@
	@echo "set_global_assignment -name SEARCH_PATH $(PWD)/$(BIN)/$(NAME)_qsys/synthesis" >> $@
	@for src in $(SRCS) $(SYNTH_SRCS); do \
		echo "set_global_assignment -name VERILOG_FILE $$src" >> $@; \
	done
	#@echo "puts \"about to compile...\"" >> $@
	@echo "execute_flow -compile" >> $@
	#@echo "quartus_map $(NAME) --source=$(NAME)_wrapper.v --family=\"Cyclone V\"" >> $@
	#@echo "puts \"done with compile...\"" >> $@
	@echo "project_close" >> $@
	@echo "done creating $@"

$(BIN)/$(NAME)_qsys: $(NAME)_qsys.qsys
	cp $(NAME)_qsys.qsys $(BIN)/$(NAME)_qsys.qsys
	cd $(BIN) && $(QUARTUS_PATH)/quartus/sopc_builder/bin/qsys-generate $(NAME)_qsys.qsys --synthesis=VERILOG --output-directory=$(PWD)/$(BIN)/$(NAME)_qsys --family="Cyclone V" --part=5CGTFD5C5U19C7

synth: Makefile $(BIN) $(BIN)/$(NAME)_qsys $(OUT).autogen.tcl $(OUT).sdc
	cd $(BIN) && $(QUARTUS_BIN)/quartus_sh -t $(NAME).autogen.tcl
	cd $(BIN) && $(QUARTUS_BIN)/quartus_cpf -c ../ovc.cof

$(OUT).timing.tcl: $(BIN) $(NAME).timing.tcl $(OUT).sdc
	cp $(NAME).timing.tcl $@

timing: $(OUT).timing.tcl
	cd $(BIN) && $(QUARTUS_BIN)/quartus_sta -t $(NAME).timing.tcl

# todo: decent dependencies
deploy: 
	#$(QUARTUS_PATH)/quartus_pgm -z -m JTAG -o "p;$(BIN)/$(NAME).sof"
	scp bin/output_files/ovc.*.rbf nvidia@ovc:~
	#ssh nvidia@tegra-ubuntu.local 'opencam/software/mcu_cli/bin/mcu_cli flash_fpga_image ovc.periph.rbf'
	#ssh nvidia@tegra-ubuntu.local 'opencam/software/mcu_cli/bin/mcu_cli configure_fpga'
	#ssh nvidia@tegra-ubuntu.local 'sudo rmmod ovc && sudo rmmod pci_tegra && sudo modprobe pci_tegra'

$(UNIT_TESTS): test_%: %.v
	iverilog -Wall -Dtest_$* -DSIM -s $*_tb -o $(BIN)/$@.vvp -I . -y. $(QUARTUS_SIM_FLAGS) -y . $<
	cd $(BIN) && vvp -n $@.vvp -lxt2

$(INTEGRATION_TEST_TARGETS): itest_%: %_tb.v
	iverilog -Wall -Ditest_$* -DSIM -s $*_tb -o $(BIN)/$@.vvp -I . -y. $(QUARTUS_SIM_FLAGS) -y . $<
	cd $(BIN) && vvp -n $@.vvp -lxt2
