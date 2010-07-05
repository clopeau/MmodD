include Path.incl
include $(SCIDIR)/Makefile.incl

CFLAGS = $(CC_OPTIONS) -fPIC -O3 -ffast-math -funroll-loops
FFLAGS = $(FC_OPTIONS)  -fPIC -O3 -ffast-math -funroll-loops

# names of the interfaces
INTERFACES = intspusolve.o intsplsolve.o \
	inttriangular.o intpgmres.o intpgc.o intpbgc.o intpdbgc.o \
	intpgcnr.o   intpbcgstab.o intpqmr.o intshurgmres.o \
	intmshurgmres.o

# other obj needed
OBJS =  $(INTERFACES) ilut.o iters.o matvec.o distdot.o \
	pgmres.o mpgmres.o runrc.o iluc.o piluc.o qqsort.o qsort.o\
	conv.o  libscilin.o ilucsol.o

LIBRARY = libscilin

include $(SCIDIR)/config/Makeso.incl

all ::
	ld -shared -o libscilin.so --whole-archive libscilin.a
	cp libscilin.so ..
#	$(RM) -r .libs
