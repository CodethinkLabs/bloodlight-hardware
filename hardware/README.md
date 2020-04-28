# Description

This is a test-bed for medical photoplethysmography (PPG).

The current design has 16 LED's and 4 Photodiodes covering multiple wavelengths
between visible light and near infrared (roughly 400nm-1600nm).

# Tools

You'll need KiCad 5 to view or modify the schematics/pcb.
For Ubuntu users I'd suggest using this PPA: <https://launchpad.net/~js-reynaud/+archive/ubuntu/kicad-5>

If you wish to modify the schematics then you should install the latest symbols, footprints and 3D models from git.

# Manufacture

BloodLight is designed to be processed by the kicad-util panel tool.
This is required to create the mousebites and the 3D render will show errors
for if this step is not done.

To create the mousebites, run:
    java -jar kicad-util.jar pcb -f bloodlight.kicad_pcb panel

