// Simple single round wire example
// Author: Jonathan Velasco
// --------------------------------

// Parameters
r_wire = 0.5e-3;
r_air = 20*r_wire;

lc_wire = 1e-4;
lc_air = 1e-3;

// Model's center point
Point(1) = {0, 0, 0, 1.0};

// Wire points
Point(2) = {r_wire, 0, 0, lc_wire};
Point(3) = {0, r_wire, 0, lc_wire};
Point(4) = {-r_wire, 0, 0, lc_wire};
Point(5) = {0, -r_wire, 0, lc_wire};

// Air points
Point(6) = {r_air, 0, 0, lc_air};
Point(7) = {0, r_air, 0, lc_air};
Point(8) = {-r_air, 0, 0, lc_air};
Point(9) = {0, -r_air, 0, lc_air};

// Wire boundaries
Circle(1) = {2, 1, 3};
Circle(2) = {3, 1, 4};
Circle(3) = {4, 1, 5};
Circle(4) = {5, 1, 2};

// Infinity boundaries
Circle(5) = {6, 1, 7};
Circle(6) = {7, 1, 8};
Circle(7) = {8, 1, 9};
Circle(8) = {9, 1, 6};

// Wire surface
Curve Loop(1) = {4, 1, 2, 3};
Plane Surface(1) = {1};

// Air surface
Curve Loop(2) = {5, 6, 7, 8};
Plane Surface(2) = {1, 2};

// Physical Entities
Physical Surface("WIRE", 9) = {1};
Physical Surface("AIR", 10) = {2};
Physical Curve("INFINITY", 11) = {5, 6, 7, 8};

// Mesh Control
Transfinite Curve {1, 2, 3, 4} = 40 Using Progression 1;
Transfinite Curve {5, 6, 7, 8} = 40 Using Progression 1;
