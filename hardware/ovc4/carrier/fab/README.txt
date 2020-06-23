PCB fabrication notes
====
 * 6 layers
 * black soldermask both sides
 * white silkscreen both sides
 * rectangular, 95mm x 73mm
 * 1.6mm finished thickness
 * minimum via size 18mil, minimum via drill 8mil.
 * minimum trace/space 4mil. Most are larger.
 * differential pairs (USB / MIPI / Ethernet):
    * Need 90 ohm impedance +/- 10% on pairs 7mil thick with 8mil spacing.
    * Please adjust stackup as needed to achieve this.
    * If impossible, let us know and we will adjust pair geometry as needed.

Assembly notes:
====
 * mostly top-side SMT with a few big SMT connectors in the bottom
 * a few through-hole connectors
 * please ignore all parts with "Do Not Populate" (DNP) part numbers
