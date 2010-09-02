#include <stack-c.h>
#include <math.h>

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
