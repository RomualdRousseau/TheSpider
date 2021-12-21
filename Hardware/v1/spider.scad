use<hardware.scad>
use<parts.scad>
use<electronic.scad>
use<arduino.scad>

$fn = 50;

module servox(horn = "simple", angle = 0, axis = "double", hole = false) 
{
    if(hole) {
        translate([-0.6, -0.6, -0]) servo(hole = true);
    }
    else {
        translate([-0.6, -0.6, 0]) servo(horn, angle);
        if(axis == "double")
        {
            translate([0, 0, 0.4]) bearing();
        }
    }
}

module torso_bottom()
{
    difference()
    {
        cylinder(d = 17, h = 0.3);
        // legs
        rotate([0, 0, 70]) translate([-7, 0, 0]) servox(hole = true);
        rotate([0, 0, 110])  translate([-7, 0, 0]) servox(hole = true);
        rotate([0, 0, 30]) translate([-7, 0, 0]) servox(hole = true);
        rotate([0, 0, 150]) translate([-7, 0, 0]) servox(hole = true);
        rotate([0, 0, -10]) translate([-7, 0, 0]) servox(hole = true);
        rotate([0, 0, 190]) translate([-7, 0, 0]) servox(hole = true);
        rotate([0, 0, -50]) translate([-7, 0, 0]) servox(hole = true);
        rotate([0, 0, 230]) translate([-7, 0, 0]) servox(hole = true);
        // spacers
        translate([6 * cos(30), 6 * sin(30), -0.1]) cylinder(d = 0.3, h = 0.5);
        translate([6 * cos(150), 6 * sin(150), -0.1]) cylinder(d = 0.3, h = 0.5);
        translate([6 * cos(230), 6 * sin(230), -0.1]) cylinder(d = 0.3, h = 0.5);
        translate([6 * cos(310), 6 * sin(310), -0.1]) cylinder(d = 0.3, h = 0.5);
    }
}

module torso_top()
{
    difference()
    {
        cylinder(d = 14, h = 0.3);
        // spacers
        translate([6 * cos(30), 6 * sin(30), -0.1]) cylinder(d = 0.3, h = 0.5);
        translate([6 * cos(150), 6 * sin(150), -0.1]) cylinder(d = 0.3, h = 0.5);
        translate([6 * cos(230), 6 * sin(230), -0.1]) cylinder(d = 0.3, h = 0.5);
        translate([6 * cos(310), 6 * sin(310), -0.1]) cylinder(d = 0.3, h = 0.5);
        // head servo
        translate([0, -5.5, 0]) rotate([0, 0, 90]) servox(hole = true);
        // boards
        rotate([0, 0, 90])
        {
            translate([-0.6, 0.5, 1.1]) servo_controller_24(solid_holes = true);
            translate([4, -5, 1.1]) rotate([0, 0, 180]) scale(0.1) arduino(solid_holes = true);
        }
    }
}

module torso()
{
    translate([0, 0, 3.3]) torso_top();
    torso_bottom();
    translate([6 * cos(30), 6 * sin(30), 3.3]) nut(d = 0.3, h = 3);
    translate([6 * cos(150), 6 * sin(150), 3.3]) nut(d = 0.3, h = 3);
    translate([6 * cos(230), 6 * sin(230), 3.3]) nut(d = 0.3, h = 3);
    translate([6 * cos(310), 6 * sin(310), 3.3]) nut(d = 0.3, h = 3);
}

module shoulder_base()
{
    difference()
    {
        hull()
        {
            rcube([5, 3, 0.2], 1);
            translate([7.25, 1.5, 0]) cylinder(d = 1.4, h = 0.2);
        }
        translate([0.25, 2.05, -0.1]) cube([3, 0.2, 0.4]);
        translate([0.25, 0.85, -0.1]) cube([3, 0.2, 0.4]);
        translate([7.25, 1.5, -0.1]) cylinder(d = 0.8, h = 0.4);
        translate([5, 1.5, -0.1]) cylinder(d = 0.3, h = 0.4);
        translate([4, 2.5, -0.1]) cylinder(d = 0.3, h = 0.4);
        translate([4, 0.5, -0.1]) cylinder(d = 0.3, h = 0.4);
    }
}

module shoulder_base2()
{
    difference()
    {
        hull()
        {
            rcube([1.5, 3, 0.2], 1);
            translate([3.75, 1.5, 0]) cylinder(d = 1.4, h = 0.2);
        }
        translate([3.2, 0.9, -2.85]) servo_horn(angle = 90, hole = true);
        translate([3.75, 1.5, -0.1]) cylinder(d = 0.8, h = 0.4);
        translate([1.5, 1.5, -0.1]) cylinder(d = 0.3, h = 0.4);
        translate([0.5, 2.5, -0.1]) cylinder(d = 0.3, h = 0.4);
        translate([0.5, 0.5, -0.1]) cylinder(d = 0.3, h = 0.4);
    }
}

module shoulder_servo_support()
{
    difference()
    {
        union()
        {
            cube([3.5, 0.2, 1.5]);
            translate([0.25, 0, -0.2]) cube([3, 0.2, 0.2]);
        }
        translate([1.2, 0.4, 0.6]) rotate([90, 0, 0]) servox(hole = true);
    }
}

module shoulder()
{
    translate([-2, 0, -0.25]) shoulder_base2();
    translate([-1.5, 0.5, -0.25]) nut(h = 3, d = 0.3);
    translate([-1.5, 2.5, -0.25]) nut(h = 3, d = 0.3);
    translate([-0.5, 1.5, -0.25]) nut(h = 3, d = 0.3);
    
    translate([-5.5, 0, -3.45]) 
    {
        shoulder_base();
        translate([0, 2.05, 0.2]) shoulder_servo_support();
        translate([0, 0.85, 0.2]) shoulder_servo_support();
    }
}

module foot(len = 10)
{
    difference()
    {
        hull()
        {
            translate([-0.5, 0, 0]) cylinder(d = 2, h = 0.3);
            translate([len / 2.5, 0, 0]) cylinder(d = 1, h = 0.3);
        }
        servox(hole = true);
    }
    hull()
    {
        translate([len / 2.5, 0, 0]) cylinder(d = 1, h = 0.3);
        translate([len + 0.5, -3.1, 0]) cylinder(d = 0.5, h = 0.3);
    }
}

module fore_foot(len = 5) 
{
    difference()
    {
        hull()
        {
            cylinder(d = 1.5, h = 0.2);
            translate([len, 0, 0]) cylinder(d = 1.5, h = 0.2);
        }
        translate([0, 0, -0.1]) cylinder(d = 0.8, h = 0.4);
        translate([len, 0, -0.1]) cylinder(d = 0.8, h = 0.4);
        translate([-0.575, -0.575, -2.85]) servo_horn(angle = -90, hole = true);
        translate([len - 0.575, -0.575, -2.85]) servo_horn(angle = 90, hole = true);
        translate([len * (0.5 - 0.1), 0, -0.1]) cylinder(d = 0.3, h = 0.4);
        translate([len * (0.5 + 0.1), 0, -0.1]) cylinder(d = 0.3, h = 0.4);
    }
}

module leg(angles = [0, 0, 0], fore_foot_len = 5, foot_len = 10)
{
    servox(angle = 90 + angles[0]);

    rotate([0, 0, angles[0]]) translate([-1.75, -1.5, 3.1])
    {
        shoulder();
        translate([-5.5, 0, -3.55]) translate([1.2, 0.25, 0.9]) rotate([-90, 0, 0])
        {
            translate([0, -0.0, 0]) servox(angle = angles[1] + 135);
            rotate([0, 0, angles[1] + 45 + 180])
            {
                translate([0, 0.0, 2.85]) fore_foot(len = fore_foot_len);
                translate([0, 0.0, -0.45]) fore_foot(len = fore_foot_len);
                translate([fore_foot_len * (0.5 + 0.1), 0.1, 2.85]) nut(h = 3.1, d = 0.3);
                translate([fore_foot_len * (0.5 - 0.1), 00.1, 2.85]) nut(h = 3.1, d = 0.3);

                translate([fore_foot_len, 0.0, 0]) rotate([0, 0, angles[2] - 90])
                {
                    servox(angle = 180 - angles[2]);
                    translate([0, 0, 1.25]) foot(len = foot_len);
                }
            }
        }
    } 
}

module spider()
{
    torso();
     
    // max angles: ([-23.5; 23.5], [-45; 45], [-45; 45])
    rotate([0, 0, 70]) translate([-7, 0, -1.25]) leg([0, 0, 0]);
    rotate([0, 0, 110]) translate([-7, 0, -1.25]) leg([0, 0, 0]);

    rotate([0, 0, 30]) translate([-7, 0, -1.25]) leg([0, 0, 0]);
    rotate([0, 0, 150]) translate([-7, 0, -1.25]) leg([0, 0, 0]);
        
    rotate([0, 0, -10]) translate([-7, 0, -1.25]) leg([0, 0, 0]);
    rotate([0, 0, 190]) translate([-7, 0, -1.25]) leg([0, 0, 0]);
        
    rotate([0, 0, -50]) translate([-7, 0, -1.25]) leg([0, 0, 0]);
    rotate([0, 0, 230]) translate([-7, 0, -1.25]) leg([0, 0, 0]);
    
    rotate([0, 0, 90])
    {
        translate([-0.6, 0.5, 4.4]) servo_controller_24(spacer = true);
        translate([4, -5, 4.4]) rotate([0, 0, 180]) scale(0.1) arduino(spacer = true);
        translate([-5.5, 0, 2.05]) servox(angle = 90);
    }
}

module blueprint1()
{
    translate([9, 9, 0]) torso_bottom();
    
    translate([5, 3, 0])
    {
        translate([11, 15, 0]) rotate([0, 0, 180]) foot();
        translate([11, 18.5, 0]) rotate([0, 0, 180]) foot();
        translate([-3, 23, 0]) rotate([0, 0, 0]) foot();
        translate([-3, 19.5, 0]) rotate([0, 0, 0]) foot();
    }
}

module blueprint2()
{
    translate([9, 9, 0]) torso_top();
}

module blueprint3()
{
    translate([1, 9, 0])
    {
        rotate([0, 0, -90]) shoulder_base();
        translate([0, 5.5, 0]) rotate([0, 0, -90]) shoulder_base2();
        translate([0, 8, 0]) rotate([90, 0, 0]) shoulder_servo_support();
        translate([0, 10.5, 0]) rotate([90, 0, 0]) shoulder_servo_support();
    }
    translate([5.5, 9, 0])
    {
        rotate([0, 0, -90]) shoulder_base();
        translate([0, 5.5, 0]) rotate([0, 0, -90]) shoulder_base2();
        translate([0, 8, 0]) rotate([90, 0, 0]) shoulder_servo_support();
        translate([0, 10.5, 0]) rotate([90, 0, 0]) shoulder_servo_support();
    }
    translate([9.75, 9, 0])
    {
        rotate([0, 0, -90]) shoulder_base();
        translate([0, 5.5, 0]) rotate([0, 0, -90]) shoulder_base2();
        translate([0, 8, 0]) rotate([90, 0, 0]) shoulder_servo_support();
        translate([0, 10.5, 0]) rotate([90, 0, 0]) shoulder_servo_support();
    }
    translate([14, 9, 0])
    {
        rotate([0, 0, -90]) shoulder_base();
        translate([0, 5.5, 0]) rotate([0, 0, -90]) shoulder_base2();
        translate([0, 8, 0]) rotate([90, 0, 0]) shoulder_servo_support();
        translate([0, 10.5, 0]) rotate([90, 0, 0]) shoulder_servo_support();
    }
}

module blueprint4()
{
    translate([2, 2, 0]) fore_foot();
    translate([2, 5, 0]) fore_foot();
    translate([2, 8, 0]) fore_foot();
    translate([2, 11, 0]) fore_foot();
    
    translate([10, 2, 0]) fore_foot();
    translate([10, 5, 0]) fore_foot();
    translate([10, 8, 0]) fore_foot();
    translate([10, 11, 0]) fore_foot();
}

module blueprint()
{
    //translate([0, 0, -1]) color("black") cube([18, 27.5, 1]);
    projection()
    {
        blueprint1();
        blueprint2();
        blueprint3();
        blueprint4();
    }
}

spider();
