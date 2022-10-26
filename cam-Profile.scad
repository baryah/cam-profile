



$fn=100;

total_lift              = 20;   // mm
base_circle_diameter    = 100;  // mm
bottom_dwell_begin      = 0;    // degrees
bottom_dwell_end        = 180;  //degree
rise_begin              = 180;  //degree
rise_end                = 267;  //degree
top_dwell_begin         = 267;  //degree
top_dwell_end           = 273;  //degree
fall_begin              = 273;  //degree
fall_end                = 360;  //degree

rise    = rise_end - rise_begin;
fall    = fall_end - fall_begin;

function tan_theta(base) = total_lift/base;
function height(angle, base) = base_circle_diameter/2+angle*tan_theta(base);
function x(angle, base) = cos(angle)*height(angle, base);
function y(angle, base) = sin(angle)*height(angle, base);






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
    cylinder(h=10, d=8);
}