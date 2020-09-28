# README

The source for the bloodlight case is in the OpenSCAD language, and the
[OpenSCAD][1] software is required to render them.

## Previewing
To render a preview of the 3D model, open the file `case.scad` in OpenSCAD, and
ensure the function `render_whole_assembly()` is being called. OpenSCAD is
similar to languages such as Python in that any unscoped code is executed.

If a 3D model of the circuit board is available in the parent directory with the
name `board.stl` this will be rendered as part of the preview.

## Printing
To create a 3D printable model, ensure the only unscoped function being called
is `render_top_bottom_side_by_side()` - this will render the top and bottom of
the case separately  and in an orientation which should be better suited to
printing. Now press F6 or the "render" button to perform a full render of the
parts (by default a more simplistic preview is rendered.) Once the render -
which may take some time - is complete, in the top menu go to `File -> Export ->
Export as STL` and save the file. This format should be appropriate for use in
3D printing programs.


[1]: https://www.openscad.org/