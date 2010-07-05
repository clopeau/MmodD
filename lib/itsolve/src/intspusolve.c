#include "stack-c.h"
#include "conv.h"

extern int intspusolve(char *fname)
{ 
  int mU=0,nU=0,my=0,ny=0,py,px,row=0,col=0,ind=0,k=0;
  double diag;
  SciSparse U;

  CheckRhs(2,2);
  CheckLhs(1,1);
  if (VarType(1)==5){
    GetRhsVar(1,"s",&mU,&nU,&U);
    if (mU!=nU){
      Scierror(501,"%s: input matrix must be an upper triangular sparse matrix \r\n",fname);
      return 0;
    }
  } else {
    Scierror(501,"%s: input matrix must be an upper triangular sparse matrix \r\n",fname);
    return 0;
  }
  if (VarType(2)==1){
    GetRhsVar(2,"d",&my,&ny,&py);
    if (nU!=my){
      Scierror(501,"%s: inconsistent dimensions \r\n",fname);
      return 0;
    }
  } else {
    Scierror(501,"%s: y must be a matrix \r\n",fname);
    return 0;
  }
  
  CreateVar(3,"d",&my,&ny,&px);
  
  for(col=0;col<ny;col++){
    ind=U.nel-1;
    for(row=mU-1;row>=0;row--){
      stk(px)[row+my*col]=stk(py)[row+my*col];
      diag=0;
      for(k=0;k<U.mnel[row];k++,ind--)
	if (row!=U.icol[ind]-1){
	  stk(px)[row+my*col]-=U.R[ind]  * stk(px)[U.icol[ind]-1+my*col];
	} else {
	  diag=U.R[ind];
	}
      if (diag==0) {
	Scierror(501,"%s: U is a singular matrix \r\n",fname);
	return 0;
      } else {
	stk(px)[row+my*col]/=diag;
      }
    }
  }
  LhsVar(1)=3;
  return(0);
}
