/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Beatriz Aria (Stark)
 * Creation Date: 12/12/2018 at 10:17:36
 *********************************************/
 
// CUTTING STOCK PROBLEM WITH E-CONSTRAINT
// PRIORIZATION OF F1 (NUMBER OF OBJECTS CUTTED)
 
 int e2 = ...;	// nadir point for f2
 int L = ...;	// object lenght
 int nitems = ...;	// number of items
 
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

// minimize total waste of material
 minimize
 	f1;
 	
// fill the demands
 subject to{
 	f2 <= e2;
  
	forall(i in items)
	  	sum(p in patterns) p.fill[i] * cut[p] >= demands[i];
	
	forall(p in patterns)
	  	cut[p] - M * usepatt[p] <= 0;		
 }
 
