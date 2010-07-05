function A = Laplace(u)
execstr('A = Laplace_'+typeof(u)+'(u)');
//A = evstr('Laplace_'+typeof(u));
//execstr('Laplace_'+typeof(u));
endfunction