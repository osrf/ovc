List of fixes and improvements for revB
======================================
BOM only
--------
LTM4622
*******
- Change LTM4622 input capacitor to 10V rated ones
   - replace in BOM input capacitors: C2, C47, C67, (C1608X5R0J106K080AB with C1608X5R1A106K080AC) DONE
   - replace TRACK/SS capacitors with smaller ones: C1 C3 C44 C48 C66 C68 (10n? 0402 C1005X7R1C103K050BA) DONE

PCB Modification required
-------------------------
FX3:
****
- Add RC (~5.5ms because power supplies take 4.2ms to come up) DONE
Tantalum Bulk Capacitors
***********************
- Change footprint of tantalum capacitors to display polarization DONE
biker-gang connector
****
- try to increase clearance around J5, since the receptacle will have a slightly larger footprint than the header. This may be impossible, but if it's possible to move C48 to the bottom side, that would help. Otherwise we could replace C48 with an 0201 size so that hopefully it won't interfere with the receptacle.
