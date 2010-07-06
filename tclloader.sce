mode(-1);
TCLDIR=get_absolute_file_path('tclloader.sce')

if ~MSDOS then
  TCL=TCLDIR+'tcl '
else 
  TCL='{'+getshortpathname(TCLDIR+'tcl ')+'}'
end
   
// Append the tcl directory to tcl search path
TCL_EvalStr('lappend auto_path ' + TCL)

write(%io(2),'Tcl procedures for tkgui loaded.') 

clear TCLDIR TCL  get_absolute_file_path
