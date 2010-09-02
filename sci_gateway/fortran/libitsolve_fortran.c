#include <mex.h> 
#include <sci_gateway.h>
#include <api_scilab.h>
static int direct_gateway(char *fname,void F(void)) { F();return 0;};
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
static GenericTable Tab[]={
  {(Myinterfun)sci_gateway,intsplsolve,"fortran_splsolve"},
  {(Myinterfun)sci_gateway,intspusolve,"fortran_spusolve"},
  {(Myinterfun)sci_gateway,inttriangular,"fortran_triangular"},
  {(Myinterfun)sci_gateway,intpgmres,"fortran_pgmres"},
  {(Myinterfun)sci_gateway,intpgc,"fortran_pgc"},
  {(Myinterfun)sci_gateway,intpbgc,"fortran_pbgc"},
  {(Myinterfun)sci_gateway,intpdbgc,"fortran_pdbgc"},
  {(Myinterfun)sci_gateway,intpgcnr,"fortran_pgcnr"},
  {(Myinterfun)sci_gateway,intpbcgstab,"fortran_pbcgstab"},
  {(Myinterfun)sci_gateway,intpqmr,"fortran_pqmr"},
};
 
int C2F(libitsolve_fortran)()
{
  Rhs = Max(0, Rhs);
  if (*(Tab[Fin-1].f) != NULL) 
  {
     pvApiCtx->pstName = (char*)Tab[Fin-1].name;
    (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);
  }
  return 0;
}
