// SCALARIZATION METHOD: MINIMIZATION a*F1+b*F2
// NUMBER OF OBJETCS + NUMBER OF CUTTING PATTERNS USED 
 
 float w = ...;
 int z1_u = ...;
 int z1_n = ...;
 int z2_u = ...;
 int z2_n = ...;
 
 int L = ...;	// object lenght
 int nitems = ...;	// number of items
 
 range items = 1..nitems;
 int len[items] = ...;		// items sizes
 int demands[items] = ...;	// items demands
 float dualsi[items];// = ...;	// duals variables 
 int M = sum(i in items) demands[i];
 
 tuple pattern{		// defining a cutting pattern
	 key int id;		// identification
	 int fill[items];	// items in it
 }
 
 {pattern} patterns = ...;	// array with the initial patterns
 float dualsp[patterns];// = ...;
 
 dvar int usepatt[patterns] in 0..1;
 dvar int cut[patterns] in 0..M;
 dexpr int f1 = sum(p in patterns) cut[p];
 dexpr int f2 = sum(p in patterns) usepatt[p];
 dexpr float g1 = (f1 - z1_u) / (z1_n - z1_u);
 dexpr float g2 = (f2 - z2_u) / (z2_n - z2_u);

// minimize total waste of material and the number of cutting patterns used
minimize
  w*g1 + (1-w)*g2;
 	
// fill the demands
 subject to{  	  
	forall(i in items)
	  ctfill:
	  	sum(p in patterns) p.fill[i] * cut[p] >= demands[i]; 
	
	forall(p in patterns)
	  ctpatt:
	  	cut[p] <= M * usepatt[p];
 }
 
execute FillDuals{
	for(var i in items){
 		dualsi[i] = ctfill[i].dual; 	
 	}
 	
 	for(var p in patterns){
 	 	dualsp[p] = ctpatt[p].dual;
 	}
}
