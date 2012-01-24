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

    
%path=get_absolute_file_path("black.sce");

// model parameters
a=103
b=77
rho=13
alpha=0.5
K=0.125
gama=0.0001
d=13
level=4.45

// simulation parameters
delta=0.01
NBrepet=100

// initial conditions
init_u="4.7+3*sin(5*x+3*y)"
init_v="20+3*y"

exec(%path+"ReactDiff_Patterns.sce")


