/*********************************************
 * OPL 12.7.1.0 Model
 * Author: Beatriz Aria (Stark)
 * Creation Date: 13/12/2018 at 06:17:46
 *********************************************/

 main{
 	var status = 0;
  	var data = "c3.2allCP.dat";
	
	var z1_u = 70;
	var z1_n = 80;
	var z2_u = 5;
	var z2_n = 6;

	var delta = 1;
	
  	writeln("\n#### e-CONSTRAINT PRIORIZATING F1 ####:\n");
  	
  	// definition of the master model
  	var masterSource = new IloOplModelSource("modelPriorF1minObj.mod");
  	var masterDef = new IloOplModelDefinition(masterSource);
	var masterCplex = cplex;
   	cplex.epgap = 10e-2;
   	cplex.tilim = 100;	
  	
  	var e2 = z2_n;
  	
	while(e2 >= z2_u){
//		writeln("e2 = ", e2);
		
		var masterOpl = new IloOplModel(masterDef, masterCplex); 
   		var masterData = new IloOplDataSource(data);
		masterOpl.addDataSource(masterData);
		
	  	var dataE = new IloOplDataElements();
	  	dataE.e2 = e2;
	 	masterOpl.addDataSource(dataE);
	  	masterOpl.generate();
		
		if(masterCplex.solve()){
//			writeln("f1 = ", masterOpl.f1.solutionValue);
//			writeln("f2 = ", masterOpl.f2.solutionValue);
			var z1 = masterOpl.f1.solutionValue;
			var z2 = masterOpl.f2.solutionValue;
			writeln("(",z1,",",z2,")");
			
/*			for(var p in masterOpl.patterns){
				if(masterOpl.cut[p].solutionValue > 0){					
					writeln(p, " ", masterOpl.cut[p].solutionValue);
   				}					
			}			*/
		}else{
			writeln("Houston, we have a problem!");	
			break;
		}
		
		masterOpl.end();
		e2 = z2 - delta;
	}		
	
	writeln("\n#### e-CONSTRAINT PRIORIZATING F2 ####:\n");
  	
  	// definition of the master model
  	var masterSource = new IloOplModelSource("modelPriorF2minCP.mod");
  	var masterDef = new IloOplModelDefinition(masterSource);
	var masterCplex = cplex;
   	cplex.epgap = 10e-2;
   	cplex.tilim = 100;	
   	  	
  	var e1 = z1_n;
  	
	while(e1 >= z1_u){
//		writeln("e1 = ", e1);	
		
		var masterOpl = new IloOplModel(masterDef, masterCplex); 
   		var masterData = new IloOplDataSource(data);
		masterOpl.addDataSource(masterData);
		
	  	var dataE = new IloOplDataElements();
	  	dataE.e1 = e1;
	 	masterOpl.addDataSource(dataE);
	  	masterOpl.generate();
		
		if(masterCplex.solve()){
//			writeln("f1 = ", masterOpl.f1.solutionValue);
//			writeln("f2 = ", masterOpl.f2.solutionValue);
			var z1 = masterOpl.f1.solutionValue;
			var z2 = masterOpl.f2.solutionValue;
			writeln("(",z1,",",z2,")");
			
/*			for(var p in masterOpl.patterns){
				if(masterOpl.cut[p].solutionValue > 0){					
					writeln(p, " ", masterOpl.cut[p].solutionValue);
   				}					
			}					*/
		}else{
			writeln("Houston, we have a problem!");	
			break;
		}
		
		masterOpl.end();
		e1 = z1 - delta;
	}		
	
    status;
 }
