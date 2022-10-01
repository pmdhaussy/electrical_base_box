$fn=360;
width=65;
height=width;
thickness=20;
wall_thickness=2;
support_diameter=6;
support_hole_diameter=2;

cover_thickness=2;
cover_hole_diameter=3;
cover_screw_head_hole_diameter=6;

internal_width=width-2*wall_thickness;
internal_height=height-2*wall_thickness;
support_radius=support_diameter/2;
support_hole_radius=support_hole_diameter/2;
support_spacing=wall_thickness+support_radius-1;
cover_hole_radius=cover_hole_diameter/2;
cover_screw_head_hole_radius=cover_screw_head_hole_diameter/2;

// box();
// box_with_cable_entry();
// box_45mm_with_cable_entry();
// cover();
// translate([80, 0, 0]) cover();
cover_with_12mm_holes();
// cover_with_13mm_buttons();

module box_with_cable_entry() {
    difference() {
        box();
        translate([-10, 8, wall_thickness])
            cube([45, 50, 6]);
    }
}

module cover_with_13mm_buttons() {
    difference() {
        cover();
        translate([15, 15, -1])
            cube([13, 19, 4]);
        translate([width-15-13, height-15-19, -1])
            cube([13, 19, 4]);
    }
}

module cover_with_12mm_holes() {
    position1_x = 3*(width/10);
    position1_y = height/2;
    position2_x = 7*(width/10);
    position2_y = position1_y;
    difference() {
        cover();
        // Left hole
        translate([position1_x, position1_y, -1])
            cylinder(cover_thickness + 2, 6, 6);
        // Right decoration hole
        translate([position2_x, position2_y, 2])
            cylinder(cover_thickness, 6, 6);
        // Top arrow
        translate([position1_x-1.5, 43, 2])
            cube([3, 6, 10]);
        translate([position1_x-3, 48, 2])
            triangle(scale=6, height=10);
        // Bottom arrow
        translate([position1_x-1.5, 16, 2])
            cube([3, 6, 10]);
        translate([22.5, 17, 2])
            rotate([0, 0, 180])
                triangle(scale=6, height=10);
    }
    // anti-rotation index
    translate([position1_x-0.9, 26.5, 0])
        cube([1.8, 0.8, cover_thickness]);
}

module triangle(scale=1, height=1, center=true) {
    linear_extrude(height, center) {
        polygon(
            points = [
                [0, 0],
                [0.5*scale, 1*scale],
                [1*scale, 0]
            ]
        );
    }
}

// ------------------------------------------------------------

module box() {
    union() {
        difference() {
            minkowski() {
                cube([width, height, thickness]);
                cylinder(1, center=true);
            }
            translate([wall_thickness, wall_thickness, wall_thickness])
                cube([internal_width, internal_height, thickness]);
        }
        translate([support_spacing, support_spacing, 0])
            support();
        translate([support_spacing, height-support_spacing, 0])
            support();
        translate([width-support_spacing, height-support_spacing, 0])
            support();
        translate([width-support_spacing, support_spacing, 0])
            support();
    }
}

module support() {
    difference() {
        cylinder(thickness-0.5, support_radius, support_radius);
        cylinder(thickness+1, support_hole_radius, support_hole_radius);
    }
}

// ------------------------------------------------------------


module cover() {
    difference() {
        union() {
            difference() {
                minkowski() {
                    cube([width, height, cover_thickness]);
                    cylinder(1, center=true);
                }
                translate([-2, -2, -1])
                    cube([width+4, height+4, 1]);
            }
            // Placement recess
            translate([wall_thickness, wall_thickness, -0.99])
                cube([internal_width, internal_height, 0.99]);
        }
        translate([support_spacing, support_spacing, -1])
            cover_hole();
        translate([support_spacing, height-support_spacing, -1])
            cover_hole();
        translate([width-support_spacing, height-support_spacing, -1])
            cover_hole();
        translate([width-support_spacing, support_spacing, -1])
            cover_hole();
    }
}

module cover_hole() {
    cylinder(cover_thickness+2, cover_hole_radius, cover_hole_radius);
    translate([0, 0, 2])
        cylinder(cover_thickness+1, cover_screw_head_hole_radius, cover_screw_head_hole_radius);
}
