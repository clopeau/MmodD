c     LUSOL.f 
c     +-----------------------------------------------------------------+
c     |  Fonction   :  RESOLUTION DU SYSTEME (LU)X=Y                    |
c     |   La matrice LU est stockee dans (alu, jlu, ju)                 |
c     |                                                                 |
c     +-----------------------------------------------------------------+
c     |  Entrees    :                                                   |
c     |   n           : dimension du systeme                            |
c     |   y           : vecteur du second membre                        |
c     |  alu, jlu, ju : la matrice LU a ete assemblee dans ILU.f        |
c     |                                                                 |
c     |  Sorties    :                                                   |
c     |   x           : solution de LU x = y.                           |
c     |                                                                 |
c     +-----------------------------------------------------------------+
      SUBROUTINE lusol(n,y,x,alu,jlu,ju)
      IMPLICIT NONE
c     ---------------------------------------
c     DECLARATION DES VARIABLES DES ARGUMENTS
c     ---------------------------------------
      INTEGER 
     .         n, jlu(*), ju(*)
      DOUBLE PRECISION 
     .         x(n), y(n), alu(*)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER 
     .         i, k
c     +----------------------------------------------------------------+
c     +----------------------------------------------------------------+ 
c     -----------------
c     Resolution Montee
c     -----------------
      do i=1,n
        x(i)=y(i)
        do k=jlu(i),ju(i)-1
          x(i)=x(i)-alu(k)*x(jlu(k))
        enddo
      enddo
c     -------------------
c     Resolution Descente
c     -------------------
      do i=n,1,-1
	do k=ju(i),jlu(i+1)-1
          x(i)=x(i)-alu(k)*x(jlu(k))
   	enddo
        x(i)=alu(i)*x(i)
      enddo
c     +----------------------------------------------------------------+
c     +----------------------------------------------------------------+ 
      return
      end
