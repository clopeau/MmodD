SVDIR=pwd();

if isdef('th')==%t,
load(SVDIR+'/temp_var.MESH','th')
  disp(' --- Mesh loaded --- ');
else 
  disp(' --- No Mesh ---');
end
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