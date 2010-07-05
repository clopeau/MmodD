function dcomp3d_plot(th,G)

mmax=max(th.Coor,'r');mmax=mmax+0.1*abs(mmax)
mmin=min(th.Coor,'r');mmin=mmin-0.1*abs(mmax)
z=zeros(3,1)

plot3d(z,z,z,flag=[0 3 4],ebox=matrix([mmin ; mmax],1,-1))

for i=1:length(th.Face)
  ind=abs(th.Face(i));
  ind($+1)=ind(1);
  param3d(th.Coor(ind,1),th.Coor(ind,2),th.Coor(ind,3),flag=[0 0]);
end

endfunction

