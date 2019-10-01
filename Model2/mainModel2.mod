/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Beatriz Aria (Stark)
 * Creation Date: 10/12/2018 at 09:07:38
 *********************************************/

// FLOW CONTROL OF CSP MODEL 2 : MINIMIZATION OF NUMBER OF OBJETCS 
// + NUMBER OF CUTTING PATTERNS USED USING COLUMN GENERATION

 main{
  	var status = 0;
  	var rc_eps = 1.0e-8;
  	var indsub = 0;		// indicates if subproblem is open(1) or not(0)
	
	var data = "test4.dat";
  	
  	// definition of the master model
  	// this stranger parameters are from software, just accepted it.
	var masterSource = new IloOplModelSource("modelCSPminObjCP.mod");
  	var masterDef = new IloOplModelDefinition(masterSource);
  	var masterCplex = cplex;
  	var masterData = new IloOplDataSource(data);
  	var masterOpl = new IloOplModel(masterDef, masterCplex); 
	masterOpl.addDataSource(masterData);
   	masterOpl.generate();
	
	// subproblem definition
	var subSource = new IloOplModelSource("OCPKP.mod");
	var subDef = new IloOplModelDefinition(subSource);
	var subCplex = new IloCplex();
	
	var best = 0;
	var curr = Infinity;	// current best value
	
	while(best != curr){
		best = curr;
		
		// relaxing all integers variables
	   	masterOpl.convertAllIntVars();
		
	   	writeln("\nSolving master problem:");
	   	
		if(masterCplex.solve()){
			curr = masterCplex.getObjValue();
			writeln("Objective value: ", curr);
			writeln("f1: ", masterOpl.f1," f2: ", masterOpl.f2);		
			writeln("usepatt: ", masterOpl.usepatt.solutionValue,"\ncut: ", masterOpl.cut.solutionValue);		
		}else{
			writeln("Houston, we have a problem!");		
			break;			
		}

		// setting subproblem parameters
		var subData = new IloOplDataElements();	
		subData.L = masterOpl.L;
		subData.nitems = masterOpl.nitems;
		subData.len = masterOpl.len;					
		subData.patterns = masterOpl.patterns;
		subData.dualsi = masterOpl.dualsi;
		subData.dualsp = masterOpl.dualsp;
		
		for(var i in masterOpl.items){
     		subData.dualsi[i] = masterOpl.ctfill[i].dual;
  		}
		
  		for(var p in masterOpl.patterns){
     		subData.dualsp[p] = masterOpl.ctpatt[p].dual;
  		}

		// creating the subproblem (column generation)
		var subOpl = new IloOplModel(subDef, subCplex);	
		subOpl.addDataSource(subData);
		subOpl.generate();
		indsub = 1;
		
		writeln("\nSolving the column generation:");
		
		if(subCplex.solve()){		
			writeln("Objective value: ", subCplex.getObjValue());
			writeln("PATTERN FOUND: ", subOpl.column.solutionValue);
			//writeln("c1: ", subOpl.c1, " c2: ", subOpl.c2);
		}else{
			writeln("No more pattern found! :(");
			break;	
		}
		
		// recovering the master data
		masterData = masterOpl.dataElements; 
    	masterOpl.end();
    			
		// adding the new pattern (column) in the master problem data
		masterData.patterns.add(masterData.patterns.size,subOpl.column.solutionValue);
				
		// creating the new master problem, with new data
		var masterOpl = new IloOplModel(masterDef, masterCplex);
        masterOpl.addDataSource(masterData);
        masterOpl.generate();
        		
		// verifying if subproblem obj value is small enough
		if(subCplex.solve() && (subCplex.getObjValue() > -rc_eps)){		
			break;
		}

   		subData.end();		
        subOpl.end();
        indsub = 0;

        //writeln("\ncurr: ", curr," best: ", best);
	}
	
	writeln("\nRelaxed model search end\n");
	
	masterData = masterOpl.dataElements;
	//masterOpl.convertAllIntVars();
	
	var soma = 0;
		
	// printing solution found
	if(masterCplex.solve()){
		for(var p in masterData.patterns){
      		if(masterOpl.cut[p].solutionValue > 0){
        		writeln("Pattern: ", p, " used ", masterOpl.cut[p].solutionValue, " times");
        		soma = soma + masterOpl.cut[p].solutionValue;
      		}
    	}
    	writeln(/*"\nNUMBER OF OBJECTS USED: ", masterOpl.f1, */"\nNUMBER OF CUTTING PATTERNS USED: ", masterOpl.f2);
  		writeln("NUMBER OF OBJECTS USED:", soma);
 // 		writeln("cut: ", masterOpl.cut.solutionValue,"\nusepatt: ", masterOpl.usepatt.solutionValue);		
  	}
  	
    if(indsub == 1){
    	subOpl.end();   
    }
    
    masterOpl.end();
    status;
 }
