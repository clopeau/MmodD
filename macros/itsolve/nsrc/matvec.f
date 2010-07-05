c      MATVEC.f
c     +-----------------------------------------------------------------+
c     |  Fonction    : OPERATIONS BASIQUES MATRICES-VECTEURS            |
c     |          1. Produits matrices-vecteurs                          |
c     |          2. Solutions de systemes triangulaires                 |
c     |  Entrees     :                                                  |
c     |  Appels par  :                                                  |
c     |  Date        :                                                  |
c     +-----------------------------------------------------------------+
c     | 1) Produits matrices-vecteurs :                                 |  
c     |                                                                 |
c     | amux  : A times a vector. Compressed Sparse Row (CSR) format.   |      
c     | amuxms: A times a vector. Modified Compress Sparse Row format.  |      
c     | atmux : Transp(A) times a vector. CSR format.                   |      
c     | atmuxr: Transp(A) times a vector. CSR format. A rectangular.    |      
c     | amuxe : A times a vector. Ellpack/Itpack (ELL) format.          |      
c     | amuxd : A times a vector. Diagonal (DIA) format.                |      
c     | amuxj : A times a vector. Jagged Diagonal (JAD) format.         |      
c     | vbrmv : Sparse matrix-full vector product, in VBR format        | 
c     |                                                                 |
c     +-----------------------------------------------------------------+     
c     | 2) Solutions de systemes triangulaires :                        |  
c     |                                                                 |   
c     | lsol  :                                                         |
c     |   Unit Lower Triang. solve. Compressed Sparse Row (CSR) format. |
c     | ldsol :                                                         |
c     |   Lower Triang. solve.  Modified Sparse Row (MSR) format.       |
c     | lsolc :                                                         |
c     |   Unit Lower Triang. solve. Comp. Sparse Column (CSC) format.   |
c     | ldsolc:                                                         |
c     |   Lower Triang. solve. Modified Sparse Column (MSC) format.     |
c     | ldsoll:                                                         |
c     |   Lower Triang. solve with level scheduling. MSR format.        |
c     | usol  :                                                         |
c     |   Unit Upper Triang. solve. Compressed Sparse Row (CSR) format. |
c     | udsol :                                                         |             
c     |   Upper Triang. solve.  Modified Sparse Row (MSR) format.       |
c     | usolc :                                                         |             
c     |   Unit Upper Triang. solve. Comp. Sparse Column (CSC) format.   |
c     | udsolc:                                                         |             
c     |   Upper Triang. solve.  Modified Sparse Column (MSC) format.    |
c     +-----------------------------------------------------------------+ 
c
c
c  
c     +-----------------------------------------------------------------+
c     | 1)  PRODUITS MATRICES-VECTEURS                                  |
c     +-----------------------------------------------------------------+
c
c
c  
c     +-----------------------------------------------------------------+
c     |  Fonction    : A . v                                            |
c     |  La matrice A est stockee en format compressed sparse row.      |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |
c     | n     = row dimension of A                                      |
c     | x     = real array of length equal to the column dimension of   |
c     |         the A matrix.                                           |
c     | a, ja,                                                          |
c     |    ia = input matrix in compressed sparse row format.           |
c     |                                                                 |
c     | Sorties :                                                       |
c     | y     = real array of length n, containing the product y=Ax     |
c     |                                                                 |
c     +-----------------------------------------------------------------+
      SUBROUTINE amux(n,x,y,a,ja,ia) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      DOUBLE PRECISION  x(*), y(*), a(*) 
      INTEGER n, ja(*), ia(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      DOUBLE PRECISION t
      INTEGER i, k
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUX',1)
c     +----------------------------------------------------------------+
      do i=1,n
c       ------------------------------------------------
c       compute the inner product of row i with vector x
c       ------------------------------------------------
        t=0.0d0
        do k=ia(i),ia(i+1)-1 
          t=t+a(k)*x(ja(k))
        enddo
c       --------------------
c       store result in y(i) 
c       --------------------
        y(i)=t
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUX',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c
c     +-----------------------------------------------------------------+
c     |  Fonction    : A . v  en format MSR                             |
c     |  La matrice A est stockee en format compressed sparse row.      |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |
c     | n     = row dimension of A                                      |
c     | x     = real array of length equal to the column dimension of   |
c     |         the A matrix.                                           |
c     | a, ja = input matrix in compressed sparse row format.           |
c     |                                                                 |
c     | Sorties :                                                       |
c     | y     = real array of length n, containing the product y=Ax     |
c     |                                                                 |
c     +-----------------------------------------------------------------+
      SUBROUTINE amuxms(n,x,y,a,ja)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      DOUBLE PRECISION  x(*), y(*), a(*)
      INTEGER n, ja(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER i, k
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXMS',1)
c     +----------------------------------------------------------------+
      do i=1,n
        y(i)=a(i)*x(i)
      enddo
      do i=1,n
c       ------------------------------------------------
c       compute the inner product of row i with vector x
c       ------------------------------------------------
        do k=ja(i),ja(i+1)-1
          y(i)=y(i)+a(k)*x(ja(k))
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXMS',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c
c     +-----------------------------------------------------------------+
c     |  Fonction    : transp(A) . v  en format MSR                     |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |
c     | n     = row dimension of A                                      |
c     | x     = real array of length equal to the column dimension of   |
c     |         the A matrix.                                           |
c     | a, ja,                                                          |
c     |    ia = input matrix in compressed sparse row format.           |
c     |                                                                 |
c     | Sorties :                                                       |
c     | y     = real array of length n, containing the product          |
c     |                 y=transp(A).x                                   |
c     |                                                                 |
c     +-----------------------------------------------------------------+    
      SUBROUTINE atmux(n,x,y,a,ja,ia)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      DOUBLE PRECISION x(*), y(*), a(*) 
      INTEGER n, ia(*), ja(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER i, k 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('ATMUX',1)
c     +----------------------------------------------------------------+
c     ----------------------
c     zero out output vector
c     ----------------------
      do i=1,n
        y(i)=0.0
      enddo
c     ------------------
c     loop over the rows
c     ------------------
      do i=1,n
        do k=ia(i),ia(i+1)-1 
          y(ja(k))=y(ja(k))+x(i)*a(k)
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('ATMUX',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c
c     +-----------------------------------------------------------------+
c     |  Fonction    : transp(A) . v  en format MSR                     |
c     |          A peut-etre rectangulaire                              |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |
c     | m     = column dimension of A                                   |
c     | n     = row dimension of A                                      |
c     | x     = real array of length equal to the column dimension of   |
c     |         the A matrix.                                           |
c     | a, ja,                                                          |
c     |    ia = input matrix in compressed sparse row format.           |
c     |                                                                 |
c     | Sorties :                                                       |
c     | y     = real array of length n, containing the product          |
c     |                 y=transp(A).x                                   |
c     |                                                                 |
c     +-----------------------------------------------------------------+    
      SUBROUTINE atmuxr(m,n,x,y,a,ja,ia)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      DOUBLE PRECISION x(*), y(*), a(*) 
      INTEGER m, n, ia(*), ja(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER i, k 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('ATMUXR',1)
c     +----------------------------------------------------------------+
c     ----------------------
c     zero out output vector
c     ----------------------
      do i=1,m
        y(i)=0.0
      enddo
c     ------------------
c     loop over the rows
c     ------------------
      do i=1,n
        do k=ia(i),ia(i+1)-1 
          y(ja(k))=y(ja(k))+x(i)*a(k)
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('ATMUXR',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c
c     +-----------------------------------------------------------------+
c     |  Fonction    : A . v  en format Ellpack Itpack (ELL)            |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |
c     | n     = row dimension of A                                      |
c     | x     = real array of length equal to the column dimension of   |
c     |         the A matrix.                                           |
c     | na    = INTEGER. The first dimension of arrays a and ja         |
c     |         as declared by the calling program.                     |
c     | ncol  = INTEGER. The number of active columns in array a.       |
c     |         (i.e., the number of generalized diagonals in matrix.)  |
c     | a, ja = the real and INTEGER arrays of the itpack format        |
c     |         (a(i,k),k=1,ncol contains the elements of row i in      |
c     |         matrix ja(i,k),k=1,ncol contains their column numbers)  |
c     |                                                                 |
c     | Sorties :                                                       |
c     | y     = real array of length n, containing the product          |
c     |                 y=A.x                                           |
c     |                                                                 |
c     +-----------------------------------------------------------------+      
      SUBROUTINE amuxe(n,x,y,na,ncol,a,ja) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER  n, na, ncol, ja(na,*)
      DOUBLE PRECISION x(n), y(n), a(na,*)  
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER i, j 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXE',1)
c     +----------------------------------------------------------------+
      do i=1,n
        y(i)=0.0 
      enddo
      do j=1,ncol
        do i=1,n
          y(i)=y(i)+a(i,j)*x(ja(i,j))
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXE',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c
c     +-----------------------------------------------------------------+
c     |  Fonction    : A . v  en format Diagonal (DIA)                  |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |
c     | n     = row dimension of A                                      |
c     | x     = real array of length equal to the column dimension of   |
c     |         the A matrix.                                           | 
c     | ndiag  = INTEGER. The first dimension of array adiag as         | 
c     |          declared in the calling program.                       | 
c     | idiag  = INTEGER. The number of diagonals in the matrix.        | 
c     | diag   = real array containing the diagonals stored of A.       | 
c     | idiag  = number of diagonals in matrix.                         | 
c     | diag   = real array of size (ndiag x idiag) containing the      | 
c     |          diagonals                                              | 
c     | ioff   = INTEGER array of length idiag, containing the offsets  | 
c     |   	 of the diagonals of the matrix:                        | 
c     |          diag(i,k) contains the element a(i,i+ioff(k)) of the   |    
c     |          matrix.                                                | 
c     |                                                                 |                                              |
c     | Sorties :                                                       |
c     | y     = real array of length n, containing the product          |
c     |                 y=A.x                                           |
c     |                                                                 |
c     +-----------------------------------------------------------------+
      SUBROUTINE amuxd(n,x,y,diag,ndiag,idiag,ioff) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, ndiag, idiag, ioff(idiag) 
      DOUBLE PRECISION x(n), y(n), diag(ndiag,idiag)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER j, k, io, i1, i2 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXD',1)
c     +----------------------------------------------------------------+
      do j=1,n
        y(j)=0.0d0
      enddo 
c	
      do j=1,idiag
        io=ioff(j)
        i1=max0(1,1-io)
        i2=min0(n,n-io)
        do k=i1,i2	
          y(k)=y(k)+diag(k,j)*x(k+io)
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXD',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c
c     +-----------------------------------------------------------------+
c     |  Fonction    : A . v  en format Jagged-Diagonal (JAD)           |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |
c     | n     = row dimension of A                                      |
c     | x     = real array of length equal to the column dimension of   |
c     |         the A matrix.                                           | 
c     | jdiag  = INTEGER. The number of jadded-diagonals in the         | 
c     |         data-structure.                                         | 
c     | a      = real array containing the jadded diagonals of A stored | 
c     |          in succession (in decreasing lengths)                  | 
c     | j      = INTEGER array containing the colum indices of the      | 
c     |          corresponding elements in a.                           | 
c     | ia     = INTEGER array containing the lengths of the  jagged    | 
c     |          diagonals                                              | 
c     |                                                                 |                                              |
c     | Sorties :                                                       |
c     | y     = real array of length n, containing the product          |
c     |                 y=A.x                                           |
c     |                                                                 |
c     +-----------------------------------------------------------------+
      SUBROUTINE amuxj(n,x,y,jdiag,a,ja,ia)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jdiag, ja(*), ia(*)
      DOUBLE PRECISION x(n), y(n), a(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER i, ii, k1, len, j 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXJ',1)
c     +----------------------------------------------------------------+
      do i=1,n
        y(i)=0.0d0
      enddo
      do ii=1,jdiag
        k1 = ia(ii)-1
        len = ia(ii+1)-k1-1
        do j=1,len
          y(j)= y(j)+a(k1+j)*x(ja(k1+j)) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('AMUXJ',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c
c     +-----------------------------------------------------------------+
c     |  Fonction  : Sparse matrix-full vector product, in VBR format.  |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |
c     |  nr, nc  = number of block rows and columns in matrix A         |     
c     |  ia,ja,ka,a,kvstr,kvstc                                         |     
c     |          = matrix A in variable block row format                |     
c     |  x       = multiplier vector in full format                     |     
c     |                                                                 |                                              |
c     | Sorties :                                                       |     
c     |  b = product of matrix A times vector x in full format          |     
c     | Algorithm:                                                      |     
c     |                                                                 |
c     |  Perform multiplication by traversing a in order.               |
c     |                                                                 |  
c     +-----------------------------------------------------------------+
      SUBROUTINE vbrmv(nr,nc,ia,ja,ka,a,kvstr,kvstc,x,b)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER nr, nc, ia(nr+1), ja(*), ka(*), kvstr(nr+1), kvstc(*)
      DOUBLE PRECISION  a(*), x(*), b(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER n, i, j, ii, jj, k, istart, istop
      DOUBLE PRECISION  xjj
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('VBRMV',1)
c     +----------------------------------------------------------------+
      n=kvstc(nc+1)-1
      do i=1,n
        b(i)=0.0d0
      enddo
c
      k=1
      do i=1,nr
        istart=kvstr(i)
        istop=kvstr(i+1)-1
        do j=ia(i),ia(i+1)-1
          do jj =kvstc(ja(j)),kvstc(ja(j)+1)-1
            xjj=x(jj)
            do ii=istart,istop
              b(ii)=b(ii)+xjj*a(k)
              k=k+1
            enddo
          enddo
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('VBRMV',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c  
c     +-----------------------------------------------------------------+
c     | 2)  SOLUTIONS DE SYSTEMES TRIANGULAIRES                         |
c     +-----------------------------------------------------------------+
c
c
c 
c     +-----------------------------------------------------------------+
c     |  Fonction  : Resolution de Lx=y.                                |
c     |        L = lower unit triang.                                   |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |  
c     | n    = INTEGER. dimension of problem.                           |  
c     | y    = real array containg the right side.                      |  
c     |                                                                 |  
c     | al, jal,                                                        |  
c     | ial, = Lower triangular matrix stored in compressed sparse row  |  
c     |        format.                                                  |  
c     |                                                                 |                                              |
c     | Sorties :                                                       | 
c     |      x  = The solution of  L x  = y.                            | 
c     |                                                                 |  
c     +-----------------------------------------------------------------+
      SUBROUTINE lsol(n,x,y,al,jal,ial)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jal(*),ial(n+1) 
      DOUBLE PRECISION  x(n), y(n), al(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j 
      DOUBLE PRECISION  t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LSOL',1)
c     +----------------------------------------------------------------+
      x(1)=y(1) 
      do k=2,n
        t=y(k) 
        do j=ial(k),ial(k+1)-1
          t=t-al(j)*x(jal(j))
        enddo
        x(k)=t 
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LSOL',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c  
c     +-----------------------------------------------------------------+
c     |  Fonction  : Resolution de Lx=y.                                |
c     |        L = triangulaire en format MSR                           |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |  
c     | n    = INTEGER. dimension of problem.                           |  
c     | y    = real array containg the right hand side.                 |  
c     |                                                                 |  
c     | al, jal,                                                        |  
c     |      = Lower triangular matrix stored in Modified sparse row    |  
c     |        format.                                                  |  
c     |                                                                 |                                              |
c     | Sorties :                                                       | 
c     |      x  = The solution of  L x  = y.                            | 
c     |                                                                 |  
c     +-----------------------------------------------------------------+
      SUBROUTINE ldsol(n,x,y,al,jal) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jal(*) 
      DOUBLE PRECISION x(n), y(n), al(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j 
      DOUBLE PRECISION t 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LDSOL',1)
c     +----------------------------------------------------------------+
      x(1)=y(1)*al(1) 
      do k=2,n
        t=y(k) 
        do j=jal(k),jal(k+1)-1
          t=t-al(j)*x(jal(j))
        enddo
        x(k) = al(k)*t 
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LDSOL',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c  
c     +-----------------------------------------------------------------+
c     |  Fonction  : Resolution de Lx=y.                                |
c     |        L = unit lower trang. CSC format                         |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |  
c     | n    = INTEGER. dimension of problem.                           |  
c     | y    = DOUBLE PRECISION array containg the right side.          |  
c     |                                                                 |  
c     | al, jal,                                                        |  
c     | ial, = Lower triangular matrix stored in compressed sparse row  |  
c     |        format.                                                  |  
c     |                                                                 |                                              |
c     | Sorties :                                                       | 
c     |      x  = The solution of  L x  = y.                            | 
c     |                                                                 |  
c     +-----------------------------------------------------------------+
      SUBROUTINE lsolc(n,x,y,al,jal,ial)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jal(*),ial(*) 
      DOUBLE PRECISION  x(n), y(n), al(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j
      DOUBLE PRECISION t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LSOLC',1)
c     +----------------------------------------------------------------+
      do k=1,n
        x(k)=y(k) 
      enddo
      do k=1,n-1
        t=x(k) 
        do j=ial(k),ial(k+1)-1
          x(jal(j))=x(jal(j))-t*al(j) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LSOLC',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c  
c     +-----------------------------------------------------------------+
c     |  Fonction  : Resolution de Lx=y.                                |
c     |        L = nonunit Low. Triang. MSC format                      |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |  
c     | n    = INTEGER. dimension of problem.                           |  
c     | y    = DOUBLE PRECISION array containg the right side.          |  
c     |                                                                 |  
c     | al, jal,                                                        |  
c     | ial, = Lower triangular matrix stored in Modified sparse column |  
c     |        format.                                                  |  
c     |                                                                 |                                              |
c     | Sorties :                                                       | 
c     |      x  = The solution of  L x  = y.                            | 
c     |                                                                 |  
c     +-----------------------------------------------------------------+
      SUBROUTINE ldsolc(n,x,y,al,jal) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jal(*)
      DOUBLE PRECISION x(n), y(n), al(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j
      DOUBLE PRECISION t 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LDSOLC',1)
c     +----------------------------------------------------------------+
      do k=1,n
        x(k)=y(k) 
      enddo
      do k=1,n 
        x(k)=x(k)*al(k) 
        t=x(k) 
        do j=jal(k),jal(k+1)-1
          x(jal(j))=x(jal(j))-t*al(j) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LDSOLC',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c  
c     +-----------------------------------------------------------------+
c     |  Fonction  : Resolution de Lx=y.                                |
c     |        L =  triangular. Uses LEVEL SCHEDULING/MSR format        |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |  
c     | n    = INTEGER. dimension of problem.                           |  
c     | y    = DOUBLE PRECISION array containg the right hand side.     |  
c     |                                                                 | 
c     | al,                                                             | 
c     | jal, = Lower triangular matrix stored in Modified Sparse Row    | 
c     |        format.                                                  | 
c     | nlev = number of levels in matrix                               | 
c     | lev  = INTEGER array of length n, containing the permutation    | 
c     |        that defines the levels in the level scheduling ordering.| 
c     | ilev = pointer to beginning of levels in lev.                   | 
c     |        the numbers lev(i) to lev(i+1)-1 contain the row numbers | 
c     |        that belong to level number i, in the level shcheduling  | 
c     |        ordering.                                                |
c     |                                                                 | 
c     | Sorties :                                                       | 
c     |      x  = The solution of  L x  = y.                            | 
c     |                                                                 |  
c     +-----------------------------------------------------------------+
      SUBROUTINE ldsoll(n,x,y,al,jal,nlev,lev,ilev) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, nlev, jal(*), ilev(nlev+1), lev(n)
      DOUBLE PRECISION x(n), y(n), al(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER ii, jrow, i, k
      DOUBLE PRECISION t 
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('LDSOLL',1)
c     +----------------------------------------------------------------+
c     -----------------------------------------------------
c     outer loop goes through the levels. (SEQUENTIAL loop)
c     -----------------------------------------------------
      do ii=1,nlev
c       -------------------------------------------------------
c       next loop executes within the same level. PARALLEL loop
c       -------------------------------------------------------
        do i=ilev(ii),ilev(ii+1)-1 
          jrow=lev(i)
c         ----------------------------------------
c         compute inner product of row jrow with x
c         ----------------------------------------
          t=y(jrow) 
          do k=jal(jrow),jal(jrow+1)-1 
            t=t-al(k)*x(jal(k))
          enddo
          x(jrow)=t*al(jrow) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1)  CALL wdebg('LDSOLL',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c   
c     +-----------------------------------------------------------------+
c     |  Fonction  : Resolution de Ux=y.                                |
c     |        U = unit upper triangular.                               |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |  
c     | n    = INTEGER. dimension of problem.                           |  
c     | y    = DOUBLE PRECISION array containg the right hand side.     |  
c     |                                                                 | 
c     | au, jau,                                                        | 
c     | iau, = Lower triangular matrix stored in compressed sparse row  | 
c     |    format.                                                      | 
c     |                                                                 | 
c     | Sorties :                                                       | 
c     |      x  = The solution of  U x  = y.                            | 
c     |                                                                 |  
c     +-----------------------------------------------------------------+
      SUBROUTINE usol(n,x,y,au,jau,iau)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jau(*),iau(n+1) 
      DOUBLE PRECISION  x(n), y(n), au(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j 
      DOUBLE PRECISION  t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1)  CALL wdebg('USOL',1)
c     +----------------------------------------------------------------+
      x(n)=y(n) 
      do k=n-1,1,-1 
        t=y(k) 
        do j=iau(k),iau(k+1)-1
          t=t-au(j)*x(jau(j))
        enddo
        x(k)=t 
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('USOL',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c  
c     +-----------------------------------------------------------------+
c     |  Fonction  : Resolution de Ux=y.                                |
c     |        U = unit triangular in MSR format.                       |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |  
c     | n    = integer. dimension of problem.                           |  
c     | y    = real array containg the right side.                      |  
c     |                                                                 | 
c     | au, iau                                                         |
c     |      = Lower triangular matrix stored in compressed sparse row  | 
c     |    format.                                                      | 
c     |                                                                 | 
c     | Sorties :                                                       | 
c     |      x  = The solution of  U x  = y.                            | 
c     |                                                                 |  
c     +-----------------------------------------------------------------+
      SUBROUTINE udsol(n,x,y,au,jau) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER n, jau(*) 
      DOUBLE PRECISION  x(n), y(n),au(*) 
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j
      DOUBLE PRECISION t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('UDSOL',1)
c     +----------------------------------------------------------------+
      x(n)=y(n)*au(n)
      do k=n-1,1,-1
        t=y(k) 
        do j=jau(k),jau(k+1)-1
          t=t-au(j)*x(jau(j))
        enddo
        x(k)=au(k)*t 
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('UDSOL',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c 
c     +-----------------------------------------------------------------+
c     |  Fonction  : Resolution de Ux=y.                                |
c     |        U = unit upper trang. CSC format.                        |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |  
c     | n    = integer. dimension of problem.                           |  
c     | y    = real array containg the right side.                      |  
c     |                                                                 | 
c     | au, jau, iau                                                    |
c     |      = Upper triangular matrix stored in compressed sparse row  | 
c     |    format.                                                      | 
c     |                                                                 | 
c     | Sorties :                                                       | 
c     |      x  = The solution of  U x  = y.                            | 
c     |                                                                 |  
c     +-----------------------------------------------------------------+
      SUBROUTINE usolc(n,x,y,au,jau,iau)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      DOUBLE PRECISION  x(*), y(*), au(*) 
      INTEGER n, jau(*),iau(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j
      DOUBLE PRECISION t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('USOLC',1)
c     +----------------------------------------------------------------+
      do k=1,n
        x(k)=y(k) 
      enddo
      do k=n,1,-1
        t=x(k) 
        do j=iau(k),iau(k+1)-1
          x(jau(j))=x(jau(j))-t*au(j) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('USOLC',2)
c     +----------------------------------------------------------------+
      return
      end
c
c
c 
c     +-----------------------------------------------------------------+
c     |  Fonction  : Resolution de Ux=y.                                |
c     |        U = nonunit Up. Triang. MSC format                       |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     | Entrees :                                                       |  
c     | n    = integer. dimension of problem.                           |  
c     | y    = real array containg the right hand side.                 |  
c     |                                                                 | 
c     | au, jau, iau                                                    |
c     |      = Upper triangular matrix stored in Modified Sparse Column | 
c     |    format.                                                      | 
c     |                                                                 | 
c     | Sorties :                                                       | 
c     |      x  = The solution of  U x  = y.                            | 
c     |                                                                 |  
c     +-----------------------------------------------------------------+
      SUBROUTINE udsolc(n,x,y,au,jau) 
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------  
      INTEGER n, jau(*) 
      DOUBLE PRECISION x(n), y(n), au(*)  
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER k, j
      DOUBLE PRECISION t
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('UDSOLC',1)
c     +----------------------------------------------------------------+
      do k=1,n
        x(k)=y(k) 
      enddo
      do k=n,1,-1
        x(k)=x(k)*au(k) 
        t=x(k) 
        do j=jau(k),jau(k+1)-1
          x(jau(j))=x(jau(j))-t*au(j) 
        enddo
      enddo
c     +----------------------------------------------------------------+
c      IF (debug.eq.1) CALL wdebg('UDSOLC',2)
c     +----------------------------------------------------------------+
      return
      end
c
