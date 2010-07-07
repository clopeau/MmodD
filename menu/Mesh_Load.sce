%Nomimport=xgetfile('*');

if %Nomimport~=''
  %nc=['Scilab Variable' ; 'BAMG' ; 'Tetra' ; 'TetraNC' ; 'NETGEN' ; 'VMESH' ; 'MESH'];
  %n=x_choose(%nc,'Choose a Format','Cancel');
  select %n
  case 1
    load(%Nomimport);
  else
    %nomvar=x_dialog('Chose a variable Name');
    if %nomvar~=[]
      ier=execstr(%nomvar+'=import'+%nc(%n)+'('''+%Nomimport+''')','errcatch');
      if ier<>0 
	disp('ERROR : Invalid File Format');
      end
    end
    clear %nomvar
  end
  clear %n %nc
end
clear %Nomimport
