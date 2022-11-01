//creates a cube with rounded edges 
//parameters passed - roundedcube(x,y,z,r,center)
//x=size of x-limb
//y=size of y limb
//z=height of cube
//r=radius of round edge
//center - if true - centred cube
  
  
  //roundedcube(10,5,15,0.2,true);
  
  
  
  
  module roundedcube(xdim, ydim, zdim, rdim, centring=false) {
      x=(centring)?-xdim/2:0;
      y=(centring)?-ydim/2:0;
      z=(centring)?-zdim/2:0;
     
    echo(x,y,x+rdim,y+rdim,x+xdim-rdim,y+rdim,x+rdim,y+ydim-rdim,x+xdim-rdim,y+ydim-rdim)
    hull()
          {
        translate([x+rdim,y+rdim,z])cylinder(h=zdim,r=rdim);
        translate([x+xdim-rdim,y+rdim,z])cylinder(h=zdim,r=rdim);
        translate([x+rdim,y+ydim-rdim,z])cylinder(h=zdim,r=rdim);
        translate([x+xdim-rdim,y+ydim-rdim,z])cylinder(h=zdim,r=rdim);
    }
}