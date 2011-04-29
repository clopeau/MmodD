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

