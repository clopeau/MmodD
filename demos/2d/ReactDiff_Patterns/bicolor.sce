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

%path=get_absolute_file_path("bicolor.sce");

// model parameters
a=103
b=77
rho=3
alpha=0.5
K=0.2125
gama=0.001
d=4
level=1

// simulation parameters
delta=0.001
NBrepet=100

tmp=zeros(size(th),1);
tmp(1:10:100)=20;
init_u="tmp"
init_v="5+40*sin(20*y+10*x)"

exec(%path+"ReactDiff_Patterns.sce")
