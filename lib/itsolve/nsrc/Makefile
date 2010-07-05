include /usr/lib/scilab-3.0/Path.incl
include $(SCIDIR)/Makefile.incl

CFLAGS = $(CC_OPTIONS) -fPIC
FFLAGS = $(FC_OPTIONS)  -fPIC

# names of the interfaces
INTERFACES = intpgmres.o intpgc.o

# other obj needed
OBJS =  $(INTERFACES) ilut.o iters.o matvec.o distdot.o \
	pgmres.o runrc.o \
	conv.o intspusolve.o intsplsolve.o \
	inttriangular.o libscilin.o 

LIBRARY = libscilin

include $(SCIDIR)/config/Makeso.incl

all ::
	ld -shared -o libscilin.so --whole-archive libscilin.a
#	cp libscilin.so ..
#	$(RM) -r .libs
