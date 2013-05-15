// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function B=p0_2d_Id_p1_2d(%u)
    if typeof(%u)~='p0_2d'
      error('Bad type argument in p0_2d_Id_p1_2d expected p0_2d')
    end

     // implantation sur un maillage de type tri2d !!
     %th=%u.geo;
     execstr('[nf,nt]=size('+%th+')');
	
     //------------- Calcul du déterminant ------------------------
     execstr('Det='+%th+'.Det /3');
     
     B=spzeros(nf,nt);
     if %u.domain==[]
       col=(1:nt)';
       for i=1:3
	 execstr('B=B+fastsparse(['+%th+'.Tri(:,i), col],Det,[nf,nt])');
       end
     else
       col=(1:nt)';
       col=col(%u.BoolTri);
       for i=1:3
	 execstr('B=B+fastsparse(['+%th+'.Tri(%u.BoolTri,i),col],Det(%u.BoolTri),[nf,nt])');
       end
     end

 endfunction
 
