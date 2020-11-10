# usage: blender --background --python <this file> -- [input_filename]
import sys
import os
import bpy
argv = sys.argv[sys.argv.index("--") + 1:] # ignore args to blender

assert argv, "No arguments passed to script"
assert argv[0], "No filename argument passed"
parent_dir = os.path.dirname(argv[0])
output_path = os.path.join(parent_dir, "board.stl")
bpy.ops.import_scene.x3d(filepath=os.path.abspath(argv[0]), axis_up="Z", axis_forward="Y")
for obj in bpy.data.objects:
    if obj.name in ("Camera", "Cube", "Lamp"):
        obj.select = False
    else:
        obj.select = True # some versions use obj.select_set(True)
bpy.ops.export_mesh.stl(filepath=output_path, use_selection=True)
