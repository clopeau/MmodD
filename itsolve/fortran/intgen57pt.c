#include "stack-c.h"
#include "conv.h"
#include "genmat.h"

extern int intgen57pt(char *fname)
{
  int nb ;
  double *al;
  int *ja, *ia, *iau;
  double *aa;
  SciSparse *A;
  double *rhs;
  int i,m1,n1,l1,m2,n2,l2,m3,n3,l3,m4=1,n4=6,l4,m5=1,n5=1,l5,l6;
  int mA,iwk, nrhs=1;

  CheckRhs(3,5);
  CheckLhs(1,2);

  if (Rhs <= 2){
    Scierror(503,"Three arguments are required at least \r\n");
  }

  if (Rhs >= 3){

    if (VarType(1)==1){
      GetRhsVar(1,"i",&m1,&n1,&l1); 
      if (n1*m1 != 1){
	Scierror(503,"%s: nx must be a scalar \r\n",fname);
	return 0;
      }
    } else {
      Scierror(503,"%s: nx must be a scalar \r\n",fname);
      return 0;
    }

    if (VarType(2)==1){
      GetRhsVar(2,"i",&m2,&n2,&l2);    
      if (n2*m2 != 1){
	Scierror(503,"%s: ny must be a scalar \r\n",fname);
	return 0;
      }
    } else {
      Scierror(503,"%s: ny must be a scalar \r\n",fname);
      return 0;
    }

    if (VarType(3)==1){
      GetRhsVar(3,"i",&m3,&n3,&l3);
      if (n3*m3 != 1){
	Scierror(503,"%s: nz must be a scalar \r\n",fname);
	return 0;
      }    
    } else {
      Scierror(503,"%s: nz must be a scalar \r\n",fname);
      return 0;
    }
  }

  if (Rhs>=4) {
    if (VarType(4)==1){
      GetRhsVar(4,"d",&m4,&n4,&l4);
    } else {
      Scierror(503,"%s: al must be an array \r\n",fname);
      return 0;
    }
  } else {
    CreateVar(4,"d",&m4,&n4,&l4);
    for(i=0;i<6;i++)
      {
	stk(l4)[i]=0;
      }
  }

  if (Rhs>=5) {
    if (VarType(5)==1){
      GetRhsVar(5,"i",&m5,&n5,&l5);
      if (n5*m5 != 1){
	Scierror(503,"%s: mod must be a scalar \r\n",fname);
        return 0;
      }
    } else {
      Scierror(503,"%s: mod must be a scalar \r\n",fname);
      return 0;
    }
  } else {
    CreateVar(5,"i",&m5,&n5,&l5);
    *istk(l5)=0;
  }

  if ( (Lhs == 2) && (*istk(l5))==0 ){
    Scierror(503,"%s: if right-hand side is expected, mod must be > 0",fname);
    return 0;
  } 

  mA=(*istk(l1))*(*istk(l2))*(*istk(l3));
  iwk=7*mA;
  aa= (double *) malloc(iwk*sizeof(double));
  ja= (int *) malloc(iwk*sizeof(int));
  ia= (int *) malloc((mA+1)*sizeof(int));
  iau= (int *) malloc(mA*sizeof(int));
  rhs= (double *) malloc(mA*sizeof(double));

  C2F(gen57pt)(istk(l1),istk(l2),istk(l3),stk(l4),istk(l5),&nb,aa,ja,ia,iau,rhs);

  CreateVar(6,"d",&nb,&nrhs,&l6);
  
  for (i=0;i<nb;i++){
    stk(l6)[i]=rhs[i];
  }

  free(rhs);
  free(iau);

  A=(SciSparse *) malloc ( sizeof(SciSparse));
  A->R=aa;
  A->icol=ja;
  A->mnel=ia;
  A->m=nb;
  A->n=nb;
  A->it=0;
  A->nel=iwk;

  Spk2sci(A);

  CreateVarFromPtr(7,"s",&A->m,&A->n,A);

  free(aa);
  free(ja);
  free(ia);
  
  LhsVar(1)=7;
  LhsVar(2)=6;

  return(0);
}
