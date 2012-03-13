/* Copyright (C) 2005 - INRIA - Sage Group (IRISA)
// Copyright (C) 2011 - Thierry Clopeau

//This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution.  The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
*/

#include <stack-c.h>
#include <math.h>

extern void Spk2sci(SciSparse *A);
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
