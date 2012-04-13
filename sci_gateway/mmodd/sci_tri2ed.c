/* Copyright (C) 2012 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info

calling sequence :  [Ed,Tri2Ed]=tri2ed(1:3) 
exec loader.sce
stacksize('max')
for n=200:20:600
  th=square2d(n,n);
  timer();[Ed,Tri2Ed]=tri2ed(th.Tri);timer()
  disp(max(Ed),size(th))
end
*/
#include "api_scilab.h"
#include "stack-c.h"
#include "Scierror.h"
#include "MALLOC.h"
#include <sciprint.h>


extern int F2C(tri2ed)(int *ntri,int *tri,int *ned,int *ed,int *tried,int *hts, int *wht,int *wed);
extern int F2C(prime)(int *ntri,int *jtri);

extern int sci_tri2ed(char *fname)
{ 
  int i,j;
  /* input */
  int itri,jtri,Tri;
  /* work space */
  int *wEd=NULL,htsiz,*wht=NULL,*wed3=NULL;
  /* output */
  int ied,jed,Ed;
  int Tri2Ed;

  CheckRhs(1,1) ;
  CheckLhs(1,2) ;   
 
  /* check input type */
  if (VarType(1)==1)
    {
     /* get Address of inputs */
      GetRhsVar(1,"i",&itri,&jtri,&Tri)
    }
  else
    {
      Scierror(501,"%s: input argument must be integer \r\n",fname);
      return 0;
    } 
  /* check size */
  if (jtri != 3)
    {
      Scierror(999,"%s: Wrong size for input argument #%d: A 3 colums matrix of integer expected.\n",fname,1);
      return 0;
    }

  /* working variable matrix of size (3*itri,2)  */
  wEd=(int *) malloc(itri*6*sizeof(int));
  if (wEd==NULL)
    {
      Scierror(112,"%s: No more memory.\n",fname);
      return 0;
    }
  F2C(prime)(&itri,&htsiz);

  wht=(int *) malloc(htsiz*sizeof(int));
  if (wht==NULL)
    {
      Scierror(112,"%s: No more memory.\n",fname);
      return 0;
    }

  wed3=(int *) malloc(itri*3*sizeof(int));
  if (wed3==NULL)
    {
      Scierror(112,"%s: No more memory.\n",fname);
      return 0;
    }

  CreateVar(2,"i",&itri,&jtri,&Tri2Ed);

  /* call fortran subroutine  */
  F2C(tri2ed)(&itri,istk(Tri),&ied,wEd,istk(Tri2Ed),&htsiz,wht,wed3);

  /* output */
  jed=2;
  
  CreateVar(3,"i",&ied,&jed,&Ed);
 
  j=Ed;
  for (i = 0 ; i <ied ; ++i)
    {
      *istk(j)= wEd[i];
      j++;
    }
  j=3*itri;
  for (i = Ed+ied ; i <Ed+2*ied+1 ; ++i)
    {
      *istk(i)= wEd[j];
      j++;
    }
  
  /* De-allocate working variable  */
  free(wEd);
  free(wht);
  free(wed3);
 
  LhsVar(1)=3;
  LhsVar(2)=2;
  return(0);
}
