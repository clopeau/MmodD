function GMV(varargin)
[lhs,rhs]=argn(0);
arg=strcat('varargin('+string(1:rhs)+')',',')
filename='/tmp/test.inp';
execstr('exportGMV(filename,'+arg+')')
unix_g("gmv -i "+filename+" &")
endfunction

