#include <stack-c.h>
#include <math.h>

extern int *Sci2spk(A)
  SciSparse *A;
{
  int *ia;
  int i;
  /* int *temp; */

  ia=(int *) malloc((A->m+1)*sizeof(int));
  ia[0]=1;
  for (i=1; i < A->m+1 ; i++)
    ia[i]=ia[i-1]+A->mnel[i-1];
  
  /* temp=A->mnel; */
  /* A->mnel=ia; */
  /* free(temp); */

  return ia;
}

extern void Spk2sci(A)
  SciSparse *A;
{
  int i;

  A->nel=A->mnel[A->m]-1;
  for (i=0; i < A->m ; i++)
    A->mnel[i]=A->mnel[i+1] - A->mnel[i];
  
  A->mnel=(int *) realloc(A->mnel,A->m*sizeof(int));
  A->icol=(int *) realloc(A->icol,A->nel*sizeof(int));
  A->R=(double *) realloc(A->R,A->nel*sizeof(double));
}  

extern SciSparse *NewSpk(it,m,n,nel)
     int *m,*n,*nel,*it;
{
  SciSparse *loc;
  loc = (SciSparse *) malloc((unsigned) sizeof(SciSparse));
  if ( loc == (SciSparse *) 0)
    return((SciSparse *) 0);
  
  loc->m = *m;
  loc->n = *n;
  loc->it = *it;
  loc->nel = *nel;
  loc->mnel = (int*) malloc((unsigned) (*m+1)*sizeof(int));
  if ( loc->mnel == (int *) 0){
    FREE(loc);
    return((SciSparse *) 0);
  }
  loc->icol = (int*) malloc((unsigned) (*nel)*sizeof(int));
  if ( loc->icol == (int *) 0){
    FREE(loc->mnel);
    FREE(loc);
    return((SciSparse *) 0);
  }
  loc->R =  (double*) malloc((unsigned) (*nel)*sizeof(double));
  if ( loc->R == (double *) 0){
    FREE(loc->icol);
    FREE(loc->mnel);
    FREE(loc);
    return((SciSparse *) 0);
  }

  if ( *it == 1){
    loc->I =  (double*) malloc((unsigned) (*nel)*sizeof(double));
    if ( loc->I == (double *) 0)
      {
	FREE(loc->R);
	FREE(loc->icol);
	FREE(loc->mnel);
	FREE(loc);
	return((SciSparse *) 0);
      }
  }
  return(loc);
}

/* la bande en SparsKit */
/* extern int lband(SciSparse A){
   int i=0,bd=0;
   
   for(i=0;i<A.m;i++)
   if (A.mnel[i+1]!=A.mnel[i])
   bd+=A.icol[A.mnel[i+1]-2]-A.icol[A.mnel[i]-1]+1;
   return bd;
   }
*/

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

extern double eltm(SciSparse A){
  int i=0;
  double m=0;
  
  for(i=0;i<A.nel;i++)
    if (fabs(A.R[i])>m)
      m=fabs(A.R[i]);
  return m;
}

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
