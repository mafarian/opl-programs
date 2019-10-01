// MASTER PROBLEM OF CSP MODEL 1 : MINIMIZATION OF NUMBER OF OBJETCS USED
 
 int L = ...;	// object lenght
 int nitems = ...;	// number of items
 float c2 = 0.00001;
 //float c2 = 0;
 
 range items = 1..nitems;
 int len[items] = ...;		// items sizes
 int demands[items] = ...;	// items demands
 int M = sum(i in items) demands[i];
 
 tuple pattern{		// defining a cutting pattern
 	key int id;		// identification
 	int fill[items];	// items in it
 }
 
 {pattern} patterns = ...;	// array with the initial patterns
  
 dvar int cut[patterns] in 0..M;
 dvar int usepatt[patterns] in 0..1;
 dexpr int f1 = sum(p in patterns) cut[p];
 dexpr int f2 = sum(p in patterns) usepatt[p];
 dexpr float fo = f1 + c2*f2;

// minimize total waste of material
 minimize
	fo; 	
	
// fill the demands
 subject to{  	  
	forall(i in items)
	  	sum(p in patterns) p.fill[i] * cut[p] >= demands[i];
	
	forall(p in patterns)
	  	cut[p] - M * usepatt[p] <= 0;
 }
