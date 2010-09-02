
Files_f=findfiles(get_absolute_file_path('builder_fortran.sce'),'*.f');


Files_f=["amuxd.f";"uppdir.f"
"amuxe.f"
"amux.f"
"amuxj.f"
"amuxms.f"
"atmuxr.f"
"atmux.f"
"implu.f"
"mgsro.f"
"stopbis.f"
"distdot.f"
"qqsort.f"
"qsort2.f"
"qsplit.f"
"givens.f"
"tidycg.f"
"bcg.f"
"bcgstab.f"
"bisinit.f"
"brkdn.f"
"vbrmv.f"
"cg.f"
"cgnr.f"
"dbcg.f"
"dqgmres.f"
"fgmres.f"
"fom.f"
"gmres.f"
"ilu0.f"
"iluclist.f"
"ilucupdate.f"
"silucupdate.f"
"ilucsol.f"
"iluc.f"
"ilud.f"
"iludp.f"
"iluk.f"
"ilut.f"
"ilutp.f"
"ldsolc.f"
"ldsol.f"
"ldsoll.f"
"lsolc.f"
"lsol.f"
"lusol.f"
"lutsol.f"
"milu0.f"
"mpgmres.f"
"pgmres.f"
"pilucdusol.f"
"piluclist.f"
"piluclsol.f"
"pilucsol.f"
"pilucupdate.f"
"piluc.f"
"tfqmr.f"
"udsolc.f"
"udsol.f"
"usolc.f"
"usol.f"
"runrc.f"];

oldF=Files_f;
Files_f=Files_f(toto);
functions_f=Files_f;
for i=1:size(Files_f,1)
  functions_f(i)=part(functions_f(i),1:length(functions_f(i))-2);
end

//functions_f=['ilucsol','distdot','qsort2','qqsort','runrc'];
//functions_f=['runrc','cg','bcg'];
//les fonctions qui ne marchent pas
//'mpgmres','pilucdusol','piluc','qsplit','runrc','lutsol'
//Files_f=functions_f+'.f';
tbx_build_src([functions_f], [Files_f], 'f', ..
              get_absolute_file_path('builder_fortran.sce'));
//tbx_build_src(['ilut'], ['ilut.f','ilut.h'], 'f',get_absolute_file_path('builder_fortran.sce'));

clear tbx_build_src;


