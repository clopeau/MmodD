/* Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 
*/
#include "stack-c.h"
#include "conv.h"
#include "ilut.h"

extern int intpbcgstab(char *fname)
{ 
  int mA,nA,*ia;
  int mb,nb,msol,nsol,nniter,mniter,meps,neps,mkry,nkry,nlfil,mlfil;
  int b,sol,niter,eps,kry,lfil,pierr;
  int mdt=1,ndt=1,pdt,k;
  int mierr=1,nierr=1,iout=6,method=5;  
  int iwk, *jw, *jlu, *ju, *ipar;
  double *w,*alu,*fpar;
  SciSparse A;
  
  CheckRhs(1,8);
  CheckLhs(1,2);
  if (VarType(1)==5){
    GetRhsVar(1,"s",&mA,&nA,&A);
    if (mA!=nA){
      Scierror(501,"%s: input matrix must be square \r\n",fname);
    }
  } else {
    Scierror(501,"%s: input matrix must be sparse \r\n",fname);
    return 0;
  }
  if (VarType(2)==1){
    GetRhsVar(2,"d",&mb,&nb,&b);
    if ((mb!=nA)||(nb!=1)){
      Scierror(501,"%s: incompatible rhs \r\n",fname);
    }
  } else {
    Scierror(501,"%s: rhs must be a vector \r\n",fname);
    return 0;
  }
  if (VarType(3)==1){
    GetRhsVar(3,"d",&msol,&nsol,&sol);
    if ((msol!=nA)||(nsol!=1)){
      Scierror(501,"%s: incompatible init \r\n",fname);
    }
  } else {
    Scierror(501,"%s: init must be a vector \r\n",fname);
    return 0;
  }
  if (VarType(4)==1){
    GetRhsVar(4,"i",&nniter,&mniter,&niter);
    if (mniter*nniter!= 1){
      Scierror(501,"%s: niter must be a single integer \r\n",fname);
    }
  } else {
    Scierror(501,"%s: niter must be integer \r\n",fname);
    return 0;
  }
  if (VarType(5)==1){
    GetRhsVar(5,"d",&meps,&neps,&eps);
    if (meps*neps!= 1){
      Scierror(501,"%s: eps must be a real \r\n",fname);
    }
  } else {
    Scierror(501,"%s: init must be a real \r\n",fname);
    return 0;
  }
  if (VarType(6)==1){
    GetRhsVar(6,"i",&mlfil,&nlfil,&lfil);
    if (mlfil*nlfil!= 1){
      Scierror(501,"%s: lfil must be a single integer \r\n",fname);
    } 
  } else {
    Scierror(501,"%s: lfil  must be a integer \r\n",fname);
      return 0;
  }
  if (Rhs>=7) {
    if (VarType(7)==1){
      GetRhsVar(7,"d",&mdt,&ndt,&pdt);
      if ((mdt!=1)||(ndt!=1)){
	Scierror(501,"%s: drop must be a double \r\n",fname);
      }
    } else {
      Scierror(501,"%s: drop must be a double \r\n",fname);
      return 0;
    }
  } else {
    CreateVar(7,"d",&mdt,&ndt,&pdt);
    *stk(pdt)=(double) 0.001*eltm(A) ;
  }

  
  CreateVar(8,"i",&mierr,&nierr,&pierr);

  iwk=(A.m)*(2*(*istk(lfil))+1)+1;
  jw=(int *) malloc(2*A.m*sizeof(int));
  w= (double *) malloc(A.m*sizeof(double));
  
  alu= (double *) malloc(iwk*sizeof(double));
  jlu= (int *) malloc(iwk*sizeof(int));
  ju= (int *) malloc((A.m)*sizeof(int));
  ia=Sci2spk(&A);

  C2F(ilut)(&A.m,A.R,A.icol,ia,istk(lfil),stk(pdt),alu,jlu,ju,&iwk,w,jw,istk(pierr));
  free(w);
  free(jw);

  if (*istk(pierr)!=0){
    free(ju);
    free(jlu);
    free(alu);
    if (*istk(pierr)==-1) {
      Scierror(501,"%s: input matrix may be wrong \r\n",fname);
    } else if (*istk(pierr)==-2) {
      Scierror(501,"%s: not enough memory for matrix L \r\n",fname);
    } else if (*istk(pierr)==-3) {
      Scierror(501,"%s: not enough memory for matrix U \r\n",fname);
    } else if (*istk(pierr)==-4) {
      Scierror(501,"%s: illegal value for lfil \r\n",fname);
    } else if (*istk(pierr)==-5) {
      Scierror(501,"%s: zero row encountered in A or U \r\n",fname);
    } else {
      Scierror(501,"%s: zero pivot encountered at step number %d \r\n",fname,*istk(pierr));
    }
  } else {
    iwk=(A.m)*8;
    w= (double *) malloc(iwk*sizeof(double));
    fpar=(double *) malloc(16*sizeof(double));
    ipar=(int *) malloc(16*sizeof(int));
    for (k = 0; k < 16; ++k) 
      ipar[k]=0;
    ipar[1]=2;
    ipar[2]=1;
    ipar[3]=iwk;
    ipar[4]=10;
    ipar[5]=*istk(niter);
    fpar[0]=*stk(eps);
    fpar[1]=(double) 1.0E-20;

    C2F(runrc)(&A.m, stk(b), stk(sol), ipar, fpar ,w ,A.R ,A.icol , ia, alu, jlu, ju, &method, &iout);
    free(fpar);
    *istk(pierr)=ipar[0];
    free(ipar);
    free(w);
    free(ju);
    free(jlu);
    free(alu);
  }
  LhsVar(1)=3;
  LhsVar(2)=8;
  return(0);
}
