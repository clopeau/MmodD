function A = ConvDy(%u,%c)
  execstr('A = ConvDy_'+typeof(%u)+'_'+typeof(%c)+'(%u,%c)');
endfunction
