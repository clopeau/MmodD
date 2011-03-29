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





/* la bande en SparsKit */
/* extern int lband(SciSparse A){
   int i=0,bd=0;
   
   for(i=0;i<A.m;i++)
   if (A.mnel[i+1]!=A.mnel[i])
   bd+=A.icol[A.mnel[i+1]-2]-A.icol[A.mnel[i]-1]+1;
   return bd;
   }
*/


