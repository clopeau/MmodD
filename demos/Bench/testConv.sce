exec ../../loader.sce

stacksize(2e8)
err=[];
N=[];

for jj=1:4
  
  th=tsquare2d(10+30*jj,(10+30*jj))
  //th.BndId=['U' 'W' 'S' 'E' 'N' 'D'];
  [n]=size(th);
  u=p1(th);
  
  //exec pb3d_20.sce
  //exec pb3d_2k.sce;
  //exec pb2dCov_7.sce;
  exec pb2dCov_8.sce;
  //exec pb3d_11.sce
  
  uex=p1(th,sexacte);
  
  assemble(pb)
  nl=5;
  //[L,U,ier]=ilut(pb.A,nl,0);
  //deff('y=precond(x)','y=U\(L\ x)')
  //deff('y=precondp(x)','y=L''\(U''\ x)')
  //timer();tmp=bicgstab(pb.A,pb.b,zeros(pb.b));tps=timer()
  //timer();tmp=pbcgstab(pb.A,pb.b,zeros(pb.b),5000,1e-30,15,0.01);tps=timer()
  //u.Node=tmp;
  u.Node=pb.A\pb.b;
  
  N=[N , n]
  err=[err, (max(abs(uex-u)))];
  xbasc()
  plot2d('ll',N',err');
  plot2d('ll',N',err',-1)
  disp(err)
end
