// first create the GUI panel
  figw=220; figh=160;
  close(1)
  figure(1,"position",[0 0 figw figh]);
//PUSH TO STOP
  hstop=uicontrol(1,"style","pushbutton", "Min",0,"Max",1,"string"," STOP",..
             "position",[10 10 50 50],"callback","infiniteloop=%F");
// TRIGGERED MODE
  htrig=uicontrol(1,"style","radiobutton","Min",0,"Max",1,"value",0,..
                   "position",[80 10 20 20]);
  httrig=uititle(htrig,"free/trig","r")
 // BINNING x2
  hbin=uicontrol(1,"style","radiobutton","Min",0,"Max",1,"value",0,..
                    "position",[80 40 20 20]);
  htbin=uititle(hbin,"bin x2","r")
 // GREYSCALE
  hbri=uicontrol("style","slider","Min",1,"Max",255,"value",128,..
                  "position",[10 70 200 20]);
  htbri=uititle(hbri,"greyscale")
// EXPOSURE (only for untriggered)
   hexp=uicontrol("style","slider","Min",1,"Max",1200,"value",40,..
                  "position",[10 120 200 20]);
   htexp=uititle(hexp,"exposure time")

