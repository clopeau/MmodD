// Copyright (C) 2011 - Thierry Clopeau
//
// This file must be used under the terms of the CeCILL.
// This source file is licensed as described in the file COPYING, which
// you should have received as part of this distribution. The terms
// are also available at
// http://www.cecill.info/licences/Licence_CeCILL_V2-en.txt
demopath = get_absolute_file_path("inprogress.sce");
logo ="<html>"+..
      "<img src=""file:///"+demopath+"/MmodD.png"" />"+..
      "</html>";

in_progress=figure(10000);
in_progress.axes_size=[450 270] 
delmenu(in_progress.figure_id, gettext("&File"));
delmenu(in_progress.figure_id, gettext("&Tools"));
delmenu(in_progress.figure_id, gettext("&Edit"));
delmenu(in_progress.figure_id, gettext("&?"));
toolbar(in_progress.figure_id, "off");
h = uimenu( "parent", in_progress,          ..
    "label" , gettext("File"));
        
uimenu( "parent"    , h,                 ..
    "label"     , gettext("Close"),  ..
    "callback"  , "demo_fig=get_figure_handle(10000);delete(demo_fig);", ..
    "tag"       , "close_menu");

my_text = uicontrol( ...
    "parent"              , in_progress,...
    "style"               , "text",...
    "string"              , logo,...
    "units"               , "pixels",...
    "position"            , [ 20 0  410 230],...
    "background"          , [1 1 1], ...
    "tag"                 , "my_text", ...
    "horizontalalignment" , "center", ...
    "verticalalignment"   , "middle" ...
    );

xtitle("Work in progress...")


