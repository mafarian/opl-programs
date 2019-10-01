# opl-programs
  
## Introduction 

The cutting stock problem is of great importance for industries that deal with the transformationof materials (objects) into smaller ones (items) through cutting processes. One of the great interests of these industries is the minimization of the losses obtained during the cut, since these losses are usually onerous for the industries and also due to the concern with the excess of generated residues. In some cases, the preparation of the machine for the execution of a cutting pattern can be costly; thus reducing the number of different cutting patterns (i.e., setup) can increase productivity in these industries by reducing the preparation time of the cutting machines. In this research project we studied integer linear programming mathematical models and solution methods existent in the literature to solve the one-dimensional stock cutting problem with minimization of the number of different types of cutting patterns.

### Variables

- L: object lenght
- nitems: number of different items
- len[]: items sizes
- demands[]: items demands
- maxcut: a big number (could be the sum of the demands)
- pattern (a tuple that represents a cutting pattern, containing 2 fields)
  * id: pattern identification
  * fill[]: quantity of each item in it
- patterns[]: array that cointains all cutting patterns
- **cut[]:** cut frequency for each cutting pattern (integer)
- **usepatt[]:** boolean variable indicating if the pattern is used (=1) or not (=0) (boolean)
- f1 = sum(p in patterns) cut[p]: total of objects used
- f2 = sum(p in patterns) usepatt[p]: quantity of differents cutting patterns used
  
  
## General model 
  
  We want to find the best set of cutting patterns and its cut frequencies that minimizes both objetive functions.
  
  minimize **f = (f1,f2)**
  
  subject to: **sum(p in patterns) p.fill[i]\*cut[p] >= demands[i]  for all item i**

### Model 0-
  Model 0 is the Column Generation tool used to solve some models bellow, which is a specific Knapsack Problem, using the duals variables of each model.
  
### Model 1
  Model 1 minimizes only ***f1***, but using the same constraint set. For this, we used Column Generation (model 0-1)

### Model 2
  Model 1 minimizes ***f1 + f2***. For this, we also used Column Generation (model 0-2).
  
### Model 3
  Model 3 solves the two objectives apart, and find the Utopia point (z_u) and Nadir point (z_n) of each function. For this, we solved the models exactly, ie, enumerating all the feasable cutting patterns.
  
  > * (z1_u, z2_n) are the solutions (values of f1 and f2) obtained by minimizing only ***f1***
  > * (z1_n, z2_u) are the solutions (values of f1 and f2) obtained by minimizing only ***f2***  
  
### Model 4 (Weighted Sum)
  Model 3 minimizes ***w\*h1 + (1-w)\*h2***, where w is in (0,1) and *h* are normalized objective functions:
  
  > * h1 = (f1 - z1_u)/(z1_n - z1_u)
  > * h2 = (f2 - z2_u)/(z2_n - z2_u)
   
  For this, we used Column Generation (model 0-4).
   
 ### Model 5 (e-constraint)
  Model 4 minimizes two models:
  
  > * ***f1*** but adding the constraint *f2 <= e2*
  > * ***f2*** but adding the constraint *f1 <= e1*   
   
  For this, we used all columns (all feasable patterns).   
