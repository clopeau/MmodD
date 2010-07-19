mode(-1)
//SVDIR=pwd();
SVDIR=uigetfile('*.MESH');
if length(SVDIR)>0
  if isdef('th')==%f,
    th=square2d(2,2);
  end
  load(SVDIR,'th');
  disp(' --- Mesh loaded --- ');
else disp(' --- No Mesh Loaded ---');
end
//else 
  //disp(' --- No Mesh ---');
//end
//%Nomimport=uigetfile('*');
//
//if %Nomimport~=''
//  %nc=['Scilab Variable' ; 'BAMG' ; 'Tetra' ; 'TetraNC' ; 'NETGEN' ; 'VMESH' ; 'MESH'];
//  %n=x_choose(%nc,'Choose a Format','Cancel');
//  select %n
//  case 1
//    load(%Nomimport);
//  else
//    %nomvar=x_dialog('Chose a variable Name');
//    if %nomvar~=[]
//      ier=execstr(%nomvar+'=import'+%nc(%n)+'('''+%Nomimport+''')','errcatch');
//      if ier<>0 
//	disp('ERROR : Invalid File Format');
//      end
//    end
//    clear %nomvar
//  end
//  clear %n %nc
//end
//clear %Nomimport
//
//
//