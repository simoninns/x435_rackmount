/************************************************************************

	x435_8p_4s.scad
    
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

// Local includes
include <small_switch.scad>

// Render the objects (display = false = render for printing)
module render_x435_8P_4S(isDisplay)
{
    // All measurements in mm
    switch_height = 43.5;
    switch_width = 320;
    switch_depth = 200;

    if (isDisplay) {
        switch_body(switch_height, switch_width, switch_depth);
        render_bracket(switch_height, switch_width, switch_depth, isDisplay);
        xflip() move([-switch_width,0,0]) render_bracket(switch_height, switch_width, switch_depth, isDisplay);
    } else {
        render_bracket(switch_height, switch_width, switch_depth, isDisplay);
    }
}
