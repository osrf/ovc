PCB fabrication notes
====
 * 6 layers
 * rectangular, 98mm x 97mm
 * 1.6mm finished thickness
 * minimum via size 14mil, minimum via drill 6mil. Most are larger.
 * minimum trace/space 5mil. Most are larger.
 * differential pairs:
    * Need 90 ohm impedance +/- 10% on pairs 6mil thick with 7mil spacing (USB).
    * Need 100 ohm impedance +/- 10% on pairs 5mil thick with 6mil spacing (MIPI / Ethernet).
    * Please adjust stackup as needed to achieve this.
    * If impossible, let us know and we will adjust pair geometry as needed.

Assembly notes:
====
 * mostly top-side SMT with a few small bottom-side SMT parts
 * a few through-hole connectors
 * please ignore all parts with "Do Not Populate" (DNP) part numbers
 * CONN1, CONN2 are Hirose connectors placed underneath a
   daughtercard module with precise inter-part spacing, and thus were modeled
   in such a way that (unfortunately) they do not show up correctly in the
   XY pos file. Let us know if this presents a problem and we'll figure
   something out. All other parts should have correct XY placement data.
