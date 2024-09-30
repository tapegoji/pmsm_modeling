SetFactory("OpenCASCADE");

// load original STEP file in mm
a() = ShapeFromFile("pmsm_2p_2D.stp");

// Remove any duplicate entities
Coherence;

// scale from mm to m
s() = Surface "*";
d = 1e-3;
ss() = Dilate{ {0,0,0}, d }{ Surface{ s() }; };

// Delete all Stator Surfaces
Recursive Delete {
  Surface{1}; Surface{2}; Surface{3}; Surface{11}; Surface{4}; Surface{5}; Surface{6}; Surface{7}; 
}

// Create Physical Entities
Physical Surface("rotor", 483) = {8};
Color Gray         {Surface{8};} 

Physical Surface("rotor_air", 484) = {12};
Color White         {Surface{12};} 

Physical Surface("magnet_P", 485) = {9};
Color DarkRed         {Surface{9};} 

Physical Surface("magnet_N", 486) = {10};
Color Blue         {Surface{10};} 

Physical Curve("Rotor_side_Mortar_Boundary", 487) = {482};

// Mesh control
Transfinite Curve {478, 476, 481, 479} = 15 Using Progression 1;
Transfinite Curve {482} = 180 Using Progression 1;
Transfinite Curve {474, 472} = 20 Using Progression 1;
Transfinite Curve {477, 480} = 120 Using Progression 1;

// Assign a mesh size to all the points of all the volumes OCC entities!!:
MeshSize{ PointsOf{ Surface{9}; Surface{10};} } = 1e-3;
MeshSize{ PointsOf{ Surface{8};} } = 3e-3;

Transfinite Curve {473, 475, 471} = 50 Using Progression 1;
