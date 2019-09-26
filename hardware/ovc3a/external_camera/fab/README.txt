PCB fabrication notes
====
 * 6 layers
 * rectangular, 138mm x 30mm
 * 1.6mm finished thickness
 * black soldermask
 * minimum via size 0.3556mm (14mil), minimum via drill 0.1524mm (6mil)
 * minimum trace/space 0.102mm (4mil) due to BGA fanout.

Assembly notes:
====
 * SMT both sides. Minimum passives 0402. Two BGA's with ~0.65 x 0.55mm pitch
 * otherwise, all legged IC packages: TSSOP, SOIC, etc.
 * FFC connector on bottom side
 * please ignore all parts with "Do Not Populate" (DNP) part numbers
 * DNP all through-hole parts, as shown in BOM
 * two non-populated module footprints: U1, U9. Do not apply solder paste.
