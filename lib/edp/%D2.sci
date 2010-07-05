function A = %D2(x)
n = length(x)
h = x(2:n)-x(1:n-1)
l = [2:n-1;1:n-2]'
l1 = [2:n-1;2:n-1]'
l2 = [2:n-1;3:n]'
v = 2*(h(1:n-2).*(h(2:n-1)+h(1:n-2)))**(-1)
v1 = -2*(h(1:n-2).*h(2:n-1))**(-1)
v2 = 2*(h(2:n-1).*(h(2:n-1)+h(1:n-2)))**(-1)
A = sparse(l,v,[n,n]) + sparse(l1,v1,[n,n]) + sparse(l2,v2,[n,n])
endfunction