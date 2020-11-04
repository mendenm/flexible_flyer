inch=25.4*1; // hidden from customizer by equation, useful for pins
// quick_view renders an incomplete hand for development.
quick_view=false; // [0:full model, 1:leave out slow bits]
// size of hand relative to tiny 100% model
overall_scale=1.25; // [1.0:0.01:2.0]
// size of pivot pins
pivot_size=1.5875; // [1.5:metric 1.5, 1.5875:16th inch, 3.0:3mm screw]
// extra clearance for pivots to adjust for printer tolerances
pivot_extra_clearance=0; // [-0.5:0.01:0.5]
// include fused-in palm mesh?
include_mesh=1; // [0:separate mesh, 1:simplified mesh, 2: phoenix mesh]
// include nice covers for knuckles
include_knuckle_covers=true;
// drill holes for steel pins
pins=true; // [1:steel pins, 0: plastic pins]
// create plugs for steel pins, or leave old holes for plastic pins 
plugs=true; // [1:steel pins, 0: plastic pins]
// use pre-solidified palm to save computation
pre_solidified=""; // ["solidified_palm.3mf": pre_solidified, "":recompute]
// make main object a ghost for debugging
main_ghost=false; // [1:ghost, 0:real]
// set size of channels for strings
string_channel_scale=0.9; // [0.5:0.05:1.0]
// even if using steel pins on the fingers, use plastic pins on the wrist
old_style_wrist=true; // [1:old style, 0:steel wrist pins]
use <pipe.scad>
module channel(waypoints, cutout_length=20, 
    cutout_position=[0,0,0], cutout_angle=0, shapescale=1, bendradius=2, bendsteps=5) {
    // the bends work best if the primary length is along 'x' here,
    // but the hand is along 'y', 
    // so we will adjust the coordinates, 
    // and then re-rotate the whole thing
    shape=[[-1.5,-1],[1.5,-1],
        each 1.5*[for(th=[0:30:179]) [cos(th), sin(th)]]
    ]*shapescale;
    path=[for(w = waypoints) 
        [0,[w[1],-w[0],w[2]],1,
            -90+((len(w)==4)?w[3]:0)]];
    rotate(90) multi_pipe([shape], smooth_bends(path, bendradius, bendsteps));
    if(cutout_length != 0) 
        translate(cutout_position+waypoints[1]+[0,0,5])
            rotate(cutout_angle)
            cube([3,cutout_length,10],center=true);
}

// channel([[0,0,0],[5,30,-2],[5,40,-5],[5,40,-20]]);

module supports() {
    for(dy=[-29:5:10]) translate([0,dy,0]) {
        translate([-7,0.5,21]) cube([52,2,0.5],  center=true);
        translate([-7,0,22]) cube([52,0.4,2],  center=true);
        // translate([-7,0,22]) cube([45,0.4,3],  center=true);
        translate([-7,0,23]) cube([45,0.4,3],  center=true);
        translate([-7,0,23]) cube([30,0.4,3],  center=true);
    }
}

module test_supports() {
    for(dy=[-29:5:10]) translate([0,dy+0.5,0]) {
        translate([-7,0.5,21]) cube([52,2,0.5],  center=true);
        translate([-7,0,21]) intersection() {
            translate([0,1,0]) scale([1,1,0.15]) rotate([90,0,0]) 
                cylinder(d=35, h=2, center=true, $fn=50);
            translate([0,0,5.1]) cube([70,2,10], center=true);
        }
        translate([-7,0,21]) intersection() {
            scale([1,1,0.20]) rotate([90,0,0]) cylinder(d=52, h=0.4, center=true, $fn=50);
            translate([0,0,5.1]) cube([70,2,10], center=true);
        }
    }
}

module rounded_cutter(width=6, radius=1.5, height=20) {
    linear_extrude(height=height, center=false) 
    hull() {
        translate([0,-20]) square([width,1], center=true);
        translate([-width/2+radius,5]) 
            circle(r=radius, $fn=20);
        translate([ width/2-radius,5]) 
            circle(r=radius, $fn=20);
    }    
}

slot_dx=[[[10,0,0],0],[[-4,0,0],0],[[-18,-4,0],0],
    [[-32,-10,0],0]];

module plug_old_channels() {
    translate([-28.6,-49.5,22]) channel(
        [ [6.2,19,4.1], [4,40,3.5],[2.9, 47.5, 3.1],  [1.9,55,1.4], [1.15, 62.5, -1.1],  [0.8,70, -4.7], ],
        cutout_length=0, shapescale=1.2 
    );

    translate([-14.5,-43,24.5]) channel(
        [ [-0.5,13,3], [0,40,3.2], [0,55,1], [0.8,68, -5.5] ],
        cutout_length=0, shapescale=1.2   
    );

    translate([-0.3,-39,25.5]) channel(
        [ [-7,9,2.2], [-3.5,40,1.8], [-2.75, 47.5, 1.8],  [-2,55,1.0], [-1,62.5,-1], [0,69, -5],  ],
        cutout_length=0, shapescale=1.1      
    );    

    translate([13.5,-39,23.5]) channel(
        [ [-13.,9,3.7], [-8.5,30,3.5], [-6.5,40,3], [-4.75, 47.5, 2.6], [-3,55,0.9], [-0.4,69, -5.5], ],
        cutout_length=0, shapescale=1.1          
    );

    translate([21.2,-39,22]) channel(
        [ [-13.5,9.8,4], [-10.5,30,3,5], [-8.4,39,3.1,15], [-3,44,0,35], [2,46,-5,50]  ],
        cutout_length=0, shapescale=1.3, bendradius=10          
    );

    // fix ugly bend
    intersection() {
        union() {
            translate([21.2,-39,22]) channel(
                [ [-13.5,9.8,4], [-10.5,30,3,5], [-8.4,39,3.1,15], [-1.7,44,0.5,35], [2,46,-5,50]  ],
                cutout_length=0, shapescale=1.3, bendradius=10          
            );
            translate([20,7,25]) rotate([30,-30,0]) translate([-2,-3,-2]) cylinder(d=5,h=12, $fn=20, center=true);
        }
        translate([9.8,0,12]) rotate([85,0,-5]) cylinder(d=30,h=20, $fn=50, center=true);
    }
    translate([23.5,6.5,0.05]) cylinder(d=4.5, h=18.5, $fn=20); 
 
    for(v=[[13.5,31,18], [-0.5,31,21.0], [-14.2,27,20],  [-28.5,21,18],
        
        ]) translate([v.x,v.y,0]) cylinder(d=4,h=v.z,$fn=20);
}

module reborn_channels() {
    // pinkie string
    translate([-29.6,-48.5,21]) channel(
        [ [7.6,0,6], [3,40,3], [1.8,55,2.4], [1.0,70, -5], [1.0,70,-18] ],
        cutout_position=[0,0,0], cutout_angle=[-5,0,8], cutout_length=0, 
        shapescale=string_channel_scale/overall_scale,
        bendradius=5, bendsteps=5
    );
    // pinkie elastic
    translate([-26.6,-48.5,22]) channel(
        [ [7.5,0,5.2], [4.4,30,3.2], [3,45,2.5], [1.8,55,1.5], [-1.0,70, -6], [-1.0,70,-19] ],
        cutout_position=[0,0,0], cutout_angle=[-5,0,8], cutout_length=0, 
        shapescale=string_channel_scale/overall_scale,
        bendradius=5, bendsteps=5
    );
    // pinkie threading assist
    translate([-28,23,15]) cube([3,3,5], center=true);
    // ring elastic
    translate([-14.5,-43,24]) channel(
        [ [-1,0,2], [-1,40,3], [-1,58,1], [-0.5,71, -7], [-0.5,71,-22] ],
        cutout_position=[0,-6,0], cutout_angle=[-5,0,-2], cutout_length=0, 
        shapescale=string_channel_scale/overall_scale,
        bendradius=5, bendsteps=5   
    );
    // ring string
    translate([-14.5,-43,24]) channel(
        [ [2,0,2.5], [2.5,38,4], [2,55,2], [0.5,71, -7], [0.5,71,-22] ],
        cutout_position=[0,-6,0], cutout_angle=[-5,0,-2], cutout_length=0, 
        shapescale=string_channel_scale/overall_scale,
        bendradius=5, bendsteps=5   
    );
    // ring threading assist
    translate([-14.5,29.5,15]) cube([3,3,5], center=true);
    // middle string
    translate([-0.3,-39,25.5]) channel(
        [ [-7,0,1], [-4,40,1], [-2.5,55,0], [-0.5,71, -7], [-0.5,71,-22] ],
        cutout_position=[-1.,-10,-1], cutout_angle=-6, cutout_length=0,         
        shapescale=string_channel_scale/overall_scale,
        bendradius=5, bendsteps=5   
    );  
    // middle elastic  
    translate([-0.3,-39,25.5]) channel(
        [ [-4,0,1], [-0.5,40,1], [0,55,0], [0.5,71, -7], [0.5,71,-22] ],
        cutout_position=[-1.,-10,-1], cutout_angle=-6, cutout_length=0,         
        shapescale=string_channel_scale/overall_scale,
        bendradius=5, bendsteps=5  
    );  
    // ring threading assist
    translate([-0.2,33,17]) cube([3,3,5], center=true);
    // index elastic  
    translate([13.5,-39,23.5]) channel(
        [ [-13.5,6,3], [-8.5,30,3], [-6.5,40,2.5], [-4,55,0], [-0.5,71, -7], [-0.5,71,-20] ],
        cutout_position=[0,0,-1], cutout_angle=[-5,0,-10], cutout_length=0,         
        shapescale=string_channel_scale/overall_scale,
        bendradius=5, bendsteps=5        
    );
    // index string
    translate([13.5,-39,23.5]) channel(
        [ [-10,6,3], [-5,30,3], [-3,40,2.5], [-1,55,0], [0.5,71, -7.5], [0.5,71,-20] ],
        cutout_position=[0,0,-1], cutout_angle=[-5,0,-10], cutout_length=0,         
        shapescale=string_channel_scale/overall_scale,
        bendradius=5, bendsteps=5        
    );
    // ring threading assist
    translate([13.6,33,15]) cube([3,3,5], center=true);
    //thumb plumbing
    // thia may get crowded around the bend, so we make this channel smaller than the others
    translate([21.2,-39,22]) channel(
        [ [-13.5,8,4], [-10,25,3], [-7.0,34,2.0], [-1.5,39,-1.25,15]  ],
        cutout_length=0, 
        shapescale=0.7*string_channel_scale/overall_scale,
        bendradius=5, bendsteps=3        
    );
    translate([18,-1,11]) rotate([90,0,30]) rotate_extrude(angle=80, $fn=16) translate([10,0]) circle(d=2.2*string_channel_scale/overall_scale, $fn=8);
    translate([19.7,-0.0,20.7]) sphere(d=2.8*string_channel_scale/overall_scale, $fn=12); // just to clean up joint
    
}

module knuckles() {
    // re-insert clean finger stops
        for(dx=slot_dx) translate(dx[0]+[3.7,38.5,12.5]) 
            rotate([90,0,-90+dx[1]]) linear_extrude(height=8, center=true)
                hull() {
                    translate([5,0]) square([0.1,3]);
                    translate([0,0.5]) circle(1, $fn=10);
                };
    // smooth covers for knuckles
    // compute individul offsets to place them nicely
    cover_dx=[
        [[-1,-4,-2.25],[-115,0,-3],3],
        [[0,-2,.75],[-125,0,0],2],
        [[1,-3,-0.25],[-120,0,3],2],
        [[1,-4,-2.35],[-115,0,3],3]
    ];
                
    if(include_knuckle_covers) for(idx=[0:3]) translate(cover_dx[idx][0]+slot_dx[idx][0]+[3.7,25,23]) {
        intersection() {
            rotate(cover_dx[idx][1]) difference() {
                hull() {
                    scale([1,0.5,1]) cylinder(d=10, h=0.1, $fn=20);
                    translate([0,0,19]) cylinder(d=10,h=0.1, $fn=20);
                }
                hull() {
                    translate([0,0,-1]) scale([1,0.5,1]) cylinder(d=8, h=0.1, $fn=6);
                    translate([0,0,21]) cylinder(d=8,h=0.1, $fn=6);
                }
                translate([0,10,-1]) cube([20,20,50], center=true);
            }
            translate([0,cover_dx[idx][2],0]) cube([15,30,20], center=true);
        }
    }
}

module main_palm() {
    difference() {
        union() {
            // translate([0,0,15.2]) import("Reborn_palm_Left.3mf", convexity=10);
            if(!main_ghost) 
                import("palm_left_v2_nobox.stl", convexity=10);
            else
                %import("palm_left_v2_nobox.stl", convexity=10);
                
            if(!main_ghost) supports();
            if(include_mesh==1) mesh();
            else if (include_mesh==2) phoenix_mesh();
            if(!main_ghost && !quick_view) plug_old_channels();
        }
        if(!quick_view) reborn_channels();
    }
};


// plug up all holes and slots which need to be parametric
module chamfered_cylinder(d=20, h=20, center=true)
{
    union() {
        cylinder(d=d, h=h-1, center=true);
        translate([0,0,h/2-.51]) cylinder(d1=d, d2=d-1, h=0.5);
        translate([0,0,-h/2+0.01]) cylinder(d1=d-1, d2=d, h=0.5);
    }
}

pin_coordinates=[
    [[-35.4,-38,8],[0,90,0]], //left wrist
    [[20.68,-38,8],,[0,90,0]], // right wrist
    [[6.6,39.5,6.0],[0,90,0]], // index and middle finger
    [[-16,35.5,6.0],[0,90,0]], // ring finger
    [[-29.5,29.5,6.0],[0,90,0]], // pinky
    [[31,0,6.0],[0,90,50]], // thumb

];

module plugs(size_scale=1, chop=false) {
    // wrist pins, maybe these aren't parametric for now
    chopper=[13,13,30];
    
    if(!old_style_wrist) {
        translate(pin_coordinates[0][0]) rotate(pin_coordinates[0][1]) 
            cylinder(d=10,h=4.99, center=true);
        translate(pin_coordinates[1][0]) rotate(pin_coordinates[1][1]) 
            cylinder(d=10,h=4.99, center=true);
    }
    // index and middle combined pin
    translate(pin_coordinates[2][0]) rotate(pin_coordinates[2][1]) 
        scale(size_scale) intersection() {
            chamfered_cylinder(d=8,h=27.5, center=true, $fn=16);
            if(chop) translate([6,6,0]) rotate(45) cube(chopper, center=true);
        }
    // ring pin
    translate(pin_coordinates[3][0]) rotate(pin_coordinates[3][1]) 
        scale(size_scale) intersection() {
            chamfered_cylinder(d=11,h=11, center=true, $fn=16);
            if(chop) translate([6,6,0]) rotate(45) cube(chopper, center=true);
        }
    // pinky pin
    translate(pin_coordinates[4][0]) rotate(pin_coordinates[4][1]) 
        scale(size_scale) intersection() {
            chamfered_cylinder(d=11,h=11.5, center=true, $fn=16);
            if(chop) translate([6,6,0]) rotate(45) cube(chopper, center=true);
        }
    // thumb pin
    translate(pin_coordinates[5][0]) rotate(pin_coordinates[5][1]) 
        scale(size_scale) intersection() {
            chamfered_cylinder(d=11,h=16, center=true, $fn=16);
            if(chop) rotate(-45) translate([6,6,0]) cube(chopper, center=true);
        }
 }

module mesh(mesh_thickness=2) {
    holes=[ // plug all screw holes
            [8.7,62.6], [7.7,51.7], [6.5,40.6], [6.9,28.4],
            [10.1,19.4], [22.7,13], [36.6,7.4], [50.6,6.1], [62.5,10], 
            [65.6, 17.3], [66.5,26.6], [66.0,47.4], [64.7, 60.2], 
        ];
    
    // convenient aliases
    m2=mesh_thickness/2;
    m4=mesh_thickness/4;
    m1=mesh_thickness;
    
    for(dy=[-30:10:20]) translate([-7,dy,(dy==-30)?m2:m4])
        cube([60,5,(dy==-30)?m1:m2], center=true);
    for(dx=[-20:10:20]) translate([-7+dx,-1,3*m4])
        cube([5,62,m2], center=true);

    translate([-43.6,37.1,0]) scale([1,-1,1]) // flip chirality 
        for(xy=holes) translate([each xy, 0.001]) cylinder(d=3.5, h=13, $fn=16);
}

module phoenix_mesh() {
    holes=[ // plug all screw holes
            [8.7,62.6], [7.7,51.7], [6.5,40.6], [6.9,28.4],
            [10.1,19.4], [22.7,13], [36.6,7.4], [50.6,6.1], [62.5,10], 
            [65.6, 17.3], [66.5,26.6], [66.0,47.4], [64.7, 60.2], 
        ];
    
    translate([-43.6,37.1,0]) scale([1,-1,1]) // flip chirality 
    // the mesh is defective, project and re-extrude to fix it
    union() {
    linear_extrude(height=1) 
        union() {
            projection() 
                translate([73,2,-1]) import("reborn_palm_mesh_thick_left.stl", convexity=10);
            // close up holes in 2d first
            for(xy=holes) translate(xy) circle(d=4, $fn=8);
        }
        // create pins in 3d to plug holes in palm, too
        for(xy=holes) translate([each xy, 0.1]) cylinder(d=3.5, h=13, $fn=16);
    }
}

module drilling(palm_scale, finger_scale, 
    pin_dia, pin23_length, pin45_length, pin_1_length,
    pin_head_square, pins=true)
// drill out everything that needs to be done to attach fingers and wrist pins
// with proper scaling for pins and slots
// this is where all the parmetric processes happen.  
// they are done by inverse-scaling objects by the hand scale, so when the whole object is scaled,
// they come out the expected size.
// this assumes the 1x-scaled finger has a slot width of 6 mm
{
    base_slot_width=6;
    base_rotation_offset=6; // distance of nominal pin center from front of hand, half of cylinder diameter of 12 mm
    // cut out finger slots
    for(dx=slot_dx) translate(dx[0]+[3.7,43,-10]) 
        rotate(dx[1]+180) translate([0,5,5]) 
            rounded_cutter(width=base_slot_width*finger_scale/palm_scale, height=40);
    // make holes for pins
    center_offset=[0, base_rotation_offset*(palm_scale/finger_scale-1), 0];
    if(pins) {
    translate(pin_coordinates[2][0]+center_offset) rotate(pin_coordinates[2][1]) 
        cylinder(d=pin_dia, h=30, $fn=20, center=true);
    translate(pin_coordinates[3][0]+center_offset) rotate(pin_coordinates[3][1]) 
        cylinder(d=pin_dia, h=15, $fn=20, center=true);
    translate(pin_coordinates[4][0]+center_offset) rotate(pin_coordinates[4][1]) 
        cylinder(d=pin_dia, h=15, $fn=20, center=true);    
    translate(pin_coordinates[5][0]+center_offset) rotate(pin_coordinates[5][1]) 
        cylinder(d=pin_dia, h=17, $fn=20, center=true);
    }
    // block to mill out old rubber-band attachment for thumb
    if(!pre_solidified) translate([30,0,-5]) rotate(49.5) {
        translate([0.55,-6,0]) 
        rounded_cutter(width=base_slot_width*finger_scale/palm_scale, height=30);
        translate([0.55,-4,8]) cube([6,20,20], center=true);
    }
}

module scaled_palm(palm_scale=1, finger_scale=1, 
    pin_dia=3, pin23_length=25, pin45_length=10, pin_1_length=15,
    pin_head_square=[6,4], pins=true
) {
    scale(palm_scale) 
    union() {
        difference() {
            if (len(pre_solidified)==0) union() {
                main_palm(); 
                if(plugs) plugs();
            }
            else {
                if(!main_ghost) difference() {
                    !import(pre_solidified, convexity=10);
                    reborn_channels();
                } else { %render() difference() {
                    import(pre_solidified, convexity=10);
                    reborn_channels(); }
                }
            }
            translate([0,-31.5,30]) cube([100,5,20], center=true); // shave end
            drilling(
                palm_scale=palm_scale, finger_scale=finger_scale, 
                pin_dia=pin_dia, pin23_length=pin23_length, pin45_length=pin45_length, pin_1_length=pin_1_length,
                pin_head_square=pin_head_square, pins=pins
            );
        }
    
    knuckles(); // insert backstops and knuckle covers
        
    // add cylindrical pin for thumb
        translate([30,-5,15]) 
        rotate([0,90,50]) 
        translate([0,0,5]) cylinder(d=4, h=8, center=true, $fn=20);
    }
    // small bar at top of thumb slot to fix hanging hole
    translate([30,0,16.3]) rotate(49.5) translate([5,-0.8,0]) cube([10,1,1], center=true);
    translate([30,0,16.6]) rotate(49.5) translate([3.9,1,0]) cube([1,4,1], center=true);
    translate([30,0,16.6]) rotate(49.5) translate([6.8,1,0]) cube([1,4,1], center=true);

}

scaled_palm(palm_scale=overall_scale, finger_scale=overall_scale, 
    pin_dia=pivot_size/overall_scale, pins=pins);
