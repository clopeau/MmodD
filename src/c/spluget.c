#include <stack-c.h>
#include <math.h>


extern int spluget(int n,int *ju,int *jlu,double *alu,SciSparse **L,SciSparse **U){
  int i=0,row=0,indLU=n+1,indL=0,indU=0;

  *L=(SciSparse *) malloc(sizeof(SciSparse));
  (*L)->m=n;
  (*L)->n=n;
  (*L)->it=0;
  (*L)->nel=0;
  (*L)->mnel=(int *) malloc(n*sizeof(int));
  
  *U=(SciSparse *) malloc(sizeof(SciSparse));
  (*U)->m=n;
  (*U)->n=n;
  (*U)->it=0;
  (*U)->nel=0;
  (*U)->mnel=(int *) malloc(n*sizeof(int));
  
  for (i=0; i<n ;i++){
    (*L)->mnel[i]=ju[i]-jlu[i]+1;
    (*L)->nel+=(*L)->mnel[i];
    (*U)->mnel[i]=jlu[i+1]-ju[i]+1;
    (*U)->nel+=(*U)->mnel[i];
  }

  (*L)->icol=(int *) malloc((*L)->nel*sizeof(int));
  (*L)->R=(double *) malloc((*L)->nel*sizeof(double));

  (*U)->icol=(int *) malloc((*U)->nel*sizeof(int));
  (*U)->R=(double *) malloc((*U)->nel*sizeof(double));
 
  for (row=0;row<n;row++){
    for(i=0;i<(*L)->mnel[row]-1 ;i++){
      (*L)->icol[indL]=jlu[indLU];
      (*L)->R[indL]=alu[indLU];
      indL++;
      indLU++;
    }
    
    (*L)->icol[indL]=row+1;
    (*L)->R[indL]=1;
    indL++;
    
    (*U)->icol[indU]=row+1;
    (*U)->R[indU]=1/(alu[row]);
    indU++;
    
    for(i=0;i<(*U)->mnel[row]-1;i++){
      (*U)->icol[indU]=jlu[indLU];
      (*U)->R[indU]=alu[indLU];
      indU++;
      indLU++;
    }
  }
  
  return(0);
}
