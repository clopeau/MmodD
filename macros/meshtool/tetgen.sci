function th=tetgen(th,vol)
   [lhs,rhs]=argn(0)

   if rhs==1
     vol=0;
   end
  
   if typeof(th)=='dcomp3d'
     dcomp3d_plc('geom',th);
     if vol >0
       unix(%execu+'/tetgen -AApfqa'+string(vol)+' geom > /dev/null');
     else
       unix(%execu+'/tetgen -AApfq geom > /dev/null');
     end
     th=importTETGEN('geom.1');
   elseif typeof(th)=='tet3d'
     exportTetgen('geom',th);
     fronti=th.BndId;
     if vol >0
       unix_g(%execu+'tetgen -AArfa'+string(vol)+' geom > /dev/null');
     else
       unix_g(%execu+'tetgen -AArf geom > /dev/null');
     end
     th=importTetgen('geom.1');
     th.BndId=fronti
   else
     write(%io(2),'Bad input Format From TETGEN')
     return
   end
   
 
endfunction
 
