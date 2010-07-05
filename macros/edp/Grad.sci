function %out = Grad(%u)

  execstr('%out = Grad_'+typeof(%u)+'(%u)');

endfunction
