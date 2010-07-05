#include <mex.h> 
extern Gatefunc intsplsolve;
extern Gatefunc intspusolve;
extern Gatefunc inttriangular;
extern Gatefunc intpgmres;
extern Gatefunc intpgc;

static GenericTable Tab[]={
  {(Myinterfun)sci_gateway,intsplsolve,"splsolve"},
  {(Myinterfun)sci_gateway,intspusolve,"spusolve"},
  {(Myinterfun)sci_gateway,inttriangular,"triangular"},
  {(Myinterfun)sci_gateway,intpgmres,"pgmres"},
  {(Myinterfun)sci_gateway,intpgc,"pgc"},
};

int C2F(libscilin)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);
  return 0;
}
