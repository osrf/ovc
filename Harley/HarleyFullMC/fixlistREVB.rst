List of fixes and improvements for revB
======================================
BOM only
--------
LTM4622
*******
- Change LTM4622 input capacitor to 10V rated ones
   - replace in BOM input capacitors: C2, C47, C67, (C1608X5R0J106K080AB with C1608X5R1A106K080AC) DONE
   - replace TRACK/SS capacitors with smaller ones: C1 C3 C44 C48 C66 C68 (10n? 0402 C1005X7R1C103K050BA)

PCB Modification required
-------------------------
FX3:
****
- Add RC (~1ms or maybe more to be sure every rail is setup ?) to FX3 reset circuitry: 0201 10k and 100n should be good DONE
  - maybe add only a pullup resistor and see how it goes?
Tantalum Bulk Capacitors
***********************
- Change footprint of tantalum capacitors to display polarization DONE

