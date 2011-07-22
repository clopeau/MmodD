function th=CheckPoint_tet3d(th)
// Erase additionnal point in a tri2d mesh
tmp=~zeros(1:size(th));
tmp(unique(th.Tet))=%f;
index=ones(1:size(th));
index(find(tmp))=0;
index=cumsum(index);
th.Tet=matrix(index(th.Tet),-1,4);
th.Coor(find(tmp),:)=[];
th.CoorId(find(tmp),:)=[];
for i=1:size(th.BndId,'*')
    th.Bnd(i)=index(th.Bnd(i))';
end
endfunction

