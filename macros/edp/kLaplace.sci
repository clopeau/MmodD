function A = kLaplace(%kk,%u)
  execstr('A = kLaplace_'+typeof(%u)+'(%kk,%u)');
//A = evstr('Laplace_'+typeof(u));
//execstr('Laplace_'+typeof(u));
endfunction
