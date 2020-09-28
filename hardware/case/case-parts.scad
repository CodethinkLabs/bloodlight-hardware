
// difference this into something to create the appropriate sized hole for
// an m2 to pass through
module passthrough_screw_hole_m2()
{
	cylinder(d=2.2, h=2, center=true, $fn=30);
}

// difference this at the edge of a passthrough for countersunk screws to sit
// flush with the edge of the case
module countersunk_screw_passthrough_m2()
{
	cylinder(d1=3.5, d2=2.2, h=1, center=true, $fn=30);
}

// a profile of a tapping hole for an m2 screw to screw into for mounting
module screw_tap_m2()
{
	difference()
	{
		cylinder(d=4, h=2, center=true, $fn=30);
		cylinder(d=1.6, h=2.2, center=true, $fn=30);
	}
}

// a profile of a tapping hole for an m2 screw to screw into for mounting
// when 3d printing - we don't use self tapping screws so we just have a
// friction fit with larger holes
module screw_tap_m2_for_printing()
{
	difference()
	{
		cylinder(d=4, h=2, center=true, $fn=30);
		cylinder(d=1.95, h=2.2, center=true, $fn=30);
	}
}

// a "smooth" opening that tries to blend with the edge it opens towards
// difference into something to make the hole
module smooth_hole()
{
	rotate_extrude($fn=20,angle=360)
	{
		difference()
		{
			square(size=[2, 2], center=false);
			translate([2, 1.02, 0])
				circle($fn=30, r=1);
			translate([1, 0.96, 0])
				square(size=[2, 2], center=false);
		}
	}
}
