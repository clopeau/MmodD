#include <mex.h> 
#include <sci_gateway.h>
#include <api_scilab.h>
#include <MALLOC.h>
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
 
int C2F(itsolve_fortran)()
{
  Rhs = Max(0, Rhs);
  if (*(Tab[Fin-1].f) != NULL) 
  {
     if(pvApiCtx == NULL)
     {
       pvApiCtx = (StrCtx*)MALLOC(sizeof(StrCtx));
     }
     pvApiCtx->pstName = (char*)Tab[Fin-1].name;
    (*(Tab[Fin-1].f))(Tab[Fin-1].name,Tab[Fin-1].F);
  }
  return 0;
}
