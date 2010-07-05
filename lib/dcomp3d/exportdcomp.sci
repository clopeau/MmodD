function exportdcomp(nomfich,th)
  u=file('open',nomfich,'unknown')

  // Coordonnees
  fprintf(u,'%i\n',size(th.Coor,1))
  fprintf(u,'%1.16E  %1.16E %1.16E\n',th.Coor);
  // faces
  nf=length(th.Face);
  fprintf(u,'%i\n',nf);

  frmat="%i";
  for i=1:nf
    fprintf(u,'%i\n',length(th.Face(i)));
    if length(th.Face(i))<105
      fprintf(u,strcat(frmat(ones(th.Face(i))),' ')+' %i\n',...
	  th.Face(i),th.Type(i));
    else
      bb=0:100:length(th.Face(i))
      for j=1:length(bb)-1
	fprintf(u,strcat(frmat(ones(bb(j)+1:bb(j+1))),' '),...
	    th.Face(i)(bb(j)+1:bb(j+1)));
      end
      fprintf(u,strcat(frmat(ones(bb($)+1:length(th.Face(i)))),' ')+' %i\n',...
	  th.Face(i)(bb($)+1:length(th.Face(i))),th.Type(i));
    end
  end
  
  np=length(th.Cell);
  fprintf(u,'%i\n',np);
  for i=1:np
    fprintf(u,'%i\n',length(th.Cell(i)))
    if length(th.Cell(i))<105
      fprintf(u,strcat(frmat(ones(th.Cell(i))),' ')+' %i\n',...
	  th.Cell(i),th.Mat(i));
    else
      bb=0:100:length(th.Cell(i))
      for j=1:length(bb)-1
	fprintf(u,strcat(frmat(ones(bb(j)+1:bb(j+1))),' '),...
	    th.Cell(i)(bb(j)+1:bb(j+1)));
      end
      fprintf(u,strcat(frmat(ones(bb($)+1:length(th.Cell(i)))),' ')+' %i\n',...
	  th.Cell(i)(bb($)+1:length(th.Cell(i))),th.Mat(i));
    end
  end

  file('close',u);


