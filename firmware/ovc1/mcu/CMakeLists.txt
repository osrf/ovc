set(CMAKE_TOOLCHAIN_FILE "stm32l4-toolchain.cmake")

cmake_minimum_required(VERSION 3.0.0)
project(enc)

if(NOT CMAKE_BUILD_TYPE)
  message(STATUS "Setting CMAKE_BUILD_TYPE to Debug explicitly")
  set(CMAKE_BUILD_TYPE Debug)
endif()

# More linker flags in toolchain file.
#set(CMAKE_EXE_LINKER_FLAGS "\
#  ${CMAKE_EXE_LINKER_FLAGS} \
#  -lc \
#  -lgcc \
#  -Wl,-Map=${CMAKE_CURRENT_BINARY_DIR}/map,--cref \
#  -L ${PROJECT_SOURCE_DIR}/common/linker \
#  -T ${PROJECT_SOURCE_DIR}/common/linker/application.ld \
#")
set(CMAKE_EXE_LINKER_FLAGS "\
  ${CMAKE_EXE_LINKER_FLAGS} \
  -Wl,-Map=${CMAKE_CURRENT_BINARY_DIR}/map,--cref \
  -T ${PROJECT_SOURCE_DIR}/common/stm32l452.ld \
")

set(app_addr_base 0x08000000)

set(openocd_preamble openocd -f interface/ftdi/olimex-arm-usb-tiny-h.cfg -f interface/ftdi/olimex-arm-jtag-swd.cfg -f target/stm32l4x.cfg)

function(fw_add_executable stem)
  add_executable(${stem}.elf ${ARGN})
  target_link_libraries(${stem}.elf common m)
  add_custom_command(TARGET ${stem}.elf POST_BUILD
      COMMAND arm-none-eabi-objcopy -O binary ${stem}.elf ${stem}.bin
      COMMENT "creating ${stem}.bin")
  add_custom_command(TARGET ${stem}.elf POST_BUILD
      COMMAND arm-none-eabi-objdump -S -d ${stem}.elf > ${stem}.objdump
      COMMENT "disassembling ${stem}.elf")
  add_custom_target(${stem}.flash_swd
      DEPENDS ${stem}.elf
      COMMAND ${openocd_preamble} -c "init; halt; cortex_m maskisr on; sleep 100; flash write_image erase ${stem}.bin ${app_addr_base}; verify_image ${stem}.bin ${app_addr_base}; cortex_m maskisr off; sleep 100; reset run; sleep 100; shutdown"
      VERBATIM)
  add_custom_target(${stem}.gdb_server
      COMMAND ${openocd_preamble} -c "init; halt"
      VERBATIM)
  add_custom_target(${stem}.gdb
      DEPENDS ${stem}.elf
      COMMAND arm-none-eabi-gdb ${stem}.elf -x ${PROJECT_SOURCE_DIR}/common/gdb_init_commands
      VERBATIM)
  add_custom_target(${stem}.flash_usb
      DEPENDS ${stem}.elf
      COMMAND dfu-util -d 0483:df11 --dfuse-address ${app_addr_base} -a 0 -D ${stem}.bin
      VERBATIM)
endfunction()

add_custom_target(reset
  COMMAND ${openocd_preamble} -c "init; sleep 100; halt; sleep 100; reset run; sleep 100; shutdown"
  VERBATIM)

add_custom_target(mass_erase
  COMMAND ${openocd_preamble} -c "init; sleep 100; halt; sleep 100; stm32l4x mass_erase 0; shutdown"
  VERBATIM)

include_directories(../common)
include_directories(common)
include_directories(common/stm32)

add_subdirectory(common)
add_subdirectory(blink)
add_subdirectory(hello)
add_subdirectory(jetcam)
add_subdirectory(test_pcierst)
