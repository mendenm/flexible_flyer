                   .:                     :,                                          
,:::::::: ::`      :::                   :::                                          
,:::::::: ::`      :::                   :::                                          
.,,:::,,, ::`.:,   ... .. .:,     .:. ..`... ..`   ..   .:,    .. ::  .::,     .:,`   
   ,::    :::::::  ::, :::::::  `:::::::.,:: :::  ::: .::::::  ::::: ::::::  .::::::  
   ,::    :::::::: ::, :::::::: ::::::::.,:: :::  ::: :::,:::, ::::: ::::::, :::::::: 
   ,::    :::  ::: ::, :::  :::`::.  :::.,::  ::,`::`:::   ::: :::  `::,`   :::   ::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  :::::: ::::::::: ::`   :::::: ::::::::: 
   ,::    ::.  ::: ::, ::`  :::.::    ::.,::  .::::: ::::::::: ::`    ::::::::::::::: 
   ,::    ::.  ::: ::, ::`  ::: ::: `:::.,::   ::::  :::`  ,,, ::`  .::  :::.::.  ,,, 
   ,::    ::.  ::: ::, ::`  ::: ::::::::.,::   ::::   :::::::` ::`   ::::::: :::::::. 
   ,::    ::.  ::: ::, ::`  :::  :::::::`,::    ::.    :::::`  ::`   ::::::   :::::.  
                                ::,  ,::                               ``             
                                ::::::::                                              
                                 ::::::                                               
                                  `,,`


https://www.thingiverse.com/thing:xxxxxx

Flexible Flyer Hand by Marcus Mendenhall is licensed under the Creative Commons - Attribution license.
http://creativecommons.org/licenses/by/3.0/

Reborn Hand by enablesierraleone is licensed under the Creative Commons - Attribution license.
http://creativecommons.org/licenses/by/3.0/

# Summary

This is a parametric adaptation of the Phoenix Reborn hand, that allows the primary components (palm and fingers) to be scaled while holding the sizes of the connecting components (finger pins) constant,  so a standard kit of metal connectors can be used, instead of printing plastic pins to connect everything.  The OpenSCAD files allow one to select sizes for whatever connectors are to be used, and then independently scale the palm and fingers.  The connectors can be metal pins of nails, or 3mm screws.  They can have plastic tubing (Delrin or PTFE) wrapping them inside the holes in the phalanx, resulting in a very smooth-operating bearing.

The palm design is a combination of the Phoenix Reborn palm with the fused-in mesh from the Unlimbited V3 palm. This greatly reduces the number of screws required to assemble the hand.  The palm also has new 'flying supports' which solve the problem of the overhang at the top of the palm arch, without printing large support structures.  The I-beams that hold up the top break off easily, and remaining nubs of plastic sand off easily with e rotary tool (Dremel with flap-wheel, for example), or even by hand.

The whole design here is to provide a flexible toolkit to create locally-appropriate variations of the hand, while letting OpenSCAD handle the scaling issues.  Many things can be commented out of the OpenSCAD code to make variations.  For example, if the fused palm mesh isn't desired, the line which fuses it in can be preceded with an asterisk ('*') which tells OpenSCAD to ignore it.  Also, if the new support structure is desired but conventional printed pins are still being used, all the fancy parametric drilling can be turned off, resulting in a (nearly) conventional Reborn hand.

The Reborn-style hand is being recreated in OpenSCAD from the Phoenix v2 palm, by redrilling the tunnels and slots, since it was possible to repair the mesh for the v2 palm to the point where OpenSCAD considered it valid (after removing the support box in MeshMixer).  It has not been possible to date to repair the Reborn palm mesh to the point at which the OpenSCAD openCGAL geometry libraries consider it valid. The file "palm_left_v2_nobox.stl" contains this modified mesh.  

Marcus Mendenhall, June 2020

**** Rest of the text blatantly copied from the Phoenix Reborn file ****

This is a Remix of the Phoenix Hand & UnLimbited Arm, designed by Albert Fung. This project is a collaboration between e-NABLE Sierra Leone and the Hong Kong Maker Club.

It became apparent in our previous feasibility study that for the 3D printed prosthetics to survive the tropics, we need to remove components that are not well-adapted to hot weather. We therefore set out to replace all the rubber bands in the Phoenix hand.

Palm: We used the One-Arm palm designed by below_cho as out starting point. All the cable tunnels have been widened, the knuckle stumps removed, and a bar is added at the thumb base for tying elastic cord.

Palm mesh: we have modified the thick palm mesh by John Diamond to strengthen the screw holes.

Fingers: Tunnels have been created so an elastic cord can now run all the way from the finger tip up into the palm.

Pins: For snug fitting, some of the pins have been resized and reshaped.

Hope you'll find this new remix useful!

Ed Choi

Links:

e-NABLE Sierra Leone - Facebook
http://www.facebook.com/enablesierraleone

e-NABLE Sierra Leone - CrowdFunding
http://www.GoFundMe.com/enablesierraleone

Albert Fung - designer
http://albertfung.ca

Hong Kong Maker Club - collaborator 
https://www.facebook.com/hongkongmakerclub/

Raise3D HK Printer - manufacturing
https://www.facebook.com/raise3dhk/

Printact 3D Printer - prototyping 
http://www.printact.co

# Print Settings

Rafts: Yes
Supports: Yes
Infill: 30%

Notes: 
::: Construction notes :::

For a wrist-powered prosthetic hand, please use the Reborn Hand with a thermal gauntlet.
http://www.thingiverse.com/thing:864030 and tensioner/tensioner pins from the Raptor Reloaded. http://www.thingiverse.com/thing:596966

For an elbow-powered prosthetic arm, please use the Reborn palm with the "forearm" and bicep "cuff" from the UnLimbited Arm (see link). There is a glitch in the Thingiverse Customizer, so you will need to set the UnLimbited "hand length" to at least 145mm. Otherwise the forearm wrist joint would not be wide enough to fit into the palm.
 
http://www.thingiverse.com/thing:1672381
http://www.teamunlimbited.org/the-unlimbited-arm-20-alfie-edition-current/

We printed the Reborn hand at 124% and used it with parametric forearm, cuff and tensioner pins from the UnLimbited Arm(v2.0). From our field experience, the UnLimbited Arm cuff pins are not stronger enough to hold the elbow in place for very long. So we advice everyone to use Chicago/binding screws (glued) instead.

Scaling the ReBorn Hand parts at 124% would give you:

Palm width (widest): 80mm
Wrist joint (outside): 75mm
Wrist joint (inside): 64mm

Additional materials:

1) Braided fishing line - 80lb.
http://www.ebay.com/itm/KastKing-SuperPower-Braided-Fishing-Line-330-yds-1100yds-SELECT-LB-TEST-/190909992257?var=&hash=item2c731f4d41:m:m6k91tkQ1bIzQbS8tDpHzaQ

2) Elastic cords - 1.5mm - for hands printed at 100% or above

3) Screws - for tensioner block - Hands printed at 124%: 
single thread woodscrew 3.0 x 30mm

4) Screws - for palm mesh printed at 124%:
Reassure R2 - full thread woodscrew 3.0 x 16mm

5) Silicone fingertip grips - Tipper Lee, and superglued to secure them to the fingers

6) Velcro - 1 inch thick double-sided

7) Adhesive Foam - 5mm thick
https://www.amazon.co.uk/Self-Adhesive-various-including-padding-Outfitting/dp/B002GUB9R0/ref=sr_1_5?s=sports&ie=UTF8&qid=1491140349&sr=1-5

8) 13mm binding screws for the elbow joints (use superglue or Loctite to prevent loosening). 

9) Loctite 243 seal thread
http://www.ebay.com/itm/121826873262?_trksid=p2057872.m2749.l2648&ssPageName=STRK%3AMEBIDX%3AIT