include <MCAD/servos.scad>
include <MCAD/metric_fastners.scad>
include <BOSL2/std.scad>
include <BOSL2/gears.scad>


/* [Display] */
show_frame = true;
show_simpleframe = false;
show_reset = true;
show_gear = true;
show_pivot = true;
show_spot = false;
show_duck = false;

/* [Animations] */
servo_twist = -35;
target_twist = 0;


/* [Hinges] */
bar_length = 32;
bar_dia = 4.0;

/* [Assorted Adjustments */
bar_height = 30;
hold_height = bar_height + 25;
bar_inset = 8.5;
bar_offset = 20;

/* [Printing] */
// how much clearance to allow around the target arm
target_clear = 0.1;

show_onepivot = false;
show_onespot = false;
show_oneduck = false;


/* [Hidden] */
$fa = 1;
$fs = 0.5;



target_thick = 3.2 + 0.1;
target_drop = 60;
target_base = 30;
target_width = 5 - target_clear;

disc_dia = 35;
disc_thick = 4;


// make the side bar
strut_thick = 5;

// supports for bars and things, assume 8mm bar + 2mm clearance
strut_depth = 12;
wall_thick = 3;

// thickness of the front and back of the target holder/pivot
holder_thick = 2;
holder_width = 5;
pivot_thick = 3;

// servo positioning
servo_offset = bar_offset + 23;
servo_inset = 14;
servo_height = 15;
reset_arm_len = 26; 
reset_finger = 16;
gear_od = 5;   // size of the gears
gear_teeth = 17;

// extra clearance underneath for the wiring
wires = 6; //6;




// the pivoting arm 
module pivot(l=100, w=5, thick=1) {
    difference() {
        union() {
            arm_thick = target_thick+1;
            rotate([-90,0,90])
                linear_extrude(thick)
             polygon(points=[[0,0],[w,0],[w,strut_depth],[arm_thick+wall_thick+target_clear*2,target_base],[0,l]]);
    translate([-thick,w-strut_depth,0]) 
                cuboid([thick, strut_depth, bar_offset-strut_depth/2], anchor=[-1,-1,-1], rounding=5, edges=[FWD+TOP]);
            translate([0,w-strut_depth,0]) rotate([90,0,-90])
                fillet(r=8, h=thick);
        }
        union() {
                // round the corners
                translate([0.1,-0.1,0.1]) rotate([-90,0,90])
                    fillet(r=2, h=thick+0.2);
        }
    }
}


// the target holder and pivot mechanism
module target_holder() {
    spread = holder_width;
    pivot_depth = strut_depth/2 + bar_offset - 3;
    face_shift = pivot_depth - strut_depth/2; 
    translate([0,-face_shift,strut_depth/2]) 
        union() {
            
            translate([-spread,0,0]) 
                pivot(target_base, pivot_depth, pivot_thick);
            translate([spread,0,0]) 
                pivot(target_base, pivot_depth, pivot_thick);
            
            // plate to join the two pivots and the arm together
            translate([-spread-pivot_thick,0,-target_base])
                cube([spread*2+pivot_thick, holder_thick+0.01, target_base-2]);
#            translate([-spread-pivot_thick,pivot_thick+holder_thick+target_clear*2,-target_base])
                cube([spread*2+pivot_thick, holder_thick+1.01, target_base]);
                
            // extra weight
     *       back(11) right(5) cuboid([1.5,12,14], anchor=[-1,-1,-1], rounding=5, edges=[FWD+TOP]);
            
        }
}


// the plugin default spot target
module target_spot(drop=60)
{
    face_shift = bar_offset -holder_thick*2;
        
    translate([0,-face_shift,strut_depth/2])  {
        // the verticle arm
        translate([-target_width, 0, -drop-10]) 
            cube([target_width*2-target_thick, target_thick, drop]);
 
        // strengthening arms
        strarm = drop-target_base+disc_dia/2;
        translate([-target_width, target_thick-0.5, -strarm-target_base])
            cube([2,3,strarm]);
        translate([-0.3, target_thick-0.5, -strarm-target_base])
            cube([2,3,strarm]);
       
        // round those corners
        rotate([-90,0,0]) translate([target_width-target_thick-0.05,target_base,0])
            fillet(r=2, h=target_thick+2.49);
        translate([-target_width+0.1,target_thick+2.49,-target_base]) 
            rotate([90,180,0])
                fillet(r=2, h=target_thick+2.49);
        
        // the spot you shoot at
        translate([-target_thick/2,-0.01,-drop-10])
            rotate([-90,0,0]) color("white")
            cylinder(h=disc_thick, d=disc_dia);
    }

}

// the plugin alternate spot target
module target_duck(drop=60)
{
    face_shift = bar_offset -holder_thick*2;
        
    translate([0,-face_shift,strut_depth/2])  {
        // the verticle arm
        translate([-target_width, 0, -drop-10]) 
            cube([target_width*2-target_thick, target_thick, drop]);
 
        // strengthening arms
        strarm = drop-target_base+disc_dia/2;
        translate([-target_width, target_thick-0.5, -strarm-target_base])
            cube([2,3,strarm]);
        translate([-0.3, target_thick-0.5, -strarm-target_base])
            cube([2,3,strarm]);
       
        // round those corners
        rotate([-90,0,0]) translate([target_width-target_thick-0.05,target_base,0])
            fillet(r=2, h=target_thick+2.49);
        translate([-target_width+0.1,target_thick+2.49,-target_base]) 
            rotate([90,180,0])
                fillet(r=2, h=target_thick+2.49);
        
        // the spot you shoot at
        translate([-20,disc_thick/2-0.01,-drop])
            rotate([-90,0,0]) color("white")
            scale([0.7,0.7,1])
            linear_extrude(height=disc_thick, center=true)
            import("duck.dxf");

//            cylinder(h=disc_thick, d=disc_dia);

    }

}



// IR slot sensor
module slot_sensor(cutout=0)
{
    $fn=30;
    part_w = 6.2;
    slot_d = 8.2;
    base_d = 2.6;
    difference() {
        union() {
            linear_extrude(base_d) 
            hull() {
                circle(d=part_w);
                translate([20,0,0]) circle(d=part_w);
            }
            translate([2.8,-part_w/2,base_d]) cube([4.1, part_w, slot_d]);
            translate([2.8+10,-part_w/2,base_d]) cube([4.1, part_w, slot_d]);
            
            if (cutout==1) {
                translate([0,0,-5]) cylinder(d=3, h=10, $fn=30);
                translate([20,0,-5]) cylinder(d=3, h=10, $fn=30);
                translate([6, 10, 0]) cube([8, 3, 1.5]);
                
            translate([2.6,-part_w/2-0.2,base_d]) cube([4.5, part_w+0.4, slot_d]);
            translate([2.6+10,-part_w/2-0.2,base_d]) cube([4.5, part_w+0.4, slot_d]);
                
            }
                
        }
        union() {
            if (cutout == 0) {
                translate([0,0,-2]) cylinder(d=3, h=10, $fn=30);
                translate([20,0,-5]) cylinder(d=3, h=10, $fn=30);
            }
        }
    }
}


        



// utility functions
module fillet(r=10, h=5) {
    difference() {
        cube([r,r,h]);
        translate([r,r,-0.1]) cylinder(r=r, h=h+0.2);
    }
}


// Basic SG90 servo arm
module sg90_arm(sliderWithMax = 16) {
    difference() {
        union() {
            linear_extrude(height=1.4)
                difference() {

                    hull() {
                        circle(d=6,$fn = 100);
                        translate([sliderWithMax-2,0]) circle(d=4,$fn = 100);
                    }

           *         translate([4,0]) for (i=[0:sliderWithMax/2-3]) translate([i*2,0]) circle(d=1,$fn = 100);
                }
            cylinder(d=6.7+0.4, h=3.8, $fn=100);
        }
      *  translate([0,0,-1]) cylinder(d=2.5, h=3.8+2, $fn=100);
     *   translate([0,0,-1]) cylinder(d=4.7, h=1+1, $fn=100);    
  *    translate([0,0,3.8-2+1]) cylinder(d=4.7, h=2+1);    
    }
}


module reset_arm()
{
    // reset mechanism
    rotate([servo_twist,0,0]) {
      *  translate([28,0,0]) 
            rotate([90,0,90]) sg90_arm(14); 
        
        translate([25,0,0])
            rotate([90,0,90])
            spur_gear(circ_pitch=gear_od, thickness=3, teeth=gear_teeth);
        
        translate([24,0,0])
            rotate([90,0,90])
            cylinder(h=7.5, d=8);
        
        translate([-1.2,0,0]) {
            translate([28.7,-5,-4])
                cube([2.5, reset_arm_len-10, 8]);
            
            translate([28.7,reset_arm_len-15,0]) rotate([0,90,0])
                cylinder(d=8, h=2.5);
            
            translate([0,reset_arm_len-14,0])
                translate([30,-2,-2])
                cube([reset_finger, 4, 4]);
            
            translate([31.2,reset_arm_len-16,2]) 
                rotate([180,0,0]) 
                fillet(r=3, h=4);
        }
    }  
}

module pivot_support(isleft=false)
{
    translate([0, bar_offset, bar_height])  {
        translate([0,-21,-7])
            cube([5, 21, 14]);
        rotate([0,90,0]) cylinder(d=14, h=5);
    }
}


// support frame
module support_frame(lift) {
    front_width = bar_inset + servo_inset + 16;
    
    // pivot screw holder
    right(8.5-10.5) pivot_support(false);
    right(8.5+17) pivot_support(true);

    // front rest plate
    plate_depth = hold_height - (bar_height + strut_depth/2);
    translate([-2,-1,hold_height - plate_depth])
        cube([front_width+5, wall_thick+0.5, plate_depth]);

    // servo mount
    translate([servo_inset+2,servo_offset-7,-lift])
        cube([wall_thick, 28.0, 20+lift]);
    translate([servo_inset+3.5,servo_offset-12,7])
        prismoid(size1=[wall_thick,10], size2=[wall_thick,0], shift=[0,5], h=13);
    translate([servo_inset+3.5,servo_offset-7,-6])
        prismoid(size1=[wall_thick,0], size2=[wall_thick,10], shift=[0,-5], h=13);
   
   
    // outside leg
    translate([front_width, 2, -lift])
        cuboid([wall_thick, 8+lift, 62], anchor=[-1,1,-1], rounding=-3, edges=[BOT+LEFT], orient=BACK);
    
    // plate to hold position detector
    translate([front_width-servo_inset-16,-1,7]) cube([servo_inset+16, 65, 1]);
}

module simple_frame(lift) {
    front_width = bar_inset + servo_inset + 16;
    // pivot screw holder
    right(8.5-2.0) pivot_support(false);
    right(8.5+17) pivot_support(true);

        // front rest plate
    plate_depth = hold_height - (bar_height + strut_depth/2);
    translate([-2,-1,hold_height - plate_depth])
        cube([front_width+5, wall_thick+0.5, plate_depth]);
   
    // outside leg
 *   translate([front_width, -2, -lift])
        cube([wall_thick, 66, 8+lift]);

}



// ------------------------------------------
// main
module full_mech(lift)
{
    difference() {
    union() {
        
        // reset arm
        if (show_reset) color("pink")
        translate([bar_inset-28.5, bar_offset, bar_height])
            reset_arm();
        
        // servo gear 
        if (show_gear) color("red")
        translate([bar_inset+servo_inset-17.5,servo_offset,servo_height]) {
            rotate([90,0,90])
            spur_gear(circ_pitch=gear_od, thickness=3, teeth=gear_teeth);
            left(0.5) 
                rotate([90,0,90]) sg90_arm(6); 
        }
        
          // swinging targets //bar_offset+bar_dia/2
        translate([bar_inset+8.5,bar_offset,bar_height])  {
            rotate([target_twist,180,0]) translate([0,0,0]) {
                if (show_spot)
                    target_spot(target_drop);
                if (show_duck)
                    target_duck(target_drop);
                if (show_pivot) color("green")
                    target_holder();
            }
        }
        
        // support frame
        if (show_simpleframe)
            simple_frame(lift+wires);
            
        if (show_frame)
            support_frame(lift+wires);
    }
    
    union() {
        // remove the pivot axis screw
        translate([bar_inset-8,bar_offset,bar_height])
            rotate([0,90,0]) {
  #              scale([1.1,1.1,1]) cap_bolt(4, bar_length);          
                translate([0,0,-3.9]) cylinder(d=7.2, h=4);
            }

        if (show_frame) {
        // space for a securing nut on the pivot screw
        translate([bar_inset+20,bar_offset,bar_height]) {
        #        rotate([0,90,0]) scale([1.1,1.1,1]) flat_nut(4.3);
                rotate([0,90,0]) cylinder(d=5, h=2.1);
        }

        // servo body cutout
        translate([41.9+bar_inset-servo_inset+1,servo_offset,servo_height]) {
   #         towerprosg90([0,0,0], [270,0,90], screws=1, cables=0); 
            translate([-22,18.8,0]) rotate([0,90,0]) cylinder(d=2.6, h=8);
            translate([-22,-8.2,0]) rotate([0,90,0]) cylinder(d=2.6, h=8);
        }
            
        // servo wires cutout
        translate([38+bar_inset-servo_inset,servo_offset-10,4.2]) 
      #      cube([3, 8, 5]);

        // detect pivot/target position
   #     translate([5.5+bar_inset,bar_offset-2,4.2]) slot_sensor(cutout=1);

        }

        // servo arm
        if (show_gear)
        translate([bar_inset+servo_inset-17.5,servo_offset,servo_height])
            rotate([servo_twist,0,0]) 
                translate([0,0,0]) rotate([90,0,90]) {
                    translate([0,0,-2]) cylinder(d=2.5, h=3.8+3, $fn=100);
                    translate([0,0,-4.0]) cylinder(d=4.7, h=1+2, $fn=100);    
                    translate([0,0,3.8-3.5]) cylinder(d=4.7+0.2, h=2+1.5);    

                } 
                
    }
    }
}


if (show_onepivot) {
    difference() {
        translate([bar_inset+8.5,bar_offset,bar_height])
            rotate([target_twist,180,0])
            target_holder(); 
            translate([bar_inset-8,bar_offset,bar_height])
            rotate([0,90,0]) {
                scale([1.1,1.1,1]) cap_bolt(4, bar_length);          
                translate([0,0,-3.9]) cylinder(d=7.2, h=4);
            }
        }
}
if (show_onespot) target_spot();
if (show_oneduck) target_duck(60);



if (show_frame) {
translate([0,0,0]) full_mech(0);
translate([40,0,10]) full_mech(10);
translate([80,0,0]) full_mech(0);
translate([120,0,10]) full_mech(10);
translate([160,0,0]) full_mech(0);
} else {
full_mech(0);
}

frame_width = 40*4 + 40 - 1.5;

if (show_frame || show_simpleframe) {
    // outside leg
    translate([-2,2.0,-wires])
        xrot(-90) cuboid([wall_thick, 18+wires, 50], anchor=[-1,1,-1], edges=[BOT+RIGHT], rounding=-3);
    // front cover
    translate([-2,-2,-wires]) {
        cube([frame_width+5, 1, hold_height+wires+8]);
        cube([frame_width+5, 4, 18+wires]);
    }
    // strengthening along the top
    translate([-2,-2, hold_height+wires-6])
        cube([frame_width+5, 4.5, 10]);
    // strengthen down the edge
    translate([frame_width-9,-2, -wires])
        cube([12, 4.5, hold_height+wires+8]);
        
    // extra support leg
    if (show_simpleframe)
   # translate([frame_width,2.5,-wires])
        xrot(-90) cuboid([wall_thick, 18+wires, 50], anchor=[-1,1,-1], edges=[BOT+LEFT], rounding=-3);
    
}