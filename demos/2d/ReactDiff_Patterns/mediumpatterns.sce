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

%path=get_absolute_file_path("mediumpatterns.sce");

// model parameters
delta=0.001
a=103
b=77
rho=13
alpha=1.5
K=0.125
gama=300
d=13
level=22

// simulation parameters
delta=0.0005
NBrepet=200

// initial conditions
init_u="22+sin(x*y-6*y)"
init_v="21+y"

exec(%path+"ReactDiff_Patterns.sce")

