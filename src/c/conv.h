#include "stack-c.h"

extern int *Sci2spk(SciSparse *A);
extern void Spk2sci(SciSparse *A);
extern SciSparse *NewSpk(int *it, int *n, int *m, int *nel);
extern int lband(SciSparse A);
extern double eltm(SciSparse A);
extern int spluget(int n,int *ju,int *jlu,double *alu, SciSparse **L,SciSparse **U);
