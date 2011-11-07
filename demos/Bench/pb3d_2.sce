// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

demopath = get_absolute_file_path("pb3d_2.sce");

probl=['pb=pde(u);';
    'pb.eq=''-Laplace(u)=12*%pi^2*cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'';';
    'pb.S=''Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'';';
    'pb.N=''Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'';';
    'pb.W=''Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'';';
    'pb.E=''Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'';';
    'pb.U=''Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'';';
    'pb.D=''Id(u)=cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'';';
    'sexacte=''cos(2*%pi*x)*cos(2*%pi*y)*cos(2*%pi*z)'';'];

exec(demopath+'main.sce');
