
which_one="casing"; //[cam, shaft, casing, cover, follower, follower1, follower2, follower_case, full]


$fn=100;

total_lift                  = 10;   // mm
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
shaft_wedge                 = 1.5;  //mm

case_length                 = 140;
case_width                  = 140;
case_wall_thickness         = 15;
case_thickness              = 25;   //5mm of wall thickness+5mm space+10mm thickness of cam+5mm space
follower_thick_part_length  = 30;   //mm
follower_thin_part_length   = 35;   //mm

follower_case_length        = 50;   //mm
follower_case_width         = 22.2; //mm
follower_case_ledge         = 4;    //mm



rise    = rise_end - rise_begin;
fall    = fall_end - fall_begin;

function tan_theta(base) = total_lift/base;
function height(angle, base) = base_circle_diameter/2+angle*tan_theta(base);
function x(angle, base) = cos(angle)*height(angle, base);
function y(angle, base) = sin(angle)*height(angle, base);



if (which_one == "cam")         cam();
if (which_one == "shaft")       shaft();
if (which_one == "casing")      casing();
if (which_one == "cover")       cover();
if (which_one == "follower")    follower();
if (which_one == "follower1")    follower1();
if (which_one == "follower2")    follower2();
if (which_one == "follower_case")    follower_case();
if (which_one == "full")        full();




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
        translate([i*(shaft_radius+(hole?0.1:0)-shaft_wedge)-(i==-1?5:0), -shaft_radius-(hole?0.1:0), 0])
#            cube([5, 2*(shaft_radius+(hole?0.1:0)), shaft_length]);
        }
    }
}


module casing()
{
    translate([-case_width/2, -case_length/2, -10])
    {
        difference()
        {
            union()
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
                    translate([case_wall_thickness ,case_wall_thickness, 5])
                        cube([case_width-case_wall_thickness*2, case_length-case_wall_thickness*2, case_thickness-5]);
                   
                       //two slots in lower half
                        for (i = [0:1])
                        {
                            translate([case_wall_thickness/(i==1?2:1) + (i==1?case_width/2:0), case_wall_thickness, 0])
 #                           cube([case_width/2-case_wall_thickness*1.5, case_length/2-case_wall_thickness*1.5, case_wall_thickness-10]);
                        }
                        // three slots in upper part
                        slot_width = (case_width-case_wall_thickness*4)/3;
                        for (i = [0:2])
                        {
                            translate([(slot_width)*i+case_wall_thickness*(i+1), case_wall_thickness/2+case_length/2, 0])
                            cube([slot_width, case_length/2-case_wall_thickness*1.5, case_wall_thickness-10]);
                        }
                   
                    
                    
        //            hole for the follower
                    translate([case_width/2, case_length-case_wall_thickness, 15])
                        rotate([-90, 0, 0])
                            {
        #                       cylinder(h=25, d=8.2);
                                cylinder(h=15, d=12.2);
                            }
                }
            translate([case_width/2, case_length/2, 0])
            difference()
            {
                cylinder(h=9.9, d=40);
                translate([0, 0, 8.9])
                    difference()
                    {
     #                  cylinder(h=1, d=36);
                        cylinder(h=1, r = shaft_radius+0.2+2);
                        
                    }
            }
            }
            
            //hole for shaft
            translate([case_width/2, case_length/2, 0])
                cylinder(h = case_wall_thickness, r = shaft_radius+0.2);
            
            //holes for screws
            translate([case_width/2, case_length/2, 0])
            for (i = [1, -1])
            {
                for (j = [1, -1])
                {
                    //four corners
                    translate([i*case_width/2-i*case_wall_thickness/2, j*case_length/2-j*case_wall_thickness/2, 0 ])
#                    cylinder(h=case_thickness, d=3);
                    //four centers
                    if (i==1 && j==1)
                    {
                        for (k = [1, -1])
                        {
                            translate([k*case_width/3/2, case_length/2-case_wall_thickness/2, 0])
#                                cylinder(h=case_thickness, d=3);
                        }
                    }
                    else
                    {
                        translate([(i==1?0:j*case_width/2-j*case_wall_thickness/2), (i==1?j*case_length/2-j*case_wall_thickness/2:0), 0 ])
    #                    cylinder(h=case_thickness, d=3);
                    }
                }
            }
        }
    }
//    rotate([0, 0, 180])
//    cam();
}


module cover()
{
    difference()
    {
        union()
        {
            translate([-case_width/2, -case_length/2, 0])
            {
                difference()
                {
                    union()
                    {
                        cube([case_width, case_length, 10]);
                    }
                    //two slots in lower half
                    for (i = [0:1])
                    {
                        translate([case_wall_thickness/(i==1?2:1) + (i==1?case_width/2:0), case_wall_thickness, 0])
                        cube([case_width/2-case_wall_thickness*1.5, case_length/2-case_wall_thickness*1.5, 10]);
                    }
                    // three slots in upper part
                    slot_width = (case_width-case_wall_thickness*4)/3;
                    for (i = [0:2])
                    {
                        translate([(slot_width)*i+case_wall_thickness*(i+1), case_wall_thickness/2+case_length/2, 0])
                        cube([slot_width, case_length/2-case_wall_thickness*1.5, 10]);
                    }
                }
            }
            difference()
            {
                cylinder(h=9.9+5, d=40);

                translate([0, 0, 8.9+5])
                    difference()
                    {
     #                  cylinder(h=1, d=36);
                        cylinder(h=1, r = shaft_radius+0.2+2);
                        
                    }

            }
        }
        
        //hole for shaft
//        translate([case_width/2, case_length/2, 0])
            cylinder(h = case_wall_thickness+5, r = shaft_radius+0.2);
        
        //holes for screws
//            translate([case_width/2, case_length/2, 0])
            for (i = [ 1, -1])
            {
                for (j = [ 1, -1])
                {
                    //four corners
                    translate([i*case_width/2-i*case_wall_thickness/2, j*case_length/2-j*case_wall_thickness/2, 0 ])
#                    cylinder(h=case_thickness, d=3);
                    //four centers
                    if (i==1 && j==1)
                    {
                        for (k = [1, -1])
                        {
                            translate([k*case_width/3/2, case_length/2-case_wall_thickness/2, 0])
#                                cylinder(h=case_thickness, d=3);
                        }
                    }
                    else{
                    translate([(i==1?0:j*case_width/2-j*case_wall_thickness/2), (i==1?j*case_length/2-j*case_wall_thickness/2:0), 0 ])
#                    cylinder(h=case_thickness, d=3);
                    }
                }
            }
    }
}




module follower()
{
    union()
    {
        translate([0, 0, 6]) sphere(d = 12);
        translate([0, 0, 6]) cylinder(h=follower_thick_part_length-6, d=12);
        translate([0, 0, 6]) cylinder(h=follower_thick_part_length-6+follower_thin_part_length, d=8);
        
    }
}

module follower1()
{
    difference()
    {
        follower();
        translate([2.5, -6, 0])    cube([3.5, 12, 50, ]);
    }
}

module follower2()
{
    difference()
    {
        follower();
//        translate([2.5, -6, 0])    cube([3.5, 12, 50, ]);
        translate([-6, -6, 0])    cube([8.5, 12, 50, ]);
    }    
}

module follower_case()
{
    translate([-follower_case_width/2, case_length/2-case_wall_thickness, -5])
    {
        difference()
        {
            union()
            {
                cube([follower_case_width, follower_case_length, case_thickness-5]);
                translate([-10, case_wall_thickness/2-2.5, 0])
                    cube([follower_case_width+20, 5, case_thickness-5]);
            }
            
//            difference starts ##############################
            translate([follower_case_width/2, 0, (case_thickness-5)/2])
                rotate([-90, 0, 0])
            {
                #cylinder(h=follower_case_length, d=8.2);
                cylinder(h=40, d=12.2);
            }
        }
    }
    
    
//    casing();
}

module full()
{
    casing();
    cam();
    translate([0, 0, 25]) rotate([180, 0, 180]) cover();
    translate([0, 0, -10]) shaft();
        
}