// Copyright (C) 2010-11 - Thierry Clopeau
// Copyright (C) 2013 - Gilquin Laurent
// Copyright (C) 2013 - Lefebvre Augustin
// Copyright (C) 2013 - Janczarski Stéphane
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
//
//  
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

function [out, %th]=p1_2d(%th, %fonction, %domain)
    // Node est le seul champ 
    [lhs,rhs]=argn(0);
    if rhs==0
        out=mlist(['p1_2d';'#';'Id';'geo';'domain';'Node';'BoolNode';'BoolTri';'Time']..
        ,rand(),"","",[],[],[],[],[]);
    elseif rhs==1
        %fonction="";
        out=mlist(['p1_2d';'#';'Id';'geo';'domain';'Node';'BoolNode';'BoolTri';'Time']..
        ,rand(),%fonction,name_mmodd(%th),[],[],[],[],[]);     
    elseif rhs==2 & ~exists('domain','local')
        out=mlist(['p1_2d';'#';'Id';'geo';'domain';'Node';'BoolNode';'BoolTri';'Time']..
        ,rand(),%fonction,name_mmodd(%th),[],[],[],[],[]);  
        interpol(out,%fonction);
    elseif rhs==2 & exists('domain','local')
        [%np,%nt]=size(%th);
        %ind=~ones(%np,1);
        %ind2=~ones(%nt,1);
        for i=1:length(domain)
            %tmp=%th.TriId==domain(i)
            %ind(matrix(%th.Tri(%tmp,:),-1,1))=%t;
            %ind2=%ind2 | %tmp
        end
        out=mlist(['p1_2d';'#';'Id';'geo';'domain';'Node';'BoolNode';'BoolTri';'Time']..
        ,rand(),"",name_mmodd(%th),domain,[],%ind,%ind2,[]);
    else
        out=mlist(['p1_2d';'#';'Id';'geo';'domain';'Node';'BoolNode';'BoolTri';'Time']..
        ,rand(),%fonction,name_mmodd(%th),domain,[],[],[],[]);
        interpol(out,%fonction);
    end

    // Base Completion
    if %th.Det==[] | size(%th.Det,1)~=size(%th.Tri,1)
        %th.Det=det(%th);
        [nf,nt]=size(%th);

        if typeof(%th)=='tri2d'
            index=[2 3; 3 1; 1 2]';
            Tmp=zeros(nt,2);
            for i=1:3
                Tmp(:,1)=%th.Coor(%th.Tri(:,index(2,i)),2)-...
                %th.Coor(%th.Tri(:,index(1,i)),2);
                Tmp(:,2)=%th.Coor(%th.Tri(:,index(1,i)),1)-...
                %th.Coor(%th.Tri(:,index(2,i)),1); 
                %th.Shape_p1_Grad(i)=Tmp;
            end
        elseif  typeof(%th)=='tri3d'
            index=[2 3; 3 1; 1 2]';
            Tmp=zeros(nt,3);
            for i=1:3
            //(terme provenant du produit vectoriel v2^v3)
                c(:,1)=(%th.Coor(%th.Tri(:,index(2,i)),2)-%th.Coor(%th.Tri(:,index(1,i)),2))...
		                  .*(%th.Coor(%th.Tri(:,i),3)-%th.Coor(%th.Tri(:,index(2,i)),3))...
		       - (%th.Coor(%th.Tri(:,index(2,i)),3)-%th.Coor(%th.Tri(:,index(1,i)),3))...
		                  .*(%th.Coor(%th.Tri(:,i),2)-%th.Coor(%th.Tri(:,index(2,i)),2));
                c(:,2)=(%th.Coor(%th.Tri(:,index(2,i)),3)- %th.Coor(%th.Tri(:,index(1,i)),3))...
		                  .*(%th.Coor(%th.Tri(:,i),1)-%th.Coor(%th.Tri(:,index(2,i)),1))...
		       -(%th.Coor(%th.Tri(:,index(2,i)),1)-%th.Coor(%th.Tri(:,index(1,i)),1))...
		                  .*(%th.Coor(%th.Tri(:,i),3)-%th.Coor(%th.Tri(:,index(2,i)),3));
                c(:,3)=(%th.Coor(%th.Tri(:,index(2,i)),1)-%th.Coor(%th.Tri(:,index(1,i)),1))...
		                  .*(%th.Coor(%th.Tri(:,i),2)-%th.Coor(%th.Tri(:,index(2,i)),2))...
		       -(%th.Coor(%th.Tri(:,index(2,i)),2)-%th.Coor(%th.Tri(:,index(1,i)),2))...
		                  .*(%th.Coor(%th.Tri(:,i),1)-%th.Coor(%th.Tri(:,index(2,i)),1));
                
                Tmp(:,1)=c(:,3).*(%th.Coor(%th.Tri(:,index(1,i)),2)-%th.Coor(%th.Tri(:,i),2))-c(:,2)...
			          .*(%th.Coor(%th.Tri(:,index(1,i)),3)-%th.Coor(%th.Tri(:,i),3));
                Tmp(:,2)=c(:,1).*(%th.Coor(%th.Tri(:,index(1,i)),3)-%th.Coor(%th.Tri(:,i),3))-c(:,3)...
			          .*(%th.Coor(%th.Tri(:,index(1,i)),1)-%th.Coor(%th.Tri(:,i),1));
                Tmp(:,3)=c(:,2).*(%th.Coor(%th.Tri(:,index(1,i)),1)-%th.Coor(%th.Tri(:,i),1))-c(:,1)...
			          .*(%th.Coor(%th.Tri(:,index(1,i)),2)-%th.Coor(%th.Tri(:,i),2));
                Tmp=Tmp./%th.Det(:,[1,1,1])
		%th.Shape_p1_Grad(4-i+d(i))=Tmp;
            end
        end
        if lhs<=1
            execstr('['+name_mmodd(%th)+']=return(%th);');
        end
end
endfunction
