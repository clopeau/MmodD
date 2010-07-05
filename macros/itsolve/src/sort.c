static int inf_rl(int *I,int *J,int k,int i,int j);
static int inf_rc(int *I,int *J,int k,int i,int j);
static int pivot_patern(int *I,int *J,int n);
static int pivot_real(int *I,int *J,double *K,int n);
static int pivot_complex(int *I,int *J,double *K,double *L,int n);

extern void quick_sort_patern(int *I,int *J,int n)
{
  int p;
  
  if (n>1) {
    p=pivot_patern(I,J,n);
    quick_sort_patern(I,J,p);
    quick_sort_patern(I+p+1,J+p+1,n-p-1);
  }
}

static int pivot_patern(int *I,int *J,int n){
  int m=n/2; /* l'index du pivot */
  int Ipiv=I[m],Jpiv=J[m];
  int deb=1,fin=n-1;
  int Itmp,Jtmp;
  
  I[m]=I[0]; J[m]=J[0];
  I[0]=Ipiv; J[0]=Jpiv;
  
  while (deb<fin){
    while ((deb<fin)&&(inf_rl(I,J,deb,Ipiv,Jpiv)))
      deb++;
    while ((deb<fin)&&(!(inf_rl(I,J,fin,Ipiv,Jpiv))))
      fin--;
    if (deb<fin){
      Itmp=I[deb]; Jtmp=J[deb];
      I[deb]=I[fin]; J[deb]=J[fin];
      I[fin]=Itmp; J[fin]=Jtmp;
      deb++;
      fin--;
    }
  }
  
  if (inf_rl(I,J,deb,Ipiv,Jpiv)){
    I[0]=I[deb]; J[0]=J[deb];
    I[deb]=Ipiv; J[deb]=Jpiv;
  } else {
    if ((--deb)>0) {
      I[0]=I[deb]; J[0]=J[deb];
      I[deb]=Ipiv; J[deb]=Jpiv;
    }
  }
  return deb;
}

static int inf_rl(int *I,int *J,int k,int i,int j){
  /* retourne vrai si (I[k],J[k]) <=  (i,j) 
     dans l'ordre lexicographique */
  return ((I[k]<i)||((I[k]==i)&&(J[k]<=j)));
}

static int inf_rc(int *I,int *J,int k,int i,int j){
  /* retourne vrai si (J[k],I[k]) <=  (j,i) 
     dans l'ordre lexicographique */
  return ((J[k]<j)||((J[k]==j)&&(I[k]<=i)));
}

/* ------------------------------------------------ */
/*               Cas réel                           */
/*       marche aussi pour le cas entier            */
/* ------------------------------------------------ */

extern void quick_sort_real(int *I,int *J,double *K,int n)
{
  int p;
  
  if (n>1) {
    p=pivot_real(I,J,K,n);
    quick_sort_real(I,J,K,p);
    quick_sort_real(I+p+1,J+p+1,K+p+1,n-p-1);
  }
}

static int pivot_real(int *I,int *J,double *K,int n){
  int m=n/2; /* l'index du pivot */
  int Ipiv=I[m],Jpiv=J[m];
  double Kpiv=K[m];
  int deb=1,fin=n-1;
  int Itmp,Jtmp;
  double Ktmp;
  
  I[m]=I[0]; J[m]=J[0]; K[m]=K[0];
  I[0]=Ipiv; J[0]=Jpiv; K[0]=Kpiv;
  
  while (deb<fin){
    while ((deb<fin)&&(inf_rl(I,J,deb,Ipiv,Jpiv)))
      deb++;
    while ((deb<fin)&&(!(inf_rl(I,J,fin,Ipiv,Jpiv))))
      fin--;
    if (deb<fin){
      Itmp=I[deb]; Jtmp=J[deb]; Ktmp=K[deb];
      I[deb]=I[fin]; J[deb]=J[fin]; K[deb]=K[fin];
      I[fin]=Itmp; J[fin]=Jtmp; K[fin]=Ktmp;
      deb++;
      fin--;
    }
  }
  
  if (inf_rl(I,J,deb,Ipiv,Jpiv)){
    I[0]=I[deb]; J[0]=J[deb]; K[0]=K[deb];
    I[deb]=Ipiv; J[deb]=Jpiv; K[deb]=Kpiv;
  } else {
    if ((--deb)>0) {
      I[0]=I[deb]; J[0]=J[deb]; K[0]=K[deb];
      I[deb]=Ipiv; J[deb]=Jpiv; K[deb]=Kpiv;
    }
  }
  return deb;
}

/* ------------------------------------------------ */
/*               Cas complexe                       */
/* ------------------------------------------------ */

extern void quick_sort_complex(int *I,int *J,double *K,double *L,int n)
{
  int p;
  
  if (n>1) {
    p=pivot_complex(I,J,K,L,n);
    quick_sort_complex(I,J,K,L,p);
    quick_sort_complex(I+p+1,J+p+1,K+p+1,L+p+1,n-p-1);
  }
}

static int pivot_complex(int *I,int *J,double *K,double *L,int n){
  int m=n/2; /* l'index du pivot */
  int Ipiv=I[m],Jpiv=J[m];
  double Kpiv=K[m],Lpiv=L[m];
  int deb=1,fin=n-1;
  int Itmp,Jtmp;
  double Ktmp,Ltmp;
  
  I[m]=I[0]; J[m]=J[0]; K[m]=K[0]; L[m]=L[0];
  I[0]=Ipiv; J[0]=Jpiv; K[0]=Kpiv; L[0]=Lpiv;
  
  while (deb<fin){
    while ((deb<fin)&&(inf_rl(I,J,deb,Ipiv,Jpiv)))
      deb++;
    while ((deb<fin)&&(!(inf_rl(I,J,fin,Ipiv,Jpiv))))
      fin--;
    if (deb<fin){
      Itmp=I[deb]; Jtmp=J[deb]; Ktmp=K[deb]; Ltmp=L[deb];
      I[deb]=I[fin]; J[deb]=J[fin]; K[deb]=K[fin]; L[deb]=L[fin];
      I[fin]=Itmp; J[fin]=Jtmp; K[fin]=Ktmp; L[fin]=Ltmp;
      deb++;
      fin--;
    }
  }
  
  if (inf_rl(I,J,deb,Ipiv,Jpiv)){
    I[0]=I[deb]; J[0]=J[deb]; K[0]=K[deb]; L[0]=L[deb];
    I[deb]=Ipiv; J[deb]=Jpiv; K[deb]=Kpiv; L[deb]=Lpiv;
  } else {
    if ((--deb)>0) {
      I[0]=I[deb]; J[0]=J[deb]; K[0]=K[deb]; L[0]=L[deb];
      I[deb]=Ipiv; J[deb]=Jpiv; K[deb]=Kpiv; L[deb]=Lpiv;
    }
  }
  return deb;
}

















