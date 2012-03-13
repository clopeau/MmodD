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

extern double eltm(SciSparse A){
  int i=0;
  double m=0;
  
  for(i=0;i<A.nel;i++)
    if (fabs(A.R[i])>m)
      m=fabs(A.R[i]);
  return m;
}
