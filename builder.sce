//By Dream Team: ****** Thierry Clopeau, Delanoue David, Marcel Ndeffo, Sofian Smatti ******

// This file is released into the public domain

mode(-1);
lines(0);

TOOLBOX_NAME  = "mmodd";
TOOLBOX_TITLE = "mmodd";
toolbox_dir = get_absolute_file_path("builder.sce");

// Check Scilab's version
// =============================================================================

try
	v = getversion("scilab");
catch
	error(gettext("Scilab 5.2 or more is required."));
end

if v(2) < 2 then
	// new API in scilab 5.2
	error(gettext('Scilab 5.2 or more is required.'));  
end

// Check development_tools module avaibility
// =============================================================================

if ~with_module('development_tools') then
  error(msprintf(gettext('%s module not installed."),'development_tools'));
end

// Action
// =============================================================================

exec(toolbox_dir+'\macros\buildmacros.sce');
//Tbx_builder_macros(toolbox_dir+'\macros\');
//tbx_builder_src(toolbox_dir);
//tbx_builder_gateway(toolbox_dir);
//tbx_builder_help(toolbox_dir);
tbx_build_loader(TOOLBOX_NAME, toolbox_dir);
tbx_build_cleaner(TOOLBOX_NAME, toolbox_dir);

// Clean variables
// =============================================================================

//clear toolbox_dir TOOLBOX_NAME TOOLBOX_TITLE;
