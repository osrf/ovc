MEMORY
{
  flash (rx) : ORIGIN = 0x08000000, LENGTH = 256K
  sram (rwx) : ORIGIN = 0x20000000, LENGTH =  64K
}

ENTRY(dummy_reset_vector)

SECTIONS
{
  .text :
  {
    KEEP(*(.vectors .vectors.*))
    . = 0x200; /* make it obvious when the vector table is missing */
    *(.text .text.* .gnu.linkonce.t*)
    *(.glue_7)
    *(.glue_7t) 
    *(.rodata .rodata* .gnu.linkonce.r*)
    . = ALIGN(4);
    KEEP(*(.init))
    . = ALIGN(4);
    __preinit_array_start = .;
    KEEP(*(.preinit_array*))
    __preinit_array_end = .;
    . = ALIGN(4);
    __init_array_start = .;
    KEEP(*(SORT(.init_array.*)))
    KEEP(*(.init_array*))
    __init_array_end = .;
    . = ALIGN(4);
    KEEP(*(.fini))
    . = ALIGN(4);
    __fini_array_start = .;
    KEEP(*(SORT(.fini_array.*)))
    KEEP(*(.fini_array))
    __fini_array_end = .;
    . = ALIGN(0x4);
    KEEP (*crtbegin.o(.ctors))
    KEEP (*(EXCLUDE_FILE (*crtend.o) .ctors))
    KEEP (*(SORT(.ctors.*)))
    KEEP (*crtend.o(.ctors))

    . = ALIGN(0x4);
    KEEP (*crtbegin.o(.dtors))
    KEEP (*(EXCLUDE_FILE (*crtend.o) .dtors))
    KEEP (*(SORT(.dtors.*)))
    KEEP (*crtend.o(.dtors))
  } > flash
  . = ALIGN(4);

  .ARM.extab :
  {
    *(.ARM.extab* .gnu.linkonce.armextab.*)
  } > flash

  .ARM.exidx : 
  {
    __exidx_start = .;
    *(.ARM.exidx* .gnu.linkonce.armexidx.*)
    __exidx_end = .;
  } > flash
 

  _srelocate_flash = .;
  .relocate : AT(_srelocate_flash)
  {
    . = ALIGN(4);
    _srelocate = .;
    *(.ramfunc .ramfunc.*);
    *(.data .data.*);
    . = ALIGN(4);
    _erelocate = .;
  } > sram

  .bss (NOLOAD) :
  {
    . = ALIGN(4);
    _sbss = .;
    __bss_start__ = .;
    *(.bss .bss.*)
    *(COMMON)
    . = ALIGN(4);
    _ebss = .;
    __bss_end__ = .;
  } > sram

  .stack (NOLOAD):
  {
    . = ALIGN(8);
    KEEP(*(.stack .stack.*))
  } > sram

  . = ALIGN(4);
  _end = .;
}
