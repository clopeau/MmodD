function  [ind,ind1]=%grid1d_e(varargin)
// fonction d''extraction de grille
// les frontieres sont
// N,S,E,W(=O)
// ind  : ensembles d'indices concernés
// ind1 : ensembles d'indices adjacents aux premiers

   [lhs,rhs]=argn(0);
   G=varargin($);
   if rhs==2
     opt='node'
   else
     opt=varargin($-1);
   end
   opt=convstr(opt,'l');
   In=varargin(1);
   // Extraction de frontieres 
   
   opt=part(opt,1);
   In=convstr(In,'u');
   if In=='O'
     In='W';
   end
   select In
     case 'W'
       ind=1
     case 'E'
       ind=length(G.x)
     else
       ind=[]
     end
   	   
 endfunction
   
       
       
       
   
