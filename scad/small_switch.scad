/************************************************************************

    small_switch.scad
    
    Extreme Networks X435-8P-4S rack mount ears
    Copyright (C) 2024 Simon Inns
    
    This is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
    
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
    Email: simon.inns@gmail.com
    
************************************************************************/

include <BOSL/constants.scad>
use <BOSL/transforms.scad>
use <BOSL/shapes.scad>
use <BOSL/metric_screws.scad>

// Local includes

// Render the body of the switch (dimensions from datasheet)
module switch_body(switch_height, switch_width, switch_depth)
{
    // Main body of the switch
    color([(1/255) * 68, (1/255) * 0, (1/255) * 153]) cuboid([switch_width,switch_depth,switch_height], center=false);

    // Bracket M3 screws at 2mm distance from switch body (to match original bracket thickness)
    xoffset = switch_depth - (76/2);
    yoffset = switch_height / 2;

    // Right side (from front aspect)
    move([0,xoffset,yoffset]) {
        move([-2, -20, -12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_XNEG);
        move([-2,  20, -12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_XNEG);
        move([-2, -20,  12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_XNEG);
        move([-2,  20,  12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_XNEG);
    }

    // Left side (from front aspect)
    move([switch_width,xoffset,yoffset]) {
        move([2, -20, -12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_X);
        move([2,  20, -12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_X);
        move([2, -20,  12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_X);
        move([2,  20,  12.5]) metric_bolt(headtype="countersunk", size=3, l=4, pitch=0, phillips="#1", orient=ORIENT_X);
    }
}

// Render a bracket
module render_bracket_frame(bracket_thickness, bracket_depth, switch_height, switch_width, switch_depth)
{
    move([-bracket_thickness,switch_depth - bracket_depth,0]) cuboid([bracket_thickness,bracket_depth,switch_height], fillet=2, edges=EDGES_X_ALL, center=false);

    difference() {
        union() {
            // Front
            move([-bracket_thickness,switch_depth - bracket_thickness,0]) cuboid([(484 - switch_width)/2,bracket_thickness,switch_height], chamfer=2, edges=EDGES_Y_ALL, center=false);
            move([-bracket_thickness,switch_depth - bracket_thickness-4,0]) cuboid([((484 - switch_width)/2)-22,bracket_thickness,switch_height], chamfer=2, edges=EDGES_Y_ALL, center=false);
            move([-bracket_thickness,switch_depth - bracket_thickness,14]) cuboid([((484 - switch_width)/2),bracket_thickness+4,16], chamfer=2, edges=EDGES_Y_ALL, center=false);

            // Prism cross-brace
            move([6,switch_depth,switch_height/2]) xrot(90) prismoid(size1=[20,switch_height], size2=[0,switch_height], shift=[-10,0], h=20, center=false);

            // Sides (to switch)
            move([30,switch_depth,switch_height/2]) xrot(90) prismoid(size1=[60,6], size2=[0,6], shift=[-30,0], h=60, center=false);
        }

        // Rack mounting screw holes
        move([68,switch_depth-1,switch_height/2]) {
            hull() {
                move([+2,0,+(31.75/2)]) ycyl(h=10, d=7.25, $fn=8);
                move([-2,0,+(31.75/2)]) ycyl(h=10, d=7.25, $fn=8);
            }
            hull() {
                move([+2,0,-(31.75/2)]) ycyl(h=10, d=7.25, $fn=8);
                move([-2,0,-(31.75/2)]) ycyl(h=10, d=7.25, $fn=8);
            }
        }
    }
}

// Note: this is probably unique to the switch model
module render_screwholes(switch_height, switch_depth, bracket_thickness)
{
    xoffset = switch_depth - (76/2);
    yoffset = switch_height / 2;
    
    mirror([180,0,0]) move([bracket_thickness,0,0]) {
        move([0,xoffset,yoffset]) {
            move([-1, -20, -12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
            move([-1,  20, -12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
            move([-1, -20,  12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
            move([-1,  20,  12.5]) cyl(l=4, d=3.25, orient=ORIENT_X);
        }

        move([-(bracket_thickness / 2) - 2,xoffset,yoffset]) {
            move([0, -20, -12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
            move([0,  20, -12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
            move([0, -20,  12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
            move([0,  20,  12.5]) cyl(l=bracket_thickness, d=6, orient=ORIENT_X);
        }
    }
}

module bracket_sub(switch_height, switch_width, switch_depth, isDisplay, bracket_thickness, bracket_depth)
{
    difference() {
        render_bracket_frame(bracket_thickness, bracket_depth, switch_height, switch_width, switch_depth);
        render_screwholes(switch_height, switch_depth, bracket_thickness);
    }
}

module render_bracket(switch_height, switch_width, switch_depth, isDisplay)
{
    bracket_thickness = 4;
    bracket_depth = 76; // Should not exceed switch depth

    if (isDisplay) {
        // Left bracket
        move([switch_width + bracket_thickness,0,0]) {
            bracket_sub(switch_height, switch_width, switch_depth, isDisplay, bracket_thickness, bracket_depth);
        }
    } else {
        // Left bracket
        rotate([0,-90,0]) {
            move([bracket_thickness,-switch_depth, 0]) {
                bracket_sub(switch_height, switch_width, switch_depth, isDisplay, bracket_thickness, bracket_depth);
            }
        }
    }
}

// 19" bracket = 483mm across

// Maximum width = 483.4mm min
// Nominal screw hole distance = 465mm nominal
// System width = 450mm min