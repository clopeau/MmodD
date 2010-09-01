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
  {(Myinterfun)sci_gateway_without_putlhsvar,intsplsolve,"c_splsolve"},
  {(Myinterfun)sci_gateway_without_putlhsvar,intspusolve,"c_spusolve"},
  {(Myinterfun)sci_gateway_without_putlhsvar,inttriangular,"c_triangular"},
  {(Myinterfun)sci_gateway_without_putlhsvar,intpgmres,"c_pgmres"},
  {(Myinterfun)sci_gateway_without_putlhsvar,intpgc,"c_pgc"},
  {(Myinterfun)sci_gateway_without_putlhsvar,intpbgc,"c_pbgc"},
  {(Myinterfun)sci_gateway_without_putlhsvar,intpdbgc,"c_pdbgc"},
  {(Myinterfun)sci_gateway_without_putlhsvar,intpgcnr,"c_pgcnr"},
  {(Myinterfun)sci_gateway_without_putlhsvar,intpbcgstab,"c_pbcgstab"},
  {(Myinterfun)sci_gateway_without_putlhsvar,intpqmr,"c_pqmr"},
};
 
int C2F(libitsolve_c)()
{
  Rhs = Max(0, Rhs);
  if (*(Tab[Fin-1].f) != NULL) 
  {
     pvApiCtx->pstName = (char*)Tab[Fin-1].name;
    (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);
  }
  return 0;
}
