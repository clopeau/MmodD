function = tk_fenetre(arg)
  titre=arg 
  TCL_EvalStr("toplevel ."+titre);

// creates a toplevel TK window. 
 TCL_EvalStr("entry ."+titre+".e -textvariable tvar");

// create an editable entry
 TCL_EvalStr("set tvar foobar");

 // set the entry value
 TCL_EvalStr("pack .+"+titre+".e");
 
 // pack the entry widget. It appears on the screen.
 text=TCL_GetVar("tvar")
 
endfunction
