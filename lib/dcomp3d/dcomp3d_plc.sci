function dcomp3d_plc(filename,th)
   
  if grep(filename,'.poly')==[]
    filename=filename+'.poly';
  end

  u=file('open',filename,'unknown')
  //u=%io(2);

  // Coordonnees
  fprintf(u,'%i 3 0 0\n',size(th.Coor,1))
  fprintf(u,'%i %1.16E  %1.16E %1.16E\n',(1:size(th.Coor,1))',th.Coor);
  // faces
  nf=sum(th.Type<>0)
  //nf=length(th.Face);
  fprintf(u,'%i 1\n',nf);

  frmat="%i";
  for i=1:length(th.Face)
    if th.Type(i)<>0
      fprintf(u,'1 0 %i\n',th.Type(i));
      cc=string(length(th.Face(i)))+' ';
      if length(th.Face(i))<105
	fprintf(u,cc+strcat(frmat(ones(th.Face(i))),' ')+' %i\n',...
	    th.Face(i),th.Type(i));
      else
	bb=0:100:length(th.Face(i))
	for j=1:length(bb)-1
	  fprintf(u,cc+strcat(frmat(ones(bb(j)+1:bb(j+1))),' '),...
	      th.Face(i)(bb(j)+1:bb(j+1)));
	  cc=""
	end
	fprintf(u,cc+strcat(frmat(ones(bb($)+1:length(th.Face(i)))),' ')+...
	    ' %i\n',th.Face(i)(bb($)+1:length(th.Face(i))),th.Type(i));
      end
    end
  end
  
//  np=length(th.Cell);
//  fprintf(u,'%i\n',np);
//  for i=1:np
//    fprintf(u,'%i\n',length(th.Cell(i)))
//    if length(th.Cell(i))<105
//      fprintf(u,strcat(frmat(ones(th.Cell(i))),' ')+' %i\n',...
//          th.Cell(i),th.Mat(i));
//    else
//      bb=0:100:length(th.Cell(i))
//      for j=1:length(bb)-1
//        fprintf(u,strcat(frmat(ones(bb(j)+1:bb(j+1))),' '),...
//            th.Cell(i)(bb(j)+1:bb(j+1)));
//      end
//      fprintf(u,strcat(frmat(ones(bb($)+1:length(th.Cell(i)))),' ')+' %i\n',...
//          th.Cell(i)(bb($)+1:length(th.Cell(i))),th.Mat(i));
//    end
//  end
  fprintf(u,'0\n');
  fprintf(u,'0\n');
  file('close',u);

endfunction
