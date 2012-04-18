/* Copyright (C) 2012 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info

calling sequence :  A=fastsparse(ij,a,[m,n])
sp2=fastsparse([1,2;4,5;3,10],[2,1,3],[4,10]);
sp1=sparse([1,2;4,5;3,10],[2,1,3],[4,10]);
sp-sp1
stacksize('max')
for n=100:50:600
  th=square2d(n,n);
  [np,nt]=size(th);
  timer();sp1=sparse([th.Tri(:,1:2);th.Tri(:,2:3);th.Tri(:,[1 3])],ones(1:3*nt),[np,np]);t=timer();
  timer();sp2=fastsparse([th.Tri(:,1:2);th.Tri(:,2:3);th.Tri(:,[1 3])],ones(1:3*nt),[np,np]);tfast=timer();
  disp(max(Res=sp1-sp2))
  write(%io(2),string(np)+'- sparse '+string(t)+'  fast '+string(tfast))
end
*/
#include "api_scilab.h"
#include "stack-c.h"
#include "Scierror.h"
#include "MALLOC.h"
#include <sciprint.h>


extern void F2C(fastsparse)(int *nnz,int *nl,int *ij,double *a,int *pij,int *jout);


extern int sci_fastsparse(char *fname)
{ 
  int i,j;
  /* input */
  int iIJ,jIJ,IJ;
  int ia,ja,a;
  int idim,jdim,dim;
  /* work space */
  int *pIJ=NULL,*jout=NULL,nj,nn,indj,jtmp;
  /* output */
  SciSparse *A=NULL;

  CheckRhs(3,3) ;
  CheckLhs(1,1) ;   
 
  /* check input IJ type */
  if (VarType(1)==1)
    {
     /* get Address of inputs */
      GetRhsVar(1,"i",&iIJ,&jIJ,&IJ)
    }
  else
    {
      Scierror(501,"%s: input argument must be integer \r\n",fname);
      return 0;
    } 
  /* check size */
  if (jIJ != 2)
    {
      Scierror(999,"%s: Wrong size for input argument #%d: A 2 colums matrix of integer expected.\n",fname,1);
      return 0;
    }

  /* get Address of inputs 2 */
  GetRhsVar(2,"d",&ia,&ja,&a)
  if (ja != 1 && ia != 1)
    {
      Scierror(999,"%s: Wrong size for input argument #%d: A single colum matrix expected.\n",fname,2);
      return 0;
    }
  if (ia*ja != iIJ)
    {
      Scierror(999,"%s: Incompatible size dimension for input argument 1 and 2.\n",fname,2);
      return 0;
    }
  /* get Address of inputs 3 */
  GetRhsVar(3,"i",&idim,&jdim,&dim)
    if (idim*jdim != 2)
    {
      Scierror(999,"%s: Wrong size for input argument #%d: A 2 integer values matrix expected.\n",fname,3);
      return 0;
    }
  
  /* working variable matrix of size (3*itri,2)  */
  pIJ=(int *) malloc(iIJ*sizeof(int));
  if (pIJ==NULL)
    {
      Scierror(112,"%s: No more memory.\n",fname);
      return 0;
    }

  jout=(int *) malloc(*istk(dim)*sizeof(int));
  if (jout==NULL)
    {
      Scierror(112,"%s: No more memory.\n",fname);
      return 0;
    }
  
  jtmp=iIJ;
  /* call fortran subroutine  */
  F2C(fastsparse)(&iIJ,istk(dim),istk(IJ),stk(a),pIJ,jout);


  /* output */
  A=(SciSparse *) malloc(sizeof(SciSparse));
  A->m=*istk(dim);
  A->n=*istk(dim+1);
  A->it=0;
  A->nel=iIJ;
  A->mnel=(int *) malloc(*istk(dim)*sizeof(int));
  A->icol=(int *) malloc(iIJ*sizeof(int));
  A->R=(double *) malloc(iIJ*sizeof(double));

  jtmp=IJ+jtmp-1;
  nn=0;
  for (i=0;i<*istk(dim);i++)
    {
      nj=0;
      indj=jout[i];
      while (indj>0)
	{
	  A->icol[nn]=*istk(jtmp+indj);
	  A->R[nn]=*stk(a+indj-1);
          nn++;
	  nj++;
	  indj=pIJ[indj-1];
	}
      A->mnel[i]=nj;
    }

  CreateVarFromPtr(4,"s",&A->m,&A->n,A);
 
  /* De-allocate working variable  */
  free(pIJ);
  free(jout);

 
  LhsVar(1)=4;
  return(0);
}
