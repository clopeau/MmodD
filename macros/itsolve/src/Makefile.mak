!include ../../Path.incl
!include $(SCIDIR)/Makefile.incl.mak

# Names of the interfaces
INTERFACES = intilu0.obj \
intilut.obj \
intilutp.obj \
intiluk.obj \
intilud.obj \
intiludp.obj \
intmilu0.obj \
intsplsolve.obj \
intspusolve.obj \
inttriangular.obj \
intmminfo.obj \
intmmread.obj \
intmmwrite.obj \
intgen57pt.obj

# Others obj needed
OBJS =  $(INTERFACES) functns.obj genmat.obj ilut.obj conv.obj libscilin.obj sort.obj mmio.obj
LIBRARY = libscilin

!include $(SCIDIR1)\config\Makedll.incl 
