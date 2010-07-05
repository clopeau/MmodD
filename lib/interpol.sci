function interpol(%u,%fonction)
   %nomvar=name(%u);
   if type(%fonction)==10
     %fonction=strsubst(%fonction,' ','')
   end
   
   %u=evstr('interpol_'+typeof(%u)+'(%u,'''+%fonction+''')')
   //execstr('interpol_'+typeof(%u)+'('+name(%u)+','''+%fonction+''')');
   execstr('['+%nomvar+']=return(%u);');
endfunction
 
