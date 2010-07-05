function y=%sp_det(A)
[hand,rk]=lufact(A);
[P,L,U,Q]=luget(hand);
y=prod(diag(L));
