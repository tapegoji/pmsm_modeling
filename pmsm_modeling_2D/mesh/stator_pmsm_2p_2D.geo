SetFactory("OpenCASCADE");

// load original STEP file in mm
a() = ShapeFromFile("pmsm_2p_2D.stp");

// scale from mm to m
s() = Surface "*";
d = 1e-3;
ss() = Dilate{ {0,0,0}, d }{ Surface{ s() }; };

// Remove any duplicate entities
Coherence;

// Remove rotor area
Recursive Delete {
  Surface{8}; Surface{9}; Surface{10}; Surface{12}; 
}

// Create physical entities
Physical Surface("stator", 242) = {1};
Physical Surface("stator_air", 243) = {11};
Physical Surface("winding_a_plus", 244) = {2};
Physical Surface("winding_b_minus", 245) = {3};
Physical Surface("winding_c_plus", 246) = {4};
Physical Surface("winding_a_minus", 247) = {5};
Physical Surface("winding_b_plus", 248) = {6};
Physical Surface("winding_c_minus", 249) = {7};
Physical Curve("Infinity", 250) = {205};
Physical Curve("Stator_side_Mortar_Boundary", 251) = {241};

// Assign a mesh size to all the points of all the volumes OCC entities!!:
MeshSize{ PointsOf{ Surface{11};} } = 1e-3;

Transfinite Curve {205} = 400 Using Progression 1;
