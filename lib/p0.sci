function out=p0(%g,%fonc)
// construction d'une grille reguliere
// x,y [z] tableaux de points (ordre croissants)
// ou
// x,y z nombres de points en x,y,z

  [lhs,rhs]=argn(0);
  geo1d=['grid1d' 'line2d' 'line3d'];
  geo2d=['grid2d' 'tri2d' 'quad2d' 'tri3d'];
  geo3d=['grid3d' 'tet3d' 'hex3d'];
  var1d=['p1_1d'];
  var2d=['p1nc2d' 'p1_2d'];
  var3d=['p1nc3d' 'p1_3d'];
  
  if grep(geo1d,typeof(%g))~=[]
    if rhs==1
      out=p0_1d(%g);
    else
      out=p0_1d(%g,%fonc)
    end   
  elseif  grep(geo2d,typeof(%g))~=[]
    if rhs==1
      out=p0_2d(%g);
    else
      out=p0_2d(%g,%fonc)
    end
  elseif  grep(geo3d,typeof(%g))~=[]
    if rhs==1
      out=p0_3d(%g);
    else
      out=p0_3d(%g,%fonc)
    end
    //--- cas de transformation de variable -----
  elseif  grep(var1d,typeof(%g))~=[]
    out=evstr(typeof(%g)+'_to_p0_1d(%g)');
    
  elseif  grep(var2d,typeof(%g))~=[]
    out=evstr(typeof(%g)+'_to_p0_2d(%g)');
    
  elseif  grep(var3d,typeof(%g))~=[]
    out=evstr(typeof(%g)+'_to_p0_3d(%g)');
    
  else
    error('--- unknow type of geometry or variable !!! ----')
  end
endfunction

