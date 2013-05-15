// Copyright (C) 2013 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function B=p0_3d_Id_p1_3d(%u)
    if typeof(%u)~='p0_3d'
      error('Bad type argument in p0_3d_Id_p1_3d expected p0_3d')
    end

     // implantation sur un maillage de type tri2d !!
     %th=%u.geo;
     execstr('[nf,nt]=size('+%th+')');
	
     //------------- Calcul du déterminant ------------------------
     execstr('Det='+%th+'.Det /4');
     
     B=spzeros(nf,nt);
     if %u.domain==[]
       col=(1:nt)';
       for i=1:4
	 execstr('B=B+fastsparse(['+%th+'.Tet(:,i), col],Det,[nf,nt])');
       end
     else
       col=(1:nt)';
       col=col(%u.BoolTet);
       for i=1:4
	 execstr('B=B+fastsparse(['+%th+'.Tet(%u.BoolTet,i),col],Det(%u.BoolTet),[nf,nt])');
       end
     end

 endfunction
 
