// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function B=kId_p1_2d(%kk,%u)
    if typeof(%kk)=='p1_2d'
      %kk=p0(%kk)
    end

     // matrice de masse sur tout le domaine
     // implantation sur un maillage de type tri2d !!
     %th=%u.geo;
     execstr('[nf,nt]=size('+%th+')');
     index=[2 3; 3 1; 1 2]';
     ci=1/24; 
     cid=1/12; 
	
     //------------- Calcul du déterminant ------------------------
     execstr('Det='+%th+'.Det .*%kk.Cell');
     
     B=spzeros(nf,nf);
     Diag=spzeros(nf,nf);
     if %u.domain==[]
       for i=1:3
	 execstr('Diag=Diag+fastsparse('+%th+'.Tri(:,[i i]),Det*cid,[nf,nf])');
	 for j=i+1:3
	   execstr('B=B+fastsparse('+%th+'.Tri(:,[i j]),Det*ci,[nf,nf])');
	 end
       end
       B=B+B'+Diag;
     else
        for i=1:3
	 execstr('Diag=Diag+fastsparse('+%th+'.Tri(%u.BoolTri,[i i]),Det(%u.BoolTri)*cid,[nf,nf])');
	 for j=i+1:3
	   execstr('B=B+fastsparse('+%th+'.Tri(%u.BoolTri,[i j]),Det(%u.BoolTri)*ci,[nf,nf])');
	 end
       end
       B=B+B'+Diag;
       B=B(%u.BoolNode,%u.BoolNode);
     end

 endfunction
 
