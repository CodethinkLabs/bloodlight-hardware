# Description

This is a test-bed for medical photoplethysmography (PPG).

The current design has 16 LED's and 4 Photodiodes covering multiple wavelengths
between visible light and near infrared (roughly 400nm-1600nm).


# Tools

You'll need KiCad 5 to view or modify the schematics/pcb.
For Ubuntu users I'd suggest using this PPA:
<https://launchpad.net/~js-reynaud/+archive/ubuntu/kicad-5>

If you wish to modify the schematics then you should install the latest symbols,
footprints and 3D models from git.

If you wish to send the board off for manufacturing or creat an accurate render
then you'll need the kicad-util tool which can be found here:
<https://gitlab.com/dren.dk/kicad-util>

# Generating a model for the case

In addition to the above tools, you will also need blender <https://www.blender.org/>.

## 1. Delete the faceplate

The faceplate is not required for the case and will only get in the way.

Using kicad 5, open up `bloodlight.pro`, then `bloodlight.kicad_pcb`.

Select and drag around the entire face plate to the right and delete it.

Then, click on the lines going from the main board to the faceplate and delete those, too.

## 2. Export the model to vrml

From the pcb viewer, do `File->export->VRML`, and ensure the output units are in mm.
The file should be named something like bloodlight.wrl

## 3. Convert the VRML to STL

Run `blender --background --python blender-wrl-to-stl.py -- bloodlight.wrl`
This will generate a board.stl in the same directory as bloodlight.wrl.

# Manufacture

## 1. Create Snap-offs

BloodLight is designed to be processed by the kicad-util panel tool.
This is required to create the mousebites and the 3D render will show errors
for if this step is not done.

To create the mousebites, run:
    java -jar kicadutil.jar pcb -f bloodlight.kicad_pcb panel

## 2. Generate Drills & Plots

To get the PCB itself made we need a collection of drill and plot files.

Open the "output.bloodlight.kicad_pcb" file generated in the first pass.
Click "File"->"Plot..."

Note that this dialog will output multiple files so it's best to create an
output directory (I usually call it "plots/") to so you can group them
later.

Click "Generate Drill Files..."
Click "Generate Drill File" in the dialog.
Close the drill dialog.
Click "Plot" to generate the plot files.
Close the dialog.

Open the output directory and create a zip file of all of the plots and
drill files. This zip file can be used at to generate the PCB.

## 3. Generate Pick & Place File

With the PCB file still open in kicad as in the previous step:
Click "File"->"Fabrication Outputs"->"Footprint Position (.pos) File..."
Set the output directory as above (I set it to "plots/").
Set the Format to CSV.

Note that we only care about the position file for the top of the board
as in this case we expect to hand assemble the bottom.

To apply the rotations to the placement file use the following command:
    patch plots/output.bloodlight-top-pos.csv placement.patch

Note that for any future changes to the design the rotation patch will
need to be updated accordingly, as desribed in the next section.

## 3.1. Manually Fix Pick & Place File

Open the resulting file(s) using either a spreadsheet program or a text editor.

JLCPCB expects the fields to be titled differently to KiCAD, so we have to
modify the titles as follows:
"Ref" -> "Designator"
"PosX" -> "MidX"
"PosY" -> "MidY"
"Rot" -> "Rotation"
"Side" -> "Layer"

This position file needs fixing because kicad and JLCPCB's tooling
disagree on the default rotation for some part.

To ensure the rotations are correct upload your design JLCPCB.com and view their
rendered output to check the part rotations are correct and manually fixup where
they are incorrect.

## 4. Generate the BOM

We store the BOM in the SYLK format so that the equations for costing and
pin count are saved while keeping everything in a text based format.

JLCPCB expect the BOM to be in CSV format, the easiest way to achieve this
is to open the BOM.SYLK file in a graphical spreadsheet program such as
LibreOffice Calc and save the file as BOM.CSV.

## 5. Order from JLCPCB

In order to get an estimate for assembly you'll need a login, I'd highly
suggest using google to log in to JLCPCB prior to beginning the process.

Navigate to: https://jlcpcb.com/
Click on "Quote Now"

Click "Add your gerber file" and upload the zip file created in step 2.

Select the "PCB Qty" which will set the maximum number of assembled boards.
The default and cheapest option is 5, but 10 costs very little more.

Select the "Surface Finish" as "ENIG-RoHS", other surface finishes are
cheaper but ENIG gives a flatter surface to solder to, doesn't go off
and is likely safest for against skin.
HASL (with lead) is cheapest and is legal for prototyping in the EU but
it's not advisable as this device will be used for prolonged periods
against skin.

I'm selecting "Yes/JLC7628" for "Impedance", unsure as to whether this
matters particularly but my assumption is that by picking one we make
the process more reproducible.

For assembly 1.6mm Green is recommended, the rest of the options should be
unchanged as they're unlikely to have an important impact.

Select "SMT Assembly" and click "Assemble top side".

For SMD QTY we can select either the number of boards or 2, select as
appropriate.

Select "DHL Express Priority (DDP)" for shipping estimate to get a cost
estimate which is realistic. There's likely to be an additional £10 fee
from DHL (or any other carrier) for the delivery if not ordered via a
business account.

Click "Confirm".

Click "Add BOM File" and add the BOM.csv file generated in step 4.
Click "Add CPL File" and add the *-top.csv file generated in step 3.

Click "Next".

You should now see a screen where each assembled part is listed, do a
quick check to ensure that all parts marked "Assembled" in the BOM are
present in the list.

Click "Next".

Check on this screen using the graphical tool that all parts are placed
correctly and as expected, if a part is incorrecly rotated then the
rotation patch will need changing and the CPL file will need updating.

Once you're happy with this, click "SAVE TO CART", the rest of the
ordering process is straight-forward and self-explanatory.

