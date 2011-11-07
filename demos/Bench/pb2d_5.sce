// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

demopath = get_absolute_file_path("pb2d_5.sce");

probl=['pb=pde(u);';
    'pb.eq=''-Laplace(u)=8*%pi^2*sin(2*%pi*x)*sin(2*%pi*y)'';';
    'pb.N=''Dn(u)=2*%pi*sin(2*%pi*x)'';';
    'sexacte=''sin(2*%pi*x)*sin(2*%pi*y)'';']

exec(demopath+'main.sce');
