#include <stack-c.h>
#include <math.h>

extern double eltm(SciSparse A){
  int i=0;
  double m=0;
  
  for(i=0;i<A.nel;i++)
    if (fabs(A.R[i])>m)
      m=fabs(A.R[i]);
  return m;
}
