algebraic3d
#
#  Copyright (C) 2011 - Sébastien Ternisien
#  
#  maximum mesh size 0.25
#

# define a axis parallel brick:

solid base = orthobrick (0, 0, 0; 10.5, 10.5, 1);


solid rectangle1= plane (0,0,0;0,0,-1) #plan du dessous
		and plane(0.25,0,0;-4,0,0.5) #plan en biais à gauche
		and plane(1.25,0,0;4,0,0.5) #plan en biais à droite
		and plane(0,0.25,0;0,-1,0) #plan devant
		and plane(0,1.25,0;0,1,0) #plan au fond
		and plane(0,0,3;0,0,1); #plan au dessus



# make copies:
solid rectanglex = multitranslate (1.5, 0, 0; 6; rectangle1);
solid rectanglexy = multitranslate (0, 1.5, 0; 6; rectanglex);

solid main = base or rectanglexy;

tlo main;

# provide bounding-box for fastening bisection alg:

boundingbox (-1, -1, -1; 11, 11, 2);
