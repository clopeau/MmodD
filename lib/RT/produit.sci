function out=produit(x,y,z);
  // x y z tableau ligne
    out=x'*y;
    out=out(1:$)*z;
    out=out(1:$);
endfunction
