// Copyright (C) 2010 - Thierry Clopeau
// 
// This file must be used under the term of the CeCILL
// http://www.cecill.info 

Files_f=["prime.f" "tri2ed.f" "fastsparse.f']
functions_f=["prime" "tri2ed" "fastsparse"];
//for i=1:size(Files_f,1)
//  functions_f(i)=part(functions_f(i),1:length(functions_f(i))-2);
//end

tbx_build_src([functions_f], [Files_f], 'f', ..
              get_absolute_file_path('builder_mmodd.sce'),..
	      "","","","","","MmodD");

clear tbx_build_src;


