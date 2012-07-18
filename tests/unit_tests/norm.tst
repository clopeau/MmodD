// Copyright (C) 2012 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt

//------ p1_2d ------
//-------------------
th=square2d(110,111);
u=p1(th,"1");
tmp=norm(u);
if abs(tmp-1)>1.5e-14  then pause, end
if tmp<>norm(u,2)  then pause, end
if tmp<>norm(u,"L2")  then pause, end
if tmp<>norm(u,"l2")  then pause, end
if norm(u,1)<>norm(u,"L1") then pause, end
if sqrt(norm(u,"L2")^2+norm(u,"semi-H1")^2)<>norm(u,"h1") then pause, end

u=p1(th,"x");
if abs(norm(u,"semi-H1")-1)>1.6e-13  then pause, end
u=p1(th,"y");
if abs(norm(u,"semi-H1")-1)>1.6e-13  then pause, end

u=p1(th,["1" "1"]);
tmp=norm(u);
if abs(tmp-sqrt(2))>2.1e-14  then pause, end
if tmp<>norm(u,2)  then pause, end
if tmp<>norm(u,"L2")  then pause, end
if tmp<>norm(u,"l2")  then pause, end
if abs(norm(u,1)-2)>2.4e-12 then pause, end
if norm(u,1)<>norm(u,"L1") then pause, end
if sqrt(norm(u,"L2")^2+norm(u,"semi-H1")^2)<>norm(u,"h1") then pause, end

u=p1(th,["x" "y"]);
if abs(norm(u,"semi-H1")-sqrt(2))>1.6e-13  then pause, end

//------ p1_3d ------
//-------------------
th=tcube3d(21,22,23);
u=p1(th,"1");
tmp=norm(u);
if abs(tmp-1)>8e-14  then pause, end
if tmp<>norm(u,2)  then pause, end
if tmp<>norm(u,"L2")  then pause, end
if tmp<>norm(u,"l2")  then pause, end
if abs(norm(u,1)-1)>4.4e-13 then pause, end
if norm(u,1)<>norm(u,"L1") then pause, end
if sqrt(norm(u,"L2")^2+norm(u,"semi-H1")^2)<>norm(u,"h1") then pause, end

u=p1(th,"x");
if abs(norm(u,"semi-H1")-1)>1e-14  then pause, end
u=p1(th,"y");
if abs(norm(u,"semi-H1")-1)>1e-14  then pause, end

u=p1(th,["1" "1" "1"]);
tmp=norm(u);
if abs(tmp-sqrt(3))>1.4e-13  then pause, end
if tmp<>norm(u,2)  then pause, end
if tmp<>norm(u,"L2")  then pause, end
if tmp<>norm(u,"l2")  then pause, end
if abs(norm(u,1)-3)>8.1e-12 then pause, end
if norm(u,1)<>norm(u,"L1") then pause, end
if sqrt(norm(u,"L2")^2+norm(u,"semi-H1")^2)<>norm(u,"h1") then pause, end


u=p1(th,["x" "y" "z"]);
if abs(norm(u,"semi-H1")-sqrt(3))>3.3e-15  then pause, end