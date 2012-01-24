// Copyright (C) 2011 - Bouvet Paul-Edouard
// Copyright (C) 2011 - Chun Yuk Shan Nadège
// Copyright (C) 2011 - Mazzocco Pauline
// Copyright (C) 2011 - Moncel Marie
// Copyright (C) 2011 - Vacher Anthony
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
//  

%path=get_absolute_file_path("bigpatterns.sce");

// model parameters
a=103
b=77
rho=14
alpha=1.5
K=0.125
gama=10
d=13
level=9

// simulation parameters
delta=0.006
NBrepet=200

// initial conditions
init_u="9+7*sin(20*x-30*y)";
init_v="20-5*sin((30-x)*y*x)";

exec(%path+"ReactDiff_Patterns.sce")
