;##############################################################################################################
; Script d'installation Inno Setup (5.2.2) pour scilab
; Clopeau Thierry, Delanoue David, Ndeffo Marcel & Smatti Sofian
; Version TRUNK
; This file is released into the public domain
;##############################################################################################################
;--------------------------------------------------------------------------------------------------------------
; MMODD_skeleton
;--------------------------------------------------------------------------------------------------------------
#define MMODD_SKELETON "MMODD_skeleton"
;
Source: contrib\{#MMODD_SKELETON}\builder.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\MMODD_skeleton_redist.iss; DestDir: {app}\contrib\{#MMODD_SKELETON}; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\changelog.txt; DestDir: {app}\contrib\{#MMODD_SKELETON}; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\license.txt; DestDir: {app}\contrib\{#MMODD_SKELETON}; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\readme.txt; DestDir: {app}\contrib\{#MMODD_SKELETON}; Components: {#COMPN_MMODD_SKELETON}
;
Source: contrib\{#MMODD_SKELETON}\demos\*.*; DestDir: {app}\contrib\{#MMODD_SKELETON}\demos; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\etc\MMODD_skeleton.quit; DestDir: {app}\contrib\{#MMODD_SKELETON}\etc; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\etc\MMODD_skeleton.start; DestDir: {app}\contrib\{#MMODD_SKELETON}\etc; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\help\builder_help.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\help; Components: {#COMPN_MMODD_SKELETON}

Source: contrib\{#MMODD_SKELETON}\help\en_US\build_help.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\help\en_US; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\help\en_US\*.xml; DestDir: {app}\contrib\{#MMODD_SKELETON}\help\en_US; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\help\fr_FR\build_help.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\help\fr_FR; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\help\fr_FR\*.xml; DestDir: {app}\contrib\{#MMODD_SKELETON}\help\fr_FR; Components: {#COMPN_MMODD_SKELETON}
;
;Source: contrib\{#MMODD_SKELETON}\includes\*.h; DestDir: {app}\contrib\{#MMODD_SKELETON}\includes
;Source: contrib\{#MMODD_SKELETON}\locales\*.*; DestDir: {app}\contrib\{#MMODD_SKELETON}\locales
;
Source: contrib\{#MMODD_SKELETON}\macros\buildmacros.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\macros; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\macros\*.sci; DestDir: {app}\contrib\{#MMODD_SKELETON}\macros; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\sci_gateway\builder_gateway.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\sci_gateway; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\sci_gateway\c\builder_gateway_c.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\sci_gateway\c; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\sci_gateway\c\sci_csum.c; DestDir: {app}\contrib\{#MMODD_SKELETON}\sci_gateway\c; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\sci_gateway\c\sci_csub.c; DestDir: {app}\contrib\{#MMODD_SKELETON}\sci_gateway\c; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\sci_gateway\cpp\sci_cpp_find.cxx; DestDir: {app}\contrib\{#MMODD_SKELETON}\sci_gateway\cpp; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\sci_gateway\cpp\builder_gateway_cpp.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\sci_gateway\cpp; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\sci_gateway\fortran\builder_gateway_fortran.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\sci_gateway\fortran; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\sci_gateway\fortran\sci_fsum.c; DestDir: {app}\contrib\{#MMODD_SKELETON}\sci_gateway\fortran; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\src\builder_src.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\src; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\src\c\builder_c.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\src\c; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\src\c\csum.c; DestDir: {app}\contrib\{#MMODD_SKELETON}\src\c; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\src\c\*.h; DestDir: {app}\contrib\{#MMODD_SKELETON}\src\c; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\src\c\csub.c; DestDir: {app}\contrib\{#MMODD_SKELETON}\src\c; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\src\fortran\builder_fortran.sce; DestDir: {app}\contrib\{#MMODD_SKELETON}\src\fortran; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\src\fortran\fsum.f; DestDir: {app}\contrib\{#MMODD_SKELETON}\src\fortran; Components: {#COMPN_MMODD_SKELETON}
Source: contrib\{#MMODD_SKELETON}\tests\*.*; DestDir: {app}\contrib\{#MMODD_SKELETON}\tests; Flags: recursesubdirs; Components: {#COMPN_MMODD_SKELETON}
;--------------------------------------------------------------------------------------------------------------
