function spy(S)
[nargout,nargin] = argn(0)
//SPY Visualize sparsity pattern.
//   SPY(S) plots the sparsity pattern of the matrix S.
// S. STEER

if S==[] then S=0,end
[m,n] = size(S);
stx=max(1,10^(int(log10(m))))
[ij,v,mn]=spget(S);
rect=[0 0 m+1 n+1]

xbasc();plot2d(0,0,-1,'051',' ',rect,[1 m+1,1 n+1])
plot2d(ij(:,1),m-ij(:,2)+1,-1,'000')
xtitle('nz = '+string(length(v)),' ',' ');

endfunction

