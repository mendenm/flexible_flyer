// wrist pins based on M4 bolts

use <threads-cuiso.scad>

bolt_dia=4;
bolt_clearance=bolt_dia+0.2;

hex_head=7+0.2;
hex_head_points=hex_head/cos(30);

module inner_nut(scale) {
    // this is nonsense, the bolt head is etched into the palm hinge tab
    difference() {
        scale(scale*[1,1,0.5]) 
            intersection() {
                sphere(d=12, $fn=20);
                translate([0,0,20]) cube(40, center=true);
            }
        translate([0,0,3*scale-2.9]) cylinder(d=hex_head_points, h=3, $fn=6);
        translate([0,0,-1]) cylinder(d=bolt_clearance, h=5, $fn=50);
    }
}

module outer_nut(scale) {
    // this is nonsense, the bolt head is etched into the palm hinge tab
    difference() {
        scale(scale*[1,1,0.5]) 
            intersection() {
                sphere(d=20, $fn=20);
                translate([0,0,20]) cube(40, center=true);
            }
        #thread_for_nut(diameter=bolt_dia, length=4, usrclearance=0);
    }
}

outer_nut(1);


