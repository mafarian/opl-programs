/*
MAIN PROGRAM TO CALCULATE THE NADIR AND UTOPIA POINTS ABOUT THE CSP
USING ALL THE FEASABLE CUTTING PATTERNS

modelF1minObj: min f1 + c2*f2
modelF2minCP: min c1*f1 + f2

modelF1minObj ->>>>  z1_u and z2_n
modelF2minCP  ->>>>  z2_u and z1_n
*/

main{
	var status = 0;
	var data = "c3.1allCP.dat";
	
  	var masterCplex = cplex;
   	cplex.epgap = 10e-2;
   	cplex.tilim = 3600;
  	var masterData = new IloOplDataSource(data);
  	
	// model to minize F1: number of objects
	var model = "modelF1minObj.mod";
	var masterSource = new IloOplModelSource(model);
  	var masterDef = new IloOplModelDefinition(masterSource);
  	var masterOpl = new IloOplModel(masterDef, masterCplex); 

	masterOpl.addDataSource(masterData);
  	masterOpl.generate();
  	
	var z2_n = 0;
   	
   	writeln("\n### UTOPIA POINT OF F1 (OBJECTS) ###\n");
   	
	if(masterCplex.solve()){
		for(var p in masterOpl.patterns){
      		if(masterOpl.cut[p].solutionValue > 0){
        		writeln("Pattern: ", p, " used ", masterOpl.cut[p].solutionValue, " times");
      			z2_n++;
      		}
    	}
    	
		var z1_u = masterOpl.f1.solutionValue;
		writeln("fo: ", masterCplex.getObjValue());
    	writeln("\nNUMBER OF OBJECTS USED (z1_u): ", z1_u);
    	writeln("NUMBER OF CUTTING PATTERNS USED (z2_n): ", z2_n);
    }else{
  		writeln("-- NO SOLUTION :O --");
  	}

  	masterOpl.end();

	// model to minize F2: number of cutting patterns
	var model = "modelF2minCP.mod";
	var masterSource = new IloOplModelSource(model);
  	var masterDef = new IloOplModelDefinition(masterSource);
  	var masterOpl = new IloOplModel(masterDef, masterCplex);
  	
	masterOpl.addDataSource(masterData);
   	masterOpl.generate();
	
   	writeln("\n### UTOPIA POINT OF F2 (CUTTING PATTERNS) ###\n");
	
	cplex.epgap = 10e-2;
	
	if(masterCplex.solve()){
		for(var p in masterOpl.patterns){
      		if(masterOpl.cut[p].solutionValue > 0){
        		writeln("Pattern: ", p, " used ", masterOpl.cut[p].solutionValue, " times");
      		}
    	}
    	
    	var z2_u = masterOpl.f2.solutionValue;
    	var z1_n = masterOpl.f1.solutionValue;

		writeln("fo: ", masterCplex.getObjValue());    	
    	writeln("\nNUMBER OF OBJECTS USED (z1_n): ", z1_n);
    	writeln("NUMBER OF CUTTING PATTERNS USED (z2_u): ", z2_u);
  	}else{
  		writeln("-- NO SOLUTION :O --");
  	}

  	masterOpl.end();

  	writeln("z1_u = ", z1_u, ";");
  	writeln("z1_n = ", z1_n, ";");
  	writeln("z2_u = ", z2_u, ";");
  	writeln("z2_n = ", z2_n, ";");

  	status;
}
