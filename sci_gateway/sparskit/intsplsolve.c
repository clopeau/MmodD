/* Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 
*/
#include "stack-c.h"
#include "conv.h"

extern int intsplsolve(char *fname)
{ 
  int mL=0,nL=0,my=0,ny=0,py,px,row=0,col=0,ind=0,k=0;
  double diag;
  SciSparse L;

  CheckRhs(2,2);
  CheckLhs(1,1);
  if (VarType(1)==5){
    GetRhsVar(1,"s",&mL,&nL,&L);
    if (mL!=nL){
      Scierror(501,"%s: input matrix must be a lower triangular sparse matrix \r\n",fname);
      return 0;
    }
  } else {
    Scierror(501,"%s: input matrix must be a lower triangular sparse matrix \r\n",fname);
    return 0;
  }
  if (VarType(2)==1){
    GetRhsVar(2,"d",&my,&ny,&py);
    if (nL!=my){
      Scierror(501,"%s: inconsistent dimensions \r\n",fname);
      return 0;
    }
  } else {
    Scierror(501,"%s: y must be a matrix \r\n",fname);
    return 0;
  }
  
  CreateVar(3,"d",&my,&ny,&px);
  
  for(col=0;col<ny;col++){
    ind=0;
    for(row=0;row<mL;row++){
      stk(px)[row+col*my]=stk(py)[row+col*my];
      diag=0;
      for(k=0;k<L.mnel[row];k++,ind++)
	if (row!=L.icol[ind]-1){
	  stk(px)[row+col*my]-=L.R[ind]  * stk(px)[L.icol[ind]-1+col*my];
	} else {
	  diag=L.R[ind];
	}
      if (diag==0) {
	Scierror(501,"%s: L is a singular matrix \r\n",fname);
	return 0;
      } else {
	stk(px)[row+col*my]/=diag;
      }
    }
  }
  LhsVar(1)=3;
  return(0);
}
