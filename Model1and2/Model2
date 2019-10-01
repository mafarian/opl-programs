/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Beatriz Aria (Stark)
 * Creation Date: 12/12/2018 at 10:17:36
 *********************************************/
 
// MASTER PROBLEM OF CSP MODEL 2 : MINIMIZATION OF NUMBER OF OBJETCS 
// + NUMBER OF CUTTING PATTERNS USED 

 int L = ...;	// object lenght
 int nitems = ...;	// number of items
 
 range items = 1..nitems;
 int len[items] = ...;		// items sizes
 int demands[items] = ...;	// items demands
 float dualsi[items];// = ...;	// duals variables 
 int maxcut = 1000000;
 
 tuple pattern{		// defining a cutting pattern
 key int id;		// identification
 int fill[items];	// items in it
 }
 
 {pattern} patterns = ...;	// array with the initial patterns
 float dualsp[patterns];// = ...;
 
 dvar int usepatt[patterns] in 0..1;
 dvar int cut[patterns] in 0..maxcut;
 dexpr int f1 = sum(p in patterns) cut[p];
 dexpr int f2 = sum(p in patterns) usepatt[p];
 
// minimize total waste of material and the number of cutting patterns used
 
minimize
  f1 + f2;
 	
// fill the demands
 subject to{  	  
	forall(i in items)
	  ctfill:
	  	sum(p in patterns) p.fill[i] * cut[p] >= demands[i]; 
	
	forall(p in patterns)
	  ctpatt:
		cut[p] <= maxcut * usepatt[p];
 }
 
 // set the duals variables values from primal constraints
 execute FillDuals{
 	for(var i in items){
 		dualsi[i] = ctfill[i].dual; 	
 	}
 	
 	for(var p in patterns){
 	 	dualsp[p] = ctpatt[p].dual;
 	}
 }
