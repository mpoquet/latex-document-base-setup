import math;

size(6cm,0);

marker cross=marker(scale(2)*cross(4), 1bp+gray);

add(grid(6, 5, .8lightgray));

pair pA=(1,1), pB=(5,1), pC=(4,4);

draw(pA--pB--pC--cycle);
draw("$A$", pA, dir(pC--pA,pB--pA), blue, cross);
draw("$B$", pB, dir(pC--pB,pA--pB), cross);
draw("$C$", pC, dir(pA--pC,pB--pC), cross);
