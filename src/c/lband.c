#include <stack-c.h>
#include <math.h>
/* la bande en Scilab */
extern int lband(SciSparse A){
  int i=0,bd=0,brow=0,erow=0;
  
  for(i=0;i<A.m;i++)
    if (A.mnel[i]!=0){
      erow=brow+A.mnel[i]-1;
      bd+=A.icol[erow]-A.icol[brow]+1;
      brow=erow+1;
    }
  return bd;
}

