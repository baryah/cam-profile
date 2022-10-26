
which_one="casing"; //[cam, shaft, casing, follower]


$fn=100;

total_lift                  = 20;   // mm
base_circle_diameter        = 80;   // mm
bottom_dwell_begin          = 0;    // degrees
bottom_dwell_end            = 180;  //degree
rise_begin                  = 180;  //degree
rise_end                    = 267;  //degree
top_dwell_begin             = 267;  //degree
top_dwell_end               = 273;  //degree
fall_begin                  = 273;  //degree
fall_end                    = 360;  //degree


shaft_length                = 50;   //mm
shaft_radius                = 4;    //mm

case_length                 = 160;
case_width                  = 160;
case_wall_thickness         = 10;
case_thickness              = 25;   //5mm of wall thickness+5mm space+10mm thickness of cam+5mm space
follower_thick_part_length  = 10;   //mm
follower_thin_part_length   = 45;   //mm


rise    = rise_end - rise_begin;
fall    = fall_end - fall_begin;

function tan_theta(base) = total_lift/base;
function height(angle, base) = base_circle_diameter/2+angle*tan_theta(base);
function x(angle, base) = cos(angle)*height(angle, base);
function y(angle, base) = sin(angle)*height(angle, base);



if (which_one == "cam")         cam();
if (which_one == "shaft")       shaft();
if (which_one == "casing")      casing();
if (which_one == "follower")    follower();

module cam()
{
    points_rise = [ for ( angle = [0 : rise]) [x(angle, rise), y(angle, rise)] ];
    points_fall = [ for ( angle = [fall : -1 : 0]) [-x(angle, fall), y(angle, fall)] ];
        
    points = concat( points_rise, points_fall );

    echo(points);

    difference()
    {
        linear_extrude(10)
        {
            union()
                {
                polygon(points);
                circle(base_circle_diameter/2);
                }
        }
        translate([0, 0, -shaft_length/2])
            shaft(hole=true);
    }
    
//    translate([0, 0, -shaft_length/2])
//            shaft();
}


module shaft(hole=false)
{
    difference()
    {
        cylinder(h=shaft_length, r=shaft_radius+(hole?0.1:0));
        for (i = [1, -1])
        {
        translate([i*(shaft_radius+(hole?0.1:0)-0.5)-(i==-1?5:0), -shaft_radius-(hole?0.1:0), 0])
#            cube([5, 2*(shaft_radius+(hole?0.1:0)), shaft_length]);
        }
    }
}


module casing()
{
    translate([-case_width/2, -case_length/2, -case_wall_thickness])
    {
        difference()
        {
            union()
            {
                cube([case_width, case_length, case_thickness]);
                translate([case_width/2, case_length-case_wall_thickness, 15])
                    rotate([-90, 0, 0])
                        cylinder(h=25, d=16);
            }
            translate([case_wall_thickness ,case_wall_thickness, case_wall_thickness/2])
                cube([case_width-case_wall_thickness*2, case_length-case_wall_thickness*2, case_thickness-case_wall_thickness/2]);
            translate([case_width/2, case_length/2, 0])
                cylinder(h = case_wall_thickness, r = shaft_radius+0.2); 
            
//            hole for the follower
            translate([case_width/2, case_length-case_wall_thickness, 15])
                rotate([-90, 0, 0])
                    {
#                       cylinder(h=25, d=8.2);
                        cylinder(h=15, d=12);
                    }
        }
    }
//    rotate([0, 0, 180])
    cam();
}



module follower()
{
}