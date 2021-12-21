use<hardware.scad>
use<parts.scad>
use<electronic.scad>
use<raspberrypi.scad>

$fn = 50;
//a = ($t < 0.5) ? ($t * 4 - 1.0) : (1.0 - ($t - 0.5) * 4);
a = 0;

module servox(angle = 0, solid_holes) 
{
    servo("simple", "double", angle, solid_holes);
}

module arm(angle = 45, joint_only = false)
{
    rotate([angle, 0, 0])
    {
        translate([0.01, 0, 0]) rotate([0, 90, 180]) servox(angle = angle);
        
        if (!joint_only) difference()
        {
            translate([-1.535, 0, 0])
            {
                hull()
                {
                    translate([0, 0, 0.5]) rotate([0, 90, 00]) cylinder(d = 2, h = 1);
                    translate([0, 0, -2]) rotate([0, 90, 00]) cylinder(d = 1.5, h = 1);
                    translate([0, -0.5, -4]) rotate([0, 90, 00]) cylinder(d = 1, h = 1);
                }
            }
            
            translate([0.01, 0, 0]) rotate([0, 90, 180]) servox(angle = angle, solid_holes = 1);
        }
    }
}

module shoulder_part1(length = 3, shape = 0, solid_hole = 0)
{
    if (solid_hole == 0) {
        difference() {
            union() {
                cube([1, length - 0.5, 0.3]);
                translate([0.25, length - 0.5, 0]) cube([0.5, 0.5, 0.3]);
            }
            translate([0.5, length - 0.25, -0.1]) cylinder(d = 0.31, h = 0.5);
            if (shape == 0) {
                translate([0.5, 0.5, -2.75 + 3.19]) servox(angle = 0, solid_holes = 1);
            } else {
                translate([0.5, 0.5, -2.75]) servox(angle = 0, solid_holes = 1);
            }
        }
    } else {
        translate([0.25, length - 0.6, 0]) cube([0.5, 0.7, 0.4]);
        translate([0.35, length - 0.6, -0.3]) cube([0.31, 0.7, 0.7]);
        translate([0.2, length - 0.6, -0.5]) cube([0.6, 0.7, 0.3]);
    }
}

module shoulder_part2(length = 3)
{
    difference() {
        translate([0, 0, -0.3]) cube([1, 0.5, length + 0.6]);
        translate([0, -2.5, length]) shoulder_part1(3, 0, 1);
        translate([1, -2.5, 0]) rotate([0, 180, 0]) shoulder_part1(3, 0, 1);
    }
    translate([-length / 2 + 0.5, 0, length / 2 + 0.5]) rotate([0, 90, 0]) difference() {
        translate([0, 0, -0.3]) cube([1, 0.5, length + 0.6]);
        translate([0, -2.5, length]) shoulder_part1(3, 0, 1);
        translate([1, -2.5, 0]) rotate([0, 180, 0]) shoulder_part1(3, 0, 1);
    }
}

module shoulder(angle = [0, 0], length = 3)
{
    translate([0, 0, 0.01]) servox(angle = angle[0]);
    
    rotate([0, 0, angle[0]])
    {
        translate([-0.5, length - 1, -0.1]) shoulder_part2(2.85);
        translate([-0.5, -0.5, 2.75]) shoulder_part1(length, 1);
        translate([-0.5, -0.5, -0.4]) shoulder_part1(length, 0);
        translate([-2.85/2 - 0.3, length - 1, (2.85 - 1)/2 - 0.1]) translate([0, length, 0]) rotate([180, -90, 0]) shoulder_part1(length, 1);
        translate([2.85/2, length - 1, (2.85 - 1)/2 - 0.1]) translate([0, length, 0]) rotate([180, -90, 0]) shoulder_part1(length, 0);
        translate([2.85/2 - 0.1, length * 2 - 1.5, 2.85/2 - 0.1]) arm(angle = angle[1]);
    }
}

module neck(angle = 0, length = 3)
{
    rotate([180, 0, 0]) {
        translate([0, 0, 0.01]) servox(angle = angle + 90);
        
        rotate([0, 0, angle + 90])
        {
            translate([-0.5, length - 1, -0.1]) shoulder_part2(2.85);
            translate([-0.5, -0.5, 2.75]) shoulder_part1(length, 1);
            translate([-0.5, -0.5, -0.4]) shoulder_part1(length, 0);
        }
    }
}

module body_lower()
{
    difference() {
        union() {
            rcube([9, 6, 0.3], 0.5);
            translate([-1.1, 2, 0]) rcube([11.2, 2, 0.3], 0.5);
        }
        translate([1.6, 6 - 0.6, -1.25]) servox(solid_holes = 1);
        translate([7.4, 6 - 0.6, -1.25]) scale([-1, 1, 1]) servox(solid_holes = 1);
        translate([7.4, 0.6, -1.25]) scale([-1, -1, 1]) servox(solid_holes = 1);
        translate([1.6, 0.6, -1.25]) scale([1, -1, 1]) servox(solid_holes = 1);
    }
}

module body_upper()
{
    difference() {
        union() {
            rcube([9, 6, 0.3], 0.5);
            translate([-1.1, 2, 0]) rcube([11.2, 2, 0.3], 0.5);
        }
        translate([0, 3, 1.55]) rotate([180, 0, 0]) servox(angle = 90, solid_holes = 1);
    }
}

module battery()
{
    color("Red") cube([110, 34, 12]);
}

module spider() 
{
    translate([-4.5, -3, 1.25]) body_lower();
    translate([-4.5, -3, 3.25]) body_upper();
    translate([-2.9, 3 - 0.6, 0]) shoulder([45 * a + 30, 25 * a]);
    translate([2.9, 3 - 0.6, 0]) scale([-1, 1, 1]) shoulder([45 * a + 30, 25 * a]);
    translate([2.9, -3 + 0.6, 0]) scale([-1, -1, 1]) shoulder([45 * a + 30, 25 * a]);
    translate([-2.9, -3 + 0.6, 0]) scale([1, -1, 1]) shoulder([45 * a + 30, 25 * a]);
}

scale(10) spider();
translate([-45, 0, 48]) scale(10) neck(angle = 45 * a);
translate([-55, -17, 0.5]) battery();
translate([-16.5, -22, 66.8]) scale(10) servo_controller_24(true);
translate([-20, 24.5, 43.75]) raspberrypi_hat(true);
translate([-20, 24.5, 43.75]) raspberrypi("A", true);