use <case-parts.scad>
include <codethink-logo-def.scad>

// dimensions of the box footprint in mm
box_x = 33;
box_y = 83;

// clearance required for components on the top and bottom of the board in mm
board_top_clearance = 2.65;
board_bottom_clearance = 1.8;

// imported 3d for the board, with some boxes thrown on for spacing and placing.
// some of the 3d components might not be quite accurate on this render but
// should be ok for spacing
module board()
{
	translate([-136, 133, 0])
	{
		color("green")
			import("../board.stl");
	}
	translate([10,10,1.6])
	{
		cube([5,5,board_top_clearance]);
	}
}

// basic shape of the top of the case
module case_top_base()
{
	translate([box_x/2 - 5, box_y/2 - 5,0])
	{
		// easiest to just use hard coded dimensions here as this
		// is the base shape and we don't care too much about warping
		// form resizing
		resize([box_x, box_y, 2])
		{
			minkowski()
			{
				cube([box_x, box_y, 1], center=true);
				// expands the footprint of the cube by 5 in all directions
				// due to minkowski summing
				cylinder($fn=30, r1=5, r2=3, h=1, center=true);
			}
		}
	}
}

// a "flattened" version of the case top used for extrudes
module case_top_shape()
{
	projection()
		case_top_base();
}

// holes shape for the top of the case to go in the corners for the screws to
// tap into
module screw_corner_tap()
{
	union()
	{
		difference()
		{
			// get a corner profile of the case shape by "picking" a square
			// area with an intersection
			intersection()
			{
				translate([0.1,0.1,-1])
					linear_extrude(height = 2)
						case_top_shape();
				translate([-10,-10,-1.5])
					cube(11.8);
			}
			// trim some off
			translate([0,0,-1.5])
				cube(5);
			// cut the shape of the hole tap into it
			scale([1,1,1.5])
			{

				hull()
				{
					screw_tap_m2_for_printing();
				}

			}
		}
		// change to screw_tap_m2 for non-3d printed when self-tapping
		// screws need to be used
		screw_tap_m2_for_printing();
	}
}

// slits to go at the side of the case that allow a 75mm wide strap to pass
// through
module strap_wing()
{
	difference()
	{
		intersection()
		{
			linear_extrude(height = 5)
				case_top_shape();
			translate([-10,-10,-1.5])
				cube([15,90,5]);
		}
		translate([-3,0,-1])
			cube([20,75,7]);
	}
}

// hole shape for the top of the case to go on the edge for the screw to tap
// into
module screw_edge_tap()
{
	union()
	{
		difference()
		{
			intersection()
			{
				translate([0,-4,-1])
					linear_extrude(height = 2)
						case_top_shape();
				translate([-4,-2,-1.5])
					cube(4);
			}
			translate([0,0,-1.5])
				cube(5);
			scale([1,1,1.5])
			{
				hull()
				{
					screw_tap_m2_for_printing();
				}
			}
		}
		screw_tap_m2_for_printing();
	}
}

// the top/lid of the case, which includes the side walls and mounting points
// for the board
module case_top()
{
	union()
	{
		// top of the top
		difference()
		{
			color("yellow")
				case_top_base();
			// status LED hole
			translate([8,63.6,-2])
				cube([2,1,5]);
		}

		// extrude the footprint of the top, then cut into it with a scaled
		// version to make the outer wall of the case
		translate([0, 0, -11])
		{
			difference()
			{
				union()
				{
					linear_extrude(height = 10.5)
						case_top_shape();
					translate([-5, -2.15, 6])
						scale([1, 0.57, 1])
							strap_wing();
					translate([28, -2.15, 9.5])
						rotate([0,180,0])
							scale([1, 0.57, 1])
								strap_wing();
				}
				
				translate([0, 0, -2])
				{
					linear_extrude(height = 13)
						offset(r = -1.5)
							case_top_shape();
				}
				// do  the connector holes while we're diffing
				// usb and debug
				translate([5.5, 70, 3.2])
				{
					cube([20, 15, 7]);
				}
				// spi
				translate([5, 42.5, 3.50001])
				{
					cube([40, 17, 5]);
				}
				// and some venting holes
				for (i = [0:5])
				{
					translate([-10, 14 +(i * 10), 4])
					{
						cube([50, 5, 2]);
					}
				}
			}
		}
		// screw fixings
		color("blue")
		{
			// bottom left screw tap
			translate([0,0,-4])
				scale([1,1,3.3])
					screw_corner_tap();
			// bottom right screw tap
			translate([23,0,-4])
				rotate([0,0,90])
					scale([1,1,3.3])
						screw_corner_tap();
			// top left screw tap
			translate([0,72.9,-4])
				rotate([0,0,270])
					scale([1,1,3.3])
						screw_corner_tap();
			// top right screw tap
			translate([23,61.5,-4])
				scale([1,1,3.3])
					rotate([0,0,180])
						screw_edge_tap();
		}
		// micro-usb adapter support
		translate([10.2,71.5,-5.6])
			rotate([0,-90,180])
				linear_extrude(2.6)
					polygon([[0,0], [0,1], [5,5], [5,0]]);
		// guidance cuboid to indicate where the back of the micro-usb connector is
		//color("orange")
		//	translate([10.2,71.5,-5.6])
		//		cube([2.6,1,1]);

		translate([11, 30, 0.9])
		{
			rotate([0,0,90])
				linear_extrude(height=0.6, convexity=1)
					codethink();
		}
	}
}

// the bottom of the case, with screw passthrough holes for screwing to the top
// (through the board) and cutouts for the LEDs/sensors
// should sit flush with the board due the large the LED/sensor holes
module case_bottom()
{
	// Screws in the holes to check countersinking
	/*
	color("red")
	{
		translate([0, 0, 0])
			screw_m2();
		translate([23, 0, 0])
			screw_m2();
		translate([0,72.9, 0])
			screw_m2();
		translate([23, 61.5, 0])
			screw_m2();
	}
	*/
	difference()
	{
		linear_extrude(height = 2)
			offset(r = -1.5)
				case_top_shape();

		// bottom left screw hole
		translate([0,0,0])
		{
			translate([0,0,0.6])
				countersunk_screw_passthrough_m2();
			scale([1,1,2.5])
				passthrough_screw_hole_m2();
		}
		// bottom right screw hole
		translate([23,0,0])
		{
			translate([0,0,0.6])
				countersunk_screw_passthrough_m2();
			scale([1,1,2.5])
				passthrough_screw_hole_m2();
		}
		// top left screw hole
		translate([0,72.9,0])
		{
			translate([0,0,0.6])
				countersunk_screw_passthrough_m2();
			scale([1,1,2.5])
				passthrough_screw_hole_m2();
		}
		// top right screw hole
		translate([23,61.5,0])
		{
			translate([0,0,0.6])
				countersunk_screw_passthrough_m2();
			scale([1,1,2.5])
				passthrough_screw_hole_m2();
		}
		// led and sensor holes
		for (i = [0:2])
		{
			translate([4 + (i * 7.5),14.5,-0.1])
			{
				// scale the whole thing because scaling the cube in the
				// z direction gives us an undesired shape
				scale([1,1,1.2])
				{
					minkowski()
					{
						// remember minkowski sums the sizes so we need to have
						// some fiddly values here to get a nice shape
						cube([3.75,26,0.1], center=true);
						smooth_hole();
					}
				}
			}
		}

		// text
		/*translate([10, 65, 0.1])
		{
			rotate([0,180,90])
			{
				linear_extrude(height = 1)
				{
					text("Designed by Codethink in Manchester",1);
					translate([0,-2,0])
						text("Assembled wherever",1);
				}
			}
		}*/
	}
}

// render the entire assembly as it should be when put together
module render_whole_assembly()
{
	translate([0,0,-8.1])
		board();
	translate([2.5,2.5,0])
		color([1,1,1,0.5])
			case_top();
	translate([2.5,2.5,-11])
		case_bottom();
}

// render the top and bottom side by side ready for printing
module render_top_bottom_side_by_side()
{

	translate([10,5,11])
			case_top();
	translate([75,4,2])
		// render "upside down" for printng
			rotate([0,180,0])
				case_bottom();
}

render_top_bottom_side_by_side();
