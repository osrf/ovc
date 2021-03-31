BIN=bin
NAME=ovc2a
OUT=$(BIN)/$(NAME)
default: $(OUT).vvp
#MODULES=cmd_rx
MODULES=r s d1 d4 dn timestamp reg_ram_iface spi_master gmux hmux oneshot imu_reader trigger imu_reg_reader dma_writer dma_writer_mux python_decoder ast_detector metadata signature crc32 image_stats wnd ast_7x7 ast_mask max ram_512x32
SRCS=top.v $(MODULES:%=%.v)
SYNTH_SRCS=top_wrapper.v
SIM_SRCS=top_tb.v sim_python.v sim_imu.v sim_imu_ram.v sim_reg_ram.v sim_clk.v
INTEGRATION_TESTS=cam_spi corners corners_nonmax corners_image imu_autopoll
QUARTUS_PATH ?= bogus____please_set_QUARTUS_PATH______have_a_nice_day
QUARTUS_SIM_FLAGS = $(QUARTUS_PATH)/quartus/eda/sim_lib/altera_mf.v $(QUARTUS_PATH)/quartus/eda/sim_lib/220model.v -I $(QUARTUS_PATH)/quartus/eda/sim_lib -y $(QUARTUS_PATH)/quartus/libraries/megafunctions
QUARTUS_BIN=$(QUARTUS_PATH)/quartus/bin
PLATFORM_IP=pcie pcie_clock_bridge pio_output pio_input platform_clock_in cam_lvds_rx cam_pll ovc2_gpio reg_ram imu_ram irq_bridge

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
	@echo "set_global_assignment -name SEARCH_PATH $(PWD)/$(BIN)/platform/synthesis" >> $@
	@for src in $(SRCS) $(SYNTH_SRCS); do \
		echo "set_global_assignment -name VERILOG_FILE $$src" >> $@; \
	done
	@for ip_name in $(PLATFORM_IP); do \
	  echo "set_global_assignment -name QIP_FILE $$ip_name/$$ip_name.qip" >> $@; \
	  echo "set_global_assignment -name IP_FILE $$ip_name.ip" >> $@; \
	done
	#@echo "puts \"about to compile...\"" >> $@
	@echo "execute_flow -compile" >> $@
	#@echo "quartus_map $(NAME) --source=$(NAME)_wrapper.v --family=\"Cyclone V\"" >> $@
	#@echo "puts \"done with compile...\"" >> $@
	@echo "project_close" >> $@
	@echo "done creating $@"

$(BIN)/platform: platform.qsys
	cp platform.qsys $(BIN)/platform.qsys
	@for ip_name in $(PLATFORM_IP); do \
		cp ip/$$ip_name.ip $(BIN) && \
	  cd bin && $(QUARTUS_PATH)/quartus/sopc_builder/bin/qsys-generate $(PWD)/$(BIN)/$$ip_name.ip --synthesis=VERILOG --family="Cyclone 10 GX" --part=10CX220YF672E6G && cd ..; \
	done
	cd $(BIN) && $(QUARTUS_PATH)/quartus/sopc_builder/bin/qsys-generate platform.qsys --synthesis=VERILOG --family="Cyclone 10 GX" --part=10CX220YF672E6G
	#mkdir -p $(BIN)/ip/platform/$$ip_name && \
	#ip/$$ip_name.ip $(BIN)/ip/platform/$$ip_name.ip && cd $(BIN) && \

synth: Makefile $(BIN) $(BIN)/platform $(OUT).autogen.tcl $(OUT).sdc
	cd $(BIN) && $(QUARTUS_BIN)/quartus_sh -t $(NAME).autogen.tcl
	cd $(BIN) && $(QUARTUS_BIN)/quartus_cpf -c ../ovc2a.cof

$(OUT).timing.tcl: $(BIN) $(NAME).timing.tcl $(OUT).sdc
	cp $(NAME).timing.tcl $@

timing: $(OUT).timing.tcl
	cd $(BIN) && $(QUARTUS_BIN)/quartus_sta -t $(NAME).timing.tcl

# todo: decent dependencies
deploy: 
	scp bin/output_files/*.rbf nvidia@ovc2a3:~
	#ssh nvidia@tegra-ubuntu.local 'sudo rmmod ovc && sudo rmmod pci_tegra && sudo modprobe pci_tegra'

$(UNIT_TESTS): test_%: %.v
	iverilog -Wall -Dtest_$* -DSIM -s $*_tb -o $(BIN)/$@.vvp -I . -y. $(QUARTUS_SIM_FLAGS) -y . $<
	cd $(BIN) && vvp -n $@.vvp -lxt2

$(INTEGRATION_TEST_TARGETS): itest_%: tests/%_tb.v tb.v
	iverilog -Wall -Ditest_$* -DSIM -s $*_tb -o $(BIN)/$@.vvp -I . -y. $(QUARTUS_SIM_FLAGS) -y . $<
	cd $(BIN) && vvp -n $@.vvp -lxt2
