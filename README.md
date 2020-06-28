# The Flexible Flyer

## Overview

This repository contains a couple of different but closely related, projects.  It is derived from a mix of the [Phoenix v2](https://www.thingiverse.com/thing:1453190), the [Unlimbited Phoenix v3](https://www.thingiverse.com/thing:1674320), and the [Phoenix Reborn](https://www.thingiverse.com/thing:2217431) hands.

1. A new design for supports for the big arch on all three of these palms.  I am providing a completed STL file for these, along with the OpenSCAD code which converts the basic palm into the supported palm.  These supports are flying supports; they do not touch the baseplate.  They are bridged under the top of the arch, and require very little material or time to print.  They break off easily after printing, and remaining nubs can be sanded off.  
1. Repaired meshes for the v2 and Reborn palms.  The meshes were run through [Meshmixer](http://www.meshmixer.com) to remove the support box, and then the remaining holes in the mesh were (mostly) closed up.  The Reborn palm, which is derived from the v2 palm, is rederived using OpenSCAD to make the modifications required.
2. The big part:  fully parameterized scaling of the v2 and Reborn palms, using OpenSCAD.  
	3. 	This allows the palms to be scaled independently of the hinges, so that commercial steel pins or nails can be used to make precision, smooth-operating joints.  
	4. The parameters allow selection of different options for both hinge pins and for plastic tubing bearings, which make even better joints.  
	5. The clearance on the tongue-and-groove joints is set independently of the scale of the hand.  This way, hands do not become floppier as they scale up to larger size.

## New support system
## New Meshes
## Parametric Scaling
 