#include <mex.h> 
extern Gatefunc intsplsolve;
extern Gatefunc intspusolve;
extern Gatefunc inttriangular;
extern Gatefunc intpgmres;
extern Gatefunc intpgc;
extern Gatefunc intpbgc;
extern Gatefunc intpdbgc;
extern Gatefunc intpgcnr;
extern Gatefunc intpbcgstab;
extern Gatefunc intpqmr;
extern Gatefunc intshurgmres;
extern Gatefunc intmshurgmres;



static GenericTable Tab[]={
  {(Myinterfun)sci_gateway,intsplsolve,"splsolve"},
  {(Myinterfun)sci_gateway,intspusolve,"spusolve"},
  {(Myinterfun)sci_gateway,inttriangular,"triangular"},
  {(Myinterfun)sci_gateway,intpgmres,"pgmres"},
  {(Myinterfun)sci_gateway,intpgc,"pgc"},
  {(Myinterfun)sci_gateway,intpbgc,"pbgc"},
  {(Myinterfun)sci_gateway,intpdbgc,"pdbgc"},
  {(Myinterfun)sci_gateway,intpgcnr,"pgcnr"},
  {(Myinterfun)sci_gateway,intpbcgstab,"pbcgstab"},
  {(Myinterfun)sci_gateway,intpqmr,"pqmr"},
  {(Myinterfun)sci_gateway,intshurgmres,"shurgmres"},
  {(Myinterfun)sci_gateway,intmshurgmres,"mshurgmres"},


};

int C2F(libscilin)()
{
  Rhs = Max(0, Rhs);
  (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);
  return 0;
}
