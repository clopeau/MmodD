function th=CheckPoint_tri2d(th)
// Erase additionnal point in a tri2d mesh
tmp=~zeros(1:size(th));
tmp(unique(th.Tri))=%f;
index=ones(1:size(th));
index(find(tmp))=0;
index=cumsum(index);
th.Tri=matrix(index(th.Tri),-1,3);
th.Coor(find(tmp),:)=[];
th.CoorId(find(tmp),:)=[];
for i=1:size(th.BndId,'*')
    th.Bnd(i)=index(th.Bnd(i))';
end
endfunction

