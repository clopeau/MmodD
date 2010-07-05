function []=grid2d_show_rect(th)
// rect => fenetre de visualisation affiche les extremaux
  rect =[min(th);max(th)]';
  for i=1:2:3
    for j=2:2:4
      xstring(rect(i),rect(j),'('+string(rect(i))+','+string(rect(j))+')');
    end
  end
endfunction
