function A = ConvDx(%u,%c)
  execstr('A = ConvDx_'+typeof(%u)+'_'+typeof(%c)+'(%u,%c)');
endfunction
