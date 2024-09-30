// Gmsh project created on Mon Feb  8 11:09:02 2021// ------------------------------------------------------------
//
// TEAM Problem 30a
// This file contains the rotor file.
//
// ------------------------------------------------------------
//Geometry.AutoCoherence = 0;
Include "layers.pro";
//nlayers = 1;

// units
cm= 1/100; //millimters


// Characteristic Lenghts
// Initial mesh control
lc_rsteel  =  0.25*cm;
lc_raluminum = 0.125*cm; 
lc_rair = 0.125*cm; 

r1 = 2*cm;
r2 = 3*cm;
r3= 3.2*cm; // note that r3 = r3r+r3s (half stator half rotor)
r3r = (r3+r2)/2; //-0.01*cm;



// points
centerPoint[] += newp; Point(newp) = {0, 0, 0, lc_rsteel};
rSteelPoints[] += newp; Point(newp) = {r1, 0, 0, lc_rsteel};
rSteelPoints[] += newp; Point(newp) = {0, r1, 0, lc_rsteel};
rSteelPoints[] += newp; Point(newp) = {-r1, 0, 0, lc_rsteel};
rSteelPoints[] += newp; Point(newp) = {0, -r1, 0, lc_rsteel};

rAluminumlPoints[] += newp; Point(newp) = {r2, 0, 0, lc_rsteel};
rAluminumlPoints[] += newp; Point(newp) = {0, r2, 0, lc_rsteel};
rAluminumlPoints[] += newp; Point(newp) = {-r2, 0, 0, lc_rsteel};
rAluminumlPoints[] += newp; Point(newp) = {0, -r2, 0, lc_rsteel};


rAirlPoints[] += newp; Point(newp) = {r3r, 0, 0, lc_rair};
rAirlPoints[] += newp; Point(newp) = {0, r3r, 0, lc_rair};
rAirlPoints[] += newp; Point(newp) = {-r3r, 0, 0, lc_rair};
rAirlPoints[] += newp; Point(newp) = {0, -r3r, 0, lc_rair};

// lines 
rSteelLines[] += newl; Circle(newl) = {rSteelPoints[0],centerPoint[0],rSteelPoints[1]};
rSteelLines[] += newl; Circle(newl) = {rSteelPoints[1],centerPoint[0],rSteelPoints[2]};
rSteelLines[] += newl; Circle(newl) = {rSteelPoints[2],centerPoint[0],rSteelPoints[3]};
rSteelLines[] += newl; Circle(newl) = {rSteelPoints[3],centerPoint[0],rSteelPoints[0]};

rAluminumLines[] += newl; Circle(newl) = {rAluminumlPoints[0],centerPoint[0],rAluminumlPoints[1]};
rAluminumLines[] += newl; Circle(newl) = {rAluminumlPoints[1],centerPoint[0],rAluminumlPoints[2]};
rAluminumLines[] += newl; Circle(newl) = {rAluminumlPoints[2],centerPoint[0],rAluminumlPoints[3]};
rAluminumLines[] += newl; Circle(newl) = {rAluminumlPoints[3],centerPoint[0],rAluminumlPoints[0]};

rAirLines[] += newl; Circle(newl) = {rAirlPoints[0],centerPoint[0],rAirlPoints[1]};
rAirLines[] += newl; Circle(newl) = {rAirlPoints[1],centerPoint[0],rAirlPoints[2]};
rAirLines[] += newl; Circle(newl) = {rAirlPoints[2],centerPoint[0],rAirlPoints[3]};
rAirLines[] += newl; Circle(newl) = {rAirlPoints[3],centerPoint[0],rAirlPoints[0]};


// surfaces
rSteelLineLoop[] += newll; Curve Loop(newll) = {rSteelLines[0], rSteelLines[1], rSteelLines[2], rSteelLines[3]};
rSteelSurface[] += news; Plane Surface(news) = {rSteelLineLoop[]};

rAluminumLineLoop[] += newll; Curve Loop(newll) = {rAluminumLines[0], rAluminumLines[1], rAluminumLines[2], rAluminumLines[3]};
rAluminumSurface[] += news; Plane Surface(news) = {rAluminumLineLoop[],rSteelLineLoop[]};

rAirLineLoop[] += newll; Curve Loop(newll) = {rAirLines[0], rAirLines[1], rAirLines[2], rAirLines[3]};
rAirSurface[] += news; Plane Surface(news) = {rAirLineLoop[],rAluminumLineLoop[]};


Transfinite Curve {rSteelLines[]} = 20 Using Progression 1;
Transfinite Curve {rAluminumLines[]} = 200 Using Progression 1;
Transfinite Curve {rAirLines[]} = 200 Using Progression 1;


//nlayers = 1;

Elementary_Rotor_Steel[] += Extrude {0, 0, 1e-3} {
  Surface{rSteelSurface}; Layers {nlayers};Recombine;
};

Elementary_Rotor_Aluminum[] += Extrude {0, 0, 1e-3} {
  Surface{rAluminumSurface}; Layers {nlayers};Recombine;
};

Elementary_Mortar_Boundary[] += Extrude {0, 0, 1e-3} {
  Line{rAirLines[0]}; Line{rAirLines[1]}; Line{rAirLines[2]}; Line{rAirLines[3]}; Layers {nlayers};Recombine;
};

Elementary_Rotor_Airgap[] += Extrude {0, 0, 1e-3} {
  Surface{rAirSurface}; Layers {nlayers}; Recombine;
};


//Printf("Mortar Boundary %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g %g",Elementary_Mortar_Boundary[]);

// Physical Domains

Physical Volume("rotor_steel", 48) = {Elementary_Rotor_Steel[1]};
//+
Physical Volume("rotor_aluminum", 49) = {Elementary_Rotor_Aluminum[1]};
//+
Physical Volume("rotor_side_airgap", 50) = {Elementary_Rotor_Airgap[1]};
//+
Physical Surface("rotor_side_mortar_boundary", 51) = {Elementary_Mortar_Boundary[1], Elementary_Mortar_Boundary[5], Elementary_Mortar_Boundary[9],Elementary_Mortar_Boundary[13] };
//+

//Geometry.AutoCoherence = 0;
//Mesh.MshFileVersion=2.2;
