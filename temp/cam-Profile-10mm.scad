use <roundedCube.scad>
use <threads.scad>
include <screw_sizes.scad>

$fn=100;


which_one="cam"; //[cam, shaft, casing, cover, follower, follower1, follower2, follower_case, handle, handle1, handle2, handle3, filler, full]



total_lift                  = 10;   // mm
base_circle_diameter        = 80;   // mm
bottom_dwell_begin          = 0;    //degrees
bottom_dwell_end            = 180;  //degree
rise_begin                  = 180;  //degree
rise_end                    = 267;  //degree
top_dwell_begin             = 267;  //degree
top_dwell_end               = 273;  //degree
fall_begin                  = 273;  //degree
fall_end                    = 360;  //degree


shaft_length                = 50;   //mm
shaft_radius                = 4;    //mm
shaft_wedge                 = 1;  //mm

case_length                 = 140;
case_width                  = 140;
case_wall_thickness         = 15;
case_thickness              = 25;   //5mm of wall thickness+5mm space+10mm thickness of cam+5mm space
follower_thin_dia           = 8;  //mm
follower_thick_dia          = 12;   //mm
follower_thick_part_length  = 30;   //mm
follower_thin_part_length   = 35;   //mm

follower_case_length        = 50;   //mm
follower_case_width         = 22.2; //mm
follower_case_ledge         = 5;    //mm

margin                      = 0.1;  //mm



rise    = rise_end - rise_begin;
fall    = fall_end - fall_begin;

function tan_theta(base) = total_lift/base;
function height(angle, base) = base_circle_diameter/2+angle*tan_theta(base);
function x(angle, base) = cos(angle)*height(angle, base);
function y(angle, base) = sin(angle)*height(angle, base);



if (which_one == "cam")             cam();
if (which_one == "shaft")           shaft();
if (which_one == "casing")          casing();
if (which_one == "cover")           cover();
if (which_one == "follower")        follower();
if (which_one == "follower1")       follower1();
if (which_one == "follower2")       follower2();
if (which_one == "follower_case")   follower_case();
if (which_one == "handle1")         handle1();
if (which_one == "handle2")         handle2();
if (which_one == "handle3")         handle3();
if (which_one == "handle")          handle();
if (which_one == "full")            full();
if (which_one == "filler")          filler();




module cam()
{
    points_rise = [ for ( angle = [0 : rise]) [x(angle, rise), y(angle, rise)] ];
    points_fall = [ for ( angle = [fall : -1 : 0]) [-x(angle, fall), y(angle, fall)] ];
        
    points = concat( points_rise, points_fall );

    echo(points);
    

    difference()
    {
        union()
        {
            linear_extrude(10)
            {
                union()
                    {
                        polygon(points);
                        circle(base_circle_diameter/2);
                    }
            }
            //       the central round !!hub!!
            translate([0, 0, 9])
            difference()
                {
                  cylinder(h=5.9, d=40);
                    translate([0, 0, 4.9])
                        difference()
                        {
                           cylinder(h=1, d=36);
                            cylinder(h=1, r = shaft_radius+0.2+2);
            
                        }
                }
        }
//        Difference Starts ###########################
        
//        hole for shaft
        translate([0, 0, -shaft_length/2])
            shaft(hole=true);
        
//        holes for grub screws
        translate([-20, 0, 10+1.7]) rotate([0, 90, 0]) cylinder(h=40, d=m3_grub_screw_dia+2*margin);
        
//        slots for hexnut
        for (i = [0, 1])
        {
            mirror([i, 0, 0])
            {
                translate([-9, -(m3_grub_screw_hexnut_max_dia+margin)/2, 10+1.7-(m3_grub_screw_hexnut_dia+margin)/2]) 
#               cube([m3_grub_screw_hexnut_height+margin, m3_grub_screw_hexnut_max_dia+margin, m3_grub_screw_hexnut_dia+margin]);
                
//                groove for tightening screws
                translate([20, 0, 10+1.7])
                rotate([0, 90, 0])
#               cylinder(h=17, d=6);
                
            }
        }
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
    difference()
    {
        translate([-case_width/2, -case_length/2, -10])
        {
            difference()
            {
                union()
                {
                    difference()
                    {
    //                    union()
    //                    {
//                            cube([case_width, case_length, case_thickness]);
                        roundedcube(case_width, case_length, case_thickness, 5);
                        
    //                    Difference Starts #################
    //                        translate([case_width/2, case_length-case_wall_thickness, 15])
    //                            rotate([-90, 0, 0])
    //                                cylinder(h=25, d=16);
    //                    }
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
                       
                        
                        
            //            slot the follower
    //                    translate([case_width/2, case_length-case_wall_thickness, 15])
    //                        rotate([-90, 0, 0])
    //                            {
    //        #                       cylinder(h=25, d=8.2);
    //                                cylinder(h=15, d=12.2);
    //                            }
                            
                    }
                    
    //       the central round !!hub!!
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
                
    //                    Difference Starts #################
                
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
                        {
    #                       cylinder(h=case_thickness, d=m3_screw_dia+margin*2);
                            cylinder(h=8, d=m3_screw_head_dia+margin*2);
                            translate([0, 0, 8])    cylinder(h=m3_screw_head_depth, d1=m3_screw_head_dia+2*margin, d2=m3_screw_dia+2*margin);
                        }
                        //four centers
                        if (i==1 && j==1)
                        {
                            for (k = [1, -1])
                            {
                                translate([k*case_width/3/2, case_length/2-case_wall_thickness/2, 0])
                                {
    #                                cylinder(h=case_thickness, d=m3_screw_dia+margin*2);
                                     cylinder(h=8, d=m3_screw_head_dia+margin*2);
                                    translate([0, 0, 8])    cylinder(h=m3_screw_head_depth, d1=m3_screw_head_dia+2*margin, d2=m3_screw_dia+2*margin);
                                }
                            }
                        }
                        else
                        {
                            translate([(i==1?0:j*case_width/2-j*case_wall_thickness/2), (i==1?j*case_length/2-j*case_wall_thickness/2:0), 0 ])
                            {
        #                    cylinder(h=case_thickness, d=m3_screw_dia+margin*2);
    #                            cylinder(h=8, d=m3_screw_head_dia+margin*2);
                                translate([0, 0, 8])    cylinder(h=m3_screw_head_depth, d1=m3_screw_head_dia+2*margin, d2=m3_screw_dia+2*margin);
                            }
                        }
                    }
                }
            }
        }
//        Difference Starts#####################3
//            slot for follower_case
#        follower_case(true);
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

//                        cube([case_width, case_length, 10]);
                    roundedcube(case_width, case_length, 10, 5);
//          Difference starts ##########################
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
//            Union @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
//            difference()
//            {
                cylinder(h=10, d=40);

//                translate([0, 0, 8.9+5])
//                    difference()
//                    {
//     #                  cylinder(h=1, d=36);
//                        cylinder(h=1, r = shaft_radius+0.2+2);
//                        
//                    }

//            }
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
                    {
#                       cylinder(h=case_thickness, d=m3_screw_dia+margin*2);
                        cylinder(h=m3_grub_screw_hexnut_height+margin*5, d=m3_grub_screw_hexnut_max_dia+2*margin, $fn=6);
                    }
                    //four centers
                    if (i==1 && j==1)
                    {
                        for (k = [1, -1])
                        {
                            translate([k*case_width/3/2, case_length/2-case_wall_thickness/2, 0])
                            {
#                                cylinder(h=case_thickness, d=m3_screw_dia+margin*2);
                                cylinder(h=m3_grub_screw_hexnut_height+margin*5, d=m3_grub_screw_hexnut_max_dia+2*margin, $fn=6);
                            }
                        }
                    }
                    else{
                    translate([(i==1?0:j*case_width/2-j*case_wall_thickness/2), (i==1?j*case_length/2-j*case_wall_thickness/2:0), 0 ])
                        {
#                           cylinder(h=case_thickness, d=m3_screw_dia+margin*2);
                            cylinder(h=m3_grub_screw_hexnut_height+margin*5, d=m3_grub_screw_hexnut_max_dia+2*margin, $fn=6);
                        }
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
        translate([0, 0, 6]) cylinder(h=follower_thick_part_length-6, d=follower_thick_dia);
        translate([0, 0, 6]) cylinder(h=follower_thick_part_length-6+follower_thin_part_length, d=follower_thin_dia);
        
    }
}

module follower1()
{
    difference()
    {
        follower();
        translate([2.5, -6, 0])    cube([3.5, 12, follower_thick_part_length+follower_thin_part_length]);
    }
}

module follower2()
{
    difference()
    {
        follower();
//        translate([2.5, -6, 0])    cube([3.5, 12, 50, ]);
        translate([-6, -6, 0])    cube([8.5, 12, follower_thick_part_length+follower_thin_part_length]);
    }    
}

module follower_case(subtract=false)
{
    translate([-(follower_case_width+(subtract?margin:0))/2, case_length/2-case_wall_thickness, -5-(subtract?margin/2:0)])
    {
        difference()
        {
            union()
            {
//                cube([follower_case_width+(subtract?margin:0), follower_case_length, case_thickness-5+(subtract?margin:0)]);
                translate([0, 0, case_thickness-5+(subtract?margin:0)])
                    rotate([-90, 0, 0]) 
                        roundedcube(follower_case_width+(subtract?margin:0), case_thickness-5+(subtract?margin:0), follower_case_length, 5);
                translate([0, 0, 10])
                    cube([follower_case_width+(subtract?margin:0), 15, 10++(subtract?margin:0)]);
                
//      ledge         
//                translate([-10-(subtract?margin/4:0), case_wall_thickness/2-follower_case_ledge/2-(subtract?margin/2:0), 0])
                translate([-7, case_wall_thickness/2-follower_case_ledge/2-(subtract?margin/2:0), 0])
                    cube([follower_case_width+14+(subtract?margin:0), follower_case_ledge+(subtract?margin:0), case_thickness-5+(subtract?margin:0)]);
            }
            
//            difference starts ##############################
            if (!subtract)
            {
                translate([follower_case_width/2, 0, (case_thickness-5)/2])
                    rotate([-90, 0, 0])
                {
                    #cylinder(h=follower_case_length, d=follower_thin_dia+0.2);
                    cylinder(h=37, d=follower_thick_dia+0.2);
                    translate([0, 0, 37])
                    cylinder(h=3, d1=follower_thick_dia+0.2, d2=follower_thin_dia+0.2);
                }
            }
        }
    }
    
    
//    casing();
}

module filler()
{
    difference()
    {
        cylinder(h=3-0.2, d1=follower_thick_dia, d2=follower_thin_dia);
        cylinder(h=3, d=follower_thin_dia+0.2);
    }
}

module handle1()
{
    difference()
    {
        hull()
        {
            cylinder(h=10, d=30);
            translate([50, 0, 0]) cylinder(h=10, d=20);
        }
        
        rotate([0, 0, 90]) shaft(true);
        
//        grub screws
#        translate([0, -15, 5]) rotate([-90, 0, 0]) cylinder(h=30, d=m3_grub_screw_dia+margin*2);
        
//        grub screw hexnut space
        for (i = [0,1])
        {
            mirror([0, i, 0])
            {
                translate([0, -3 - m3_grub_screw_hexnut_height/2, 5])
                    rotate([90, 90, 0]) 
                        cylinder(h=m3_grub_screw_hexnut_height+margin*2, d=m3_grub_screw_hexnut_max_dia+margin*2, $fn=6);
                translate([-(m3_grub_screw_hexnut_dia+margin*2)/2, -3 -m3_grub_screw_hexnut_height*1.5-margin*2, 0 ]) 
                    cube([m3_grub_screw_hexnut_dia+margin*2, m3_grub_screw_hexnut_height+margin*2, 5]);
            }
        }
        
//        handle space
        translate([50, 0, 0])
            {
                cylinder(h=5, d=10);
                cylinder(h=10, d=6);
            }
    }
}


module handle2()
{
    union()
    {
        cylinder(d=9.6, h=4.8);
        cylinder(d=5.7, h=6+4.8);
        translate([0, 0, 10.4])
            metric_thread (diameter=5.7, pitch=1, length=5, n_starts=1);
    }
}

module handle3()
{
        difference()
    {
        cylinder(h=20, d=15);
        metric_thread (diameter=5.7+0.4, pitch=1, length=5, internal=true, n_starts=1);
    }
}

module handle()
{
    handle1();
    translate([50, 0, 0]) handle2();
    translate([50, 0, 10.4]) handle3();
    
}

module full()
{
    casing();
    cam();
    translate([0, 0, 25]) rotate([180, 0, 180]) cover();
    translate([0, 0, -10]) shaft();
    follower_case();
    translate([0, case_length/2-case_wall_thickness-5, 5]) rotate([-90, 0, 0]) follower();
    
    translate([0, 0, case_thickness+5]) rotate([0, 0, 90]) handle();
    
//    
//    translate([0, 0, 10]) follower_case(true);
        
}