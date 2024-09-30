// ------------------------------------------------------------
//
// TEAM Problem 30a
// This file contains the stator file.
//
// ------------------------------------------------------------
Include "layers.pro";
//Geometry.AutoCoherence = 0;
// ------------------------------------------------------------
// Switch between 1-phase and 3-phase examples
// ------------------------------------------------------------
Phase = 3;
  
  /*
DefineConstant[
	       Phase = {2, Choices{
		         1="1-Phase Model",
			 2="3-Phase Model"},
    Name StrCat['Input/0Induction Machine TEAM30/0'] , Highlight "Blue", Visible 1}  	 
  ];
  */

// units
cm= 1/100; //millimters


// Characteristic Lenghts
// Initial mesh control
lc_ssteel  =  0.25*cm;
lc_winding = 0.125*cm; 
lc_sair    = 0.125*cm; 
lc_center  = 0.125*cm;

r2 = 3*cm;
r3= 3.2*cm; // 
r3s = (r3+r2)/2; // note that r3 = r3r+r3s (half stator half rotor)
r4= 5.2*cm; 
r5= 5.7*cm;  

// points
centerPoint[] += newp; Point(newp) = {0, 0, 0,lc_ssteel}; // Dummy point to make circles

sAirlPoints[] += newp; Point(newp) = {r3s, 0, 0, lc_sair};
sAirlPoints[] += newp; Point(newp) = {0, r3s, 0, lc_sair};
sAirlPoints[] += newp; Point(newp) = {-r3s, 0, 0, lc_sair};
sAirlPoints[] += newp; Point(newp) = {0, -r3s, 0, lc_sair};

sAirLines[] += newl; Circle(newl) = {sAirlPoints[0],centerPoint[0],sAirlPoints[1]};
sAirLines[] += newl; Circle(newl) = {sAirlPoints[1],centerPoint[0],sAirlPoints[2]};
sAirLines[] += newl; Circle(newl) = {sAirlPoints[2],centerPoint[0],sAirlPoints[3]};
sAirLines[] += newl; Circle(newl) = {sAirlPoints[3],centerPoint[0],sAirlPoints[0]};

// parametrized coil points
theta_s = Pi/4; // winding phase span
nWindings = (Phase==1) ? 2:6; 
cindex_angle = (2*Pi - theta_s*nWindings)/nWindings + theta_s; // coil-to-coil angle
coil_angle = theta_s;
scurve_index = 0 ;

For i In {0:nWindings-1}
  
    coilPointr3[] += newp; Point(newp) = {r3*Cos[-coil_angle/2 + i*cindex_angle],r3*Sin[-coil_angle/2 + i*cindex_angle],0, lc_winding};
    coilPointr3[] += newp; Point(newp) = {r3*Cos[coil_angle/2+ i*cindex_angle],r3*Sin[coil_angle/2+ i*cindex_angle],0, lc_winding};
    coilPointr4[] += newp; Point(newp) = {r4*Cos[-coil_angle/2+ i*cindex_angle],r4*Sin[-coil_angle/2+ i*cindex_angle],0, lc_winding};
    coilPointr4[] += newp; Point(newp) = {r4*Cos[coil_angle/2+ i*cindex_angle],r4*Sin[coil_angle/2+ i*cindex_angle],0, lc_winding};
    
    coilLineHeight[] += newl; Line(newl) = {coilPointr3[0 + 2*i],coilPointr4[0 + 2*i]};
    coilLineHeight[] += newl; Line(newl) = {coilPointr3[1 + 2*i],coilPointr4[1 + 2*i]};
    
    coilLineSpanr3[] += newl; Circle(newl) = {coilPointr3[0 + 2*i],centerPoint[],coilPointr3[1 + 2*i]};
    coilLineSpanr4[] += newl; Circle(newl) = {coilPointr4[0 + 2*i],centerPoint[],coilPointr4[1 + 2*i]};
    
    // begin making coil surfaces after until last coil outline
    //Printf("%g %g %g %g",-coilLineHeight[0 + i*2], coilLineSpanr3[0 + i], coilLineHeight[1 + i*2], -coilLineSpanr4[0 + i]);
    WindingLineLoop[] += newll; Curve Loop(newll) = {-coilLineHeight[0 + i*2], coilLineSpanr3[0 + i], coilLineHeight[1 + i*2], -coilLineSpanr4[0 + i]};
    WindingSurface[] += news; Plane Surface(news) = {WindingLineLoop[i]};
    
    
  If(i>0)
      statorLineSpanr3[] += newl; Circle(newl) = {coilPointr3[1+scurve_index],centerPoint[],coilPointr3[2+scurve_index]};
      statorLineSpanr4[] += newl; Circle(newl) = {coilPointr4[1+scurve_index],centerPoint[],coilPointr4[2+scurve_index]};
      scurve_index +=2;
  EndIf
  
   
EndFor

//Connect last stator lines
 statorLineSpanr3[] += newl; Circle(newl) = {coilPointr3[1+scurve_index],centerPoint[],coilPointr3[0]};
 statorLineSpanr4[] += newl; Circle(newl) = {coilPointr4[1+scurve_index],centerPoint[],coilPointr4[0]};

 // create air stator surfaces
count = 0;
count2 = 0;
For i In{0:#statorLineSpanr3[]-1}
  

    If(i < #statorLineSpanr3[]-1)
        sAirLineLoop[] += newll; Curve Loop(newll) =  {statorLineSpanr3[0+count], coilLineHeight[2+count2], -statorLineSpanr4[0+count], -coilLineHeight[1+count2]};
        sAirSurface[] += news; Plane Surface(news) = {sAirLineLoop[i]};
    Else
	sAirLineLoop[] += newll; Curve Loop(newll) =  {statorLineSpanr3[0+count], coilLineHeight[0], -statorLineSpanr4[0+count], -coilLineHeight[1+count2]};
	sAirSurface[] += news; Plane Surface(news) = {sAirLineLoop[i]};
   EndIf
   
   count += 1;
   count2 +=2;
   
EndFor

// Create airgap surface
innerStatorLoop[] += newll; Curve Loop(newll) =  {statorLineSpanr3[],coilLineSpanr3[]};
sAirGapLoop[] += newll; Curve Loop(newll) =  {sAirLines[]};
sAirGapSurface[] += news; Plane Surface(news) = {sAirGapLoop[],innerStatorLoop[]};


//

sSteellPoints[] += newp; Point(newp) = {r5, 0, 0, lc_sair};
sSteellPoints[] += newp; Point(newp) = {0, r5, 0, lc_sair};
sSteellPoints[] += newp; Point(newp) = {-r5, 0, 0, lc_sair};
sSteellPoints[] += newp; Point(newp) = {0, -r5, 0, lc_sair};

sSteelLines[] += newl; Circle(newl) = {sSteellPoints[0],centerPoint[0],sSteellPoints[1]};
sSteelLines[] += newl; Circle(newl) = {sSteellPoints[1],centerPoint[0],sSteellPoints[2]};
sSteelLines[] += newl; Circle(newl) = {sSteellPoints[2],centerPoint[0],sSteellPoints[3]};
sSteelLines[] += newl; Circle(newl) = {sSteellPoints[3],centerPoint[0],sSteellPoints[0]};

outerStatorLoop[] += newll; Curve Loop(newll) =  {statorLineSpanr4[],coilLineSpanr4[]};
sSteelLoop[] += newll; Curve Loop(newll) =  {sSteelLines[]};
sSteelSurface[] += news; Plane Surface(news) = {sSteelLoop[],outerStatorLoop[]};

Transfinite Curve {sSteelLines[]} = 200 Using Progression 1;
Transfinite Curve {sAirLines[]} = 200 Using Progression 1;

// Physical Domains
SAIRGAP  = 10;
SMORTARAIRGAP  = 11;
SAIR  = 13;
SSTEEL = 14;
INF = 15;

AP = 16;
BN = 17;
CP = 18;

AN = 19;
BP = 20;
CN = 21;


// Physical Entities
//Physical Surface("Stator-side Airgap", SAIRGAP) = {sAirGapSurface[]};
//Physical Curve("Stator-side Mortar Boundary", SMORTARAIRGAP) = {sAirLines[]};
//Physical Surface("Stator Air", SAIR) = {sAirSurface[]};
//Physical Surface("Stator Steel", SSTEEL) = {sSteelSurface[]};
//Physical Curve("Infinity", INF) = {sSteelLines[]};


//Windings
/*
If(Phase == 1)
    Physical Surface("Winding A+", AP) = {WindingSurface[0]};
    Physical Surface("Winding A-", AN) = {WindingSurface[1]};
Else
    Physical Surface("Winding A+", AP) = {WindingSurface[0]};
    Physical Surface("Winding B-", BN) = {WindingSurface[1]};
    Physical Surface("Winding C+", CP) = {WindingSurface[2]};
    Physical Surface("Winding A-", AN) = {WindingSurface[3]};
    Physical Surface("Winding B+", BP) = {WindingSurface[4]};
    Physical Surface("Winding -C", CN) = {WindingSurface[5]};
EndIf
*/

//Mesh 3;
//Save "stator_TEAM30a.msh";

//+
//nlayers = 1;
Extrude {0, 0, 1e-3} {
  Surface{74}; Surface{10}; Surface{54}; Surface{16}; Surface{56}; Surface{24}; Surface{58}; Surface{32}; Surface{60}; Surface{40}; Surface{62}; Surface{48}; Surface{64}; Surface{67}; Layers {nlayers}; Recombine;
}

/*
Physical Surface("winding_a_plus", AP) = {WindingSurface[0]};
Physical Surface("winding_b_minus", BN) = {WindingSurface[1]};
Physical Surface("winding_c_plus", CP) = {WindingSurface[2]};
Physical Surface("winding_a_minus", AN) = {WindingSurface[3]};
Physical Surface("winding_b_plus", BP) = {WindingSurface[4]};
Physical Surface("winding_c_minus", CN) = {WindingSurface[5]};
*/
//+
Physical Volume("winding_a_plus", 1) = {2};
Physical Volume("winding_b_minus", 2) = {4};
Physical Volume("winding_c_plus", 3) = {6};
Physical Volume("winding_a_minus", 4) = {8};
Physical Volume("winding_b_plus", 5) = {10};
Physical Volume("winding_c_minus", 6) = {12};


Physical Volume("stator_steel", 7) = {1};
//+
Physical Volume("stator_air", 8) = {3, 5, 7, 9, 11, 13};
//+
Physical Volume("stator_side_airgap", 9) = {14};
//+
Physical Surface("stator_side_mortar_boundary", 10) = {445, 449, 453, 441};
//+
Physical Surface("infinity", 11) = {156, 244, 288, 332, 376, 420, 200, 95, 99, 103, 107, 74, 60, 58, 56, 54, 64, 62, 67, 502};
//+
Physical Surface("winding_a_plus_electrode1", 12) = {178};
//+
Physical Surface("winding_a_plus_electrode2", 13) = {10};
//+
Physical Surface("winding_a_plus_alpha0", 14) = {169};
//+
Physical Surface("winding_a_plus_alpha1", 15) = {111};
//+
Physical Surface("winding_a_plus_beta0", 16) = {165};
//+
Physical Surface("winding_a_plus_beta1", 17) = {173};
//+
Physical Surface("winding_b_minus_electrode2", 18) = {222};
//+
Physical Surface("winding_b_minus_electrode1", 19) = {16};
//+
Physical Surface("winding_b_minus_alpha0", 20) = {213};
//+
Physical Surface("winding_b_minus_alpha1", 21) = {151};
//+
Physical Surface("winding_b_minus_beta0", 22) = {191};
//+
Physical Surface("winding_b_minus_beta1", 23) = {217};
//+
Physical Surface("winding_c_plus_electrode1", 24) = {266};
//+
Physical Surface("winding_c_plus_electrode2", 25) = {24};
//+
Physical Surface("winding_c_plus_alpha0", 26) = {257};
//+
Physical Surface("winding_c_plus_alpha1", 27) = {143};
//+
Physical Surface("winding_c_plus_beta0", 28) = {235};
//+
Physical Surface("winding_c_plus_beta1", 29) = {261};
//+
Physical Surface("winding_a_minus_electrode2", 30) = {310};
//+
Physical Surface("winding_a_minus_electrode1", 31) = {32};
//+
Physical Surface("winding_a_minus_alpha0", 32) = {301};
//+
Physical Surface("winding_a_minus_alpha1", 33) = {135};
//+
Physical Surface("winding_a_minus_beta0", 34) = {279};
//+
Physical Surface("winding_a_minus_beta1", 35) = {305};
//+
Physical Surface("winding_b_plus_electrode1", 36) = {354};
//+
Physical Surface("winding_b_plus_electrode2", 37) = {40};
//+
Physical Surface("winding_b_plus_alpha0", 38) = {345};
//+
Physical Surface("winding_b_plus_alpha1", 39) = {127};
//+
Physical Surface("winding_b_plus_beta0", 40) = {323};
//+
Physical Surface("winding_b_plus_beta1", 41) = {349};
//+
Physical Surface("winding_c_minus_electrode2", 42) = {398};
//+
Physical Surface("winding_c_minus_electrode1", 43) = {48};
//+
Physical Surface("winding_c_minus_alpha0", 44) = {389};
//+
Physical Surface("winding_c_minus_alpha1", 45) = {119};
//+
Physical Surface("winding_c_minus_beta0", 46) = {367};
//+
Physical Surface("winding_c_minus_beta1", 47) = {393};

//Geometry.AutoCoherence = 0;
//Mesh.MshFileVersion=2.2;
