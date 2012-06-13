// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function B=kId_p1_3d(%kk,%u)
     if typeof(%kk)=='p1_3d'
      %kk=p0(%kk)
     end
   
     %th=%u.geo;
     execstr('[nf,nt]=size('+%th+')');
     //index=[2 3; 3 1; 1 2]';
     ci=1/20; 
     cid=1/10; 
     //------------- Calcul du déterminant ------------------------
     execstr('Det='+%th+'.Det .* %kk.Cell /6');
     B=spzeros(nf,nf);
     Diag=spzeros(nf,1);
     for i=1:4
       execstr('Diag=Diag+fastsparse(['+%th+'.Tet(:,i),ones(nt,1)],Det*cid,[nf,1])');
       for j=i+1:4
	 execstr('B=B+fastsparse('+%th+'.Tet(:,[i j]),Det*ci,[nf,nf])');
       end
     end
     B=B+B'+diag(Diag)
endfunction
 
