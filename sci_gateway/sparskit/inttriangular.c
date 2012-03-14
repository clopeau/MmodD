/* Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 
*/
#include <string.h>
#include "stack-c.h"

extern int inttriangular(char *fname)
{ 
  int mA,nA,row=0,i=0,ind=0;
  int lower=1,upper=1;
  int un=1;
  int pstr;
  SciSparse A;

  CheckRhs(1,1);
  CheckLhs(1,1);
  if (VarType(1)==5){
    GetRhsVar(1,"s",&mA,&nA,&A);    
    if (mA!=nA){
      Scierror(501,"%s: input matrix must be square \r\n",fname);
    }
  } else {
    Scierror(501,"%s: input matrix must be sparse \r\n",fname);
  }
  
  while ((row<A.m)&&(lower||upper)) {
    for(i=0;i<A.mnel[row];i++,ind++){
      if (A.icol[ind]>row+1)
	lower=0;
      if (A.icol[ind]<row+1)
	upper=0;
    }
    row++;
  }

  if (lower && upper){
    CreateVar(2,"i",&un,&un,&pstr);
    *istk(pstr)=3;
  } else if (lower){ 
    CreateVar(2,"i",&un,&un,&pstr);
    *istk(pstr)=1;
  } else if (upper){
    CreateVar(2,"i",&un,&un,&pstr);
    *istk(pstr)=2;
  } else {
    CreateVar(2,"i",&un,&un,&pstr);
    *istk(pstr)=0;
  }
  
  LhsVar(1)=2;
  return 0;
}
