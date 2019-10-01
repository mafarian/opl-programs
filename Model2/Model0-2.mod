/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Beatriz Aria (Stark)
 * Creation Date: 10/12/2018 at 17:55:35
 *********************************************/
 
/* SUBPROBLEM OF CSP MODEL 2 : MINIMIZATION OF NUMBER OF OBJETCS 
   + NUMBER OF CUTTING PATTERNS USED
   KNAPSACK PROBLEM FOR COLUMN GENERATION
*/

int L = ...;	// knapsack capacity
int nitems = ...;	// number of items
range items = 1..nitems;
int maxfreq = 1000000;

tuple pattern{		// defining a cutting pattern
	key int id;		// identification
 	int fill[items];	// items in it
}
 
{pattern} patterns = ...;

int len[items] = ...;		// items sizes
float dualsi[items] = ...;		// items values (weight)
float dualsp[patterns] = ...;

// decision variables
dvar int column[items] in 0..maxfreq;		// column 
dexpr float c1 = sum(i in items) dualsi[i] * column[i];
dexpr float c2 = sum(p in patterns) dualsp[p];

// objective function
minimize
  1 - c1 - c2;

// constraints
subject to{
	sum(i in items) len[i] * column[i] <= L;
}
