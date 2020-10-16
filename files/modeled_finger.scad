
/*
Parametric Finger Generator for Phoenix-reborn hand converted to paraglider/flexible flyer.
This takes a fully OpenSCAD-modelled finger, based on the general geometry of the Phoenix Reborn,  
in a manner that scales the holes to a chosen size indepenedent of the finger size.
This allows one to use a wide variety of commercial metal fasteners in lieu of 3d printed pins
to create the pivots for fingers.  

Setting the line 
  global_scale=1.3;
to the desired value sets the size of the palm these fingers are adjusted to fit.

The designs in the default version of this files are set up
to use 3mm screws, 1/16" steel pins, or 13 ga (0.092") (USA) nails, with a plastic tubing
bearing on the outside to make it move smoothly.  The pins and nails may not need the tubing,
and parameters can be adjusted to make this the case. 
These designs can be selected by setting one of the lines
  screws=false;
  pins_16th=true;
  nails_13ga=false;
to true.

By manually adjusting the lines
  pivot_dia= pivot_array[pivot_size_index];
  pivot_pin_dia=pin_array[pivot_size_index];
at the bottom, to put in actual numbers instead of the pre-packaged values,
almost any geometry can be created for regions with different (e.g. metric) pins or nails.

Note that the parameters can be adjusted for your printer tolerances.  Mostly, you probably
only have to reprint the phalanx parts to adjust the joint quality, since they are the part that 
includes the hole for the pivot, and that has a clearance for the slots.  
The line
  nominal_clearance=0.6;
sets the looseness of the slots for the joints; making is smaller makes joints tighter.

Marcus Mendenhall, 5 June, 2020, Germantown, Maryland, USA

*/

// size of fingers. should match scale of hand they are being printed for.
global_scale=1.3; // [1.0:0.02:2.0]
// clearance on sides of tabs.  increase for looser fit. This only affects the phalanges, so a bad fit does not require reprinting  anything else.
nominal_clearance=0.6;

/* [Hidden] */
// 3mm screws with 3/16" OD delrin rod
pivot_dia_3mm_screw=25.4*(3/16)+0.25; // 3/16" OD delrin tubing with a little clearance since they were too small otherwise
pivot_pin_dia_3mm_screw=3+0.1; // 3 mm screws

// 1/16" pins with 1/8" OD delrin rod
pivot_dia_8th_delrin=25.4*(1/8)+0.25; // 1/8" OD delrin tubing with a little clearance since they were too small otherwise
pivot_pin_dia_16th_pin=25.4*(1/16); // 1/16" steel pin

// 13-gauge nails
// https://www.fastenerusa.com/nails/hand-drive-nails/finishing/2-x-13-gauge-304-stainless-6d-finishing-nails-1lb.html
// and 3/32" ID/ 5/32" OD PTFE tubing
// https://fluorostore.com/products/fractional-metric-ptfe-fluoropolymer-tubing
// part number F015137
pivot_dia_13ga_nail=25.4*(5/32)+0.25; // 5/32"" OD PTFE tubing with a little clearance since they were too small otherwise
pivot_pin_dia_13ga_nail=25.4*0.095; // 13 ga nail

pivot_array=[pivot_dia_3mm_screw, pivot_dia_8th_delrin, pivot_dia_13ga_nail, ];
pin_array=[pivot_pin_dia_3mm_screw, pivot_pin_dia_16th_pin, pivot_pin_dia_13ga_nail, ];

/* [Pin Style Selection -- select one] */
pin_index=1; // [0: 3mm screws, 1: 1/16 inch pins, 2: 13ga finishing nails] 

screws = (pin_index==2);

pivot_size_index=pin_index;

pivot_dia= pivot_array[pivot_size_index];
pivot_pin_dia=pin_array[pivot_size_index];

/* [Misc] */
// size fo m3 standard nut across flats
nut_size=5.5; // m3 nut across flats, fairly tight fit

bolt_head_dia=5.5+0.3; // loose clearance for m3 bolt head
nominal_slotwidth=6+0; // make an equation to hide from customizer
adjusted_tabwidth=nominal_slotwidth-nominal_clearance/global_scale;
adjusted_slotwidth=nominal_slotwidth;

initial_rotation=33.5;

module fingertip() {
    cyl_1_dia_1=11;
    cyl_1_dia_2=9;
    cyl_1_hgt=15;
    cyl_1_rot=atan((cyl_1_dia_1-cyl_1_dia_2)/cyl_1_hgt/2);

    sph_1_dia=cyl_1_dia_2-2;
    scale([1,1.15,1]) hull() {
        translate([0,cyl_1_hgt/2,(cyl_1_dia_1+cyl_1_dia_2)/4]) rotate([-90-cyl_1_rot,360/20/2,0]) 
            cylinder(d1=cyl_1_dia_1, d2=cyl_1_dia_2, h=cyl_1_hgt, center=true, $fn=20);
        for(dx=[-1,1]*0.5) translate([dx,cyl_1_hgt+2.4,sph_1_dia*0.8/2-0.0]) scale([1,1,0.8]) 
            sphere( d=sph_1_dia,$fn=20);
        for(dx=[-1,1]*0.5) translate([dx,cyl_1_hgt,sph_1_dia*0.4/2]) 
            rotate([-40,0,0]) scale([1,1,0.4]) translate([0,-1,13]) 
            sphere( d=sph_1_dia,$fn=20);
        for(dx=[-1,1]*0.3) translate([dx,0,0]) 
            translate([0,11,8.1]) rotate([-10,0,0]) scale([1,1,0.5]) sphere(d=8, $fn=20);
        rotate([90-initial_rotation,0,0]) translate([0,7,0]) scale([0.85,1,1]) 
        rotate_extrude(angle=180, $fn=90) translate([5,0]) circle(d=3, $fn=20);
    }
}

module carpal() {
    translate([0,-5.4,10.5]) rotate([-90-initial_rotation,0,0]) hull() {
        translate([0,0,-16]) linear_extrude(height=0.1) hull() {
                translate([ 4.,0,0]) scale([0.3,1]) circle(d=12);    
                translate([-4.,0,0]) scale([0.3,1]) circle(d=12);
                translate([0,-7.0]) scale([1,0.2]) circle(d=16*0.4);
                translate([0, 7]) scale([1,0.2]) circle(d=16*0.4);
        }
        translate([0,6,10]) linear_extrude(height=0.1) 
            projection(cut=true) rotate([90+initial_rotation,0, 0]) fingertip();
    }
}

module finger(slotwidth, thumb=false, keel=true) {
    
    difference() {
        intersection() {
            translate([0,0,-0.4]) rotate([initial_rotation-5,0,0]) union() {
                carpal();
                intersection() { 
                    fingertip(); 
                    rotate([-initial_rotation,0,0]) translate([0,14.5,10]) cube(30, center=true); 
                }
            }
            union() {
                translate([0,8,10]) cube([15,50,20], center=true);
                translate([0,-13,2.5]) cube([15,20,5], center=true);
                translate([0,-17,8]) rotate([0,90,0]) cylinder(d=14, h=20, center=true);
            }
        }
        translate([0,-15,12]) cube([slotwidth,30,10], center=true);
        translate([0,-18,8])
            rotate([0,90,0])  intersection() {
                cylinder(d=16, h=slotwidth, center=true, $fn=50);
                translate([-3+(thumb?3:0),0,0]) cube([15,30,slotwidth+1], center=true);
            }
        translate([0,-14,16]) cube([20,30,5], center=true);
        // rectangular toroidal elbow for better elastic feeding
        translate([0,-13,11]) rotate([0,90, 0]) rotate_extrude(angle=90, convexity=5, $fn=40)
            translate([9,0]) square([1.5,3], center=true);
        // connect elbow to end 
        translate([0,-20,2]) cube([3,15,1.5], center=true);
    }
    // bars to attach string and elastic
    translate([0,-3,11]) cube([slotwidth+0.5,2,1.5], center=true);
    translate([0,-8,10]) cube([slotwidth+0.5,2,1.5], center=true);
    if(keel) {
        // make a support for the bad overhang
        hull() {
            translate([0,0,0.25]) cube(0.5, center=true);
            translate([0,18,0]) linear_extrude(height=15*tan(initial_rotation), scale=0.05) 
                square(2, center=true); 
        }
    }
}

module pin_plug(pin_style, dia)
{
    if(pin_style==0) { 
        rotate([0,90,0]) #cylinder(d=5.5, h=5, $fn=20, center=true);
    } else if (pin_style==1) group() {
        rotate([0,90,0]) #translate([0,0,4]) cylinder(d=6, h=1.8, $fn=20, center=true);
        rotate([0,90,0]) #translate([0,0,-4.1]) cube([5,8,1.8], center=true);
    }
}
module adjusted_holes(scale_size, offsets, dia) {
    scale(scale_size) difference() {
        children();
        for(o =offsets) translate(o[0]) rotate([0,90,0]) 
            cylinder(d=dia/scale_size, h=15, $fn=20, center=true);
    }
}

module adjusted_bolt_holes(scale_size, outer_width, offsets, bolt_dia, bolt_head_dia, nut_size) {
    scale(scale_size) difference() {
        children();
        for(o =offsets) translate(o[0]) {
            rotate([0,90,0]) 
                cylinder(d=bolt_dia/scale_size, h=15, $fn=20, center=true); // through hole
            rotate([0,90,0]) translate([0,0,outer_width/2-2]) 
                cylinder(d=bolt_head_dia/scale_size, h=4, $fn=20, center=false); // through hole
            rotate([0,-90,0]) translate([0,0,outer_width/2-2]) 
                rotate(30) cylinder(d=bolt_head_dia/scale_size/cos(30), h=4, $fn=6, center=false); // through hole
        }
    }
}

module phalanx_body(thumb) {
    difference() {
        rotate([-90,0,0]) 
        hull() for(dz=[[[0,thumb?1.5:0.8,9],thumb?0.80:0.90],[[0,0,-7],1]]) translate(dz[0]) 
            linear_extrude(height=0.1, center=true) scale(dz[1]) hull() {
                translate([ 3,0]) scale([0.4,1]) circle(d=16);    
                translate([-3,0]) scale([0.4,1]) circle(d=16);
                translate([0,-8]) scale([1,0.2]) circle(d=16*0.4);
        }
        translate([0,-11,-3]) rotate([0,90,0]) 
            rotate(20) scale([1,0.75,1]) cylinder(d=17, h=20, center=true);
        translate([0,11.5,-6]) rotate([0,90,0]) 
            rotate(10) scale([1,0.75,1]) cylinder(d=17, h=20, center=true);
    }
}
module solid_phalanx(tab_thickness, thumb) {
    $fn=50;
    translate([0,0,8]) intersection() { // bottom of phalanx is at z=0
    translate([0,0,7.0]) cube([50,50,30], center=true); // slice a nice flat bottom for printing
    union() {
        phalanx_body(thumb);
        rotate([0,90,0]) linear_extrude(height=tab_thickness, center=true) hull() {
            translate([2, -10]) circle(d=13);
            translate([(0 && thumb)?3.5:2.5,  12]) circle(d=(0 && thumb)?8:10);
            translate([7,  13]) square(1);
        }
        translate([0,-2.5,4]) intersection() {
            rotate([-10,0,0]) cube([tab_thickness,25,6], center=true);
            cube([6,18.5,10], center=true);
        }
    }
}
}

module cut_phalanx(tab_thickness=5.5, palm_pivot_size=3, knuckle_pivot_size=3, scale_size=1, thumb=false) {
    scale(scale_size) difference() {
        solid_phalanx(tab_thickness=tab_thickness, thumb=thumb);
        // main passage through top
        translate([0,0,5.5+(thumb?7:8)]) rotate([90-(thumb?10:6),0,0]) cylinder(d=2.5,h=50,$fn=20, center=true);
        if(thumb) { // extra clearance around end for elastic on thumb
           translate([0,12,5.3]) rotate([60,0,0]) rotate([0,90,0]) 
            rotate_extrude(angle=110, $fn=60) translate([5,0]) circle(d=2.5, $fn=20); 
        }
        translate([0,0,-6.0+7.5]) rotate([90,0,0]) cube([2,1.5,50], center=true); // cylinder(d=2.5,h=50,$fn=20, center=true);
        translate([0,10,-6.0-3+8]) cube([2,12,6],center=true);
        translate([0,-10,-6.0-3+8]) cube([2,12,6],center=true);
        translate([0,11.3,5.8]) rotate([0,90,0]) cylinder(d=knuckle_pivot_size/scale_size,h=10,$fn=20, center=true);
        translate([0,-11.8,6.0]) rotate([0,90,0]) cylinder(d=palm_pivot_size/scale_size,h=10,$fn=20, center=true);
    }
}


// finger phalanx, may use different attachment to palm and knuckle, two separate sizes.
translate([0,0,0]) cut_phalanx(
    palm_pivot_size=pivot_dia, knuckle_pivot_size=pivot_dia,
    tab_thickness=adjusted_tabwidth, scale_size=global_scale, thumb=false);
// thumb phalanx
translate([30,0,0]) scale([1.1,1,1]) cut_phalanx(
    palm_pivot_size=pivot_dia, knuckle_pivot_size=pivot_dia,
    tab_thickness=adjusted_tabwidth/1.1, scale_size=global_scale, thumb=true);

//long fingertip, keep tolerances the same with scaling using width correction
if(screws) translate([-25,0,0]) adjusted_bolt_holes(global_scale, outer_width=13, 
    offsets=[[[0,-20,9],0],], bolt_dia=pivot_pin_dia, 
    nut_size=nut_size, bolt_head_dia=bolt_head_dia) 
        finger(slotwidth=nominal_slotwidth, thumb=false);
else translate([-25,0,0]) adjusted_holes(global_scale, 
    offsets=[[[0,-20,9],0],], dia=pivot_pin_dia)  
        finger(slotwidth=nominal_slotwidth, thumb=false);
//short fingertip
if(screws) translate([-50,0,0]) adjusted_bolt_holes(global_scale, outer_width=13, 
    offsets=[[[0,-20*0.9,9],0],], bolt_dia=pivot_pin_dia, 
    nut_size=nut_size, bolt_head_dia=bolt_head_dia) scale([1,0.9,1])  
        finger(slotwidth=nominal_slotwidth, thumb=false);
else translate([-50,0,0]) adjusted_holes(global_scale, 
    offsets=[[[0,-20*0.9,9],0],], dia=pivot_pin_dia) scale([1,0.9,1])  
        finger(slotwidth=nominal_slotwidth, thumb=false);
// thumb by scaling regular fingers tips
if(screws) translate([60,0,0]) adjusted_bolt_holes(global_scale, outer_width=13, 
    offsets=[[[0,-20*0.77,9*0.72],0],], bolt_dia=pivot_pin_dia, 
    nut_size=nut_size, bolt_head_dia=bolt_head_dia) scale([1.1,0.77,0.72])  
        finger(slotwidth=nominal_slotwidth/1.1, thumb=true);
else translate([60,0,0]) adjusted_holes(global_scale, 
    offsets=[[[0,-20*0.77,9*0.72],0],], dia=pivot_pin_dia) scale([1.1,0.77,0.72]) 
        finger(slotwidth=nominal_slotwidth/1.1, thumb=true);