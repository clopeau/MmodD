c     LUTSOL.f 
c     +-----------------------------------------------------------------+
c     |  Fonction   :  RESOLUTION DU SYSTEME trans(LU)X=Y               |
c     |   La matrice LU est stockee dans (alu, jlu, ju)                 |
c     |   trans(LU) est la transposee de(LU)                            |
c     +-----------------------------------------------------------------+
c     |  Entrees    :                                                   |
c     |   n           : dimension du systeme                            |
c     |   y           : vecteur du second membre                        |
c     |  alu, jlu, ju : la matrice LU a ete assemblee dans ILU.f        |
c     |                                                                 |
c     |  Sorties    :                                                   |
c     |   x           : solution de transp(LU) x = y.                   |
c     |                                                                 |
c     +-----------------------------------------------------------------+
      SUBROUTINE lutsol(n,y,x,alu,jlu,ju) 
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
      do i=1,n
        x(i)=y(i)
      enddo
c     ----------------------------
c     Resolution Montee (avec U^T)
c     ----------------------------
      do i=1,n
        x(i)=x(i)*alu(i)
        do k=ju(i),jlu(i+1)-1
          x(jlu(k))=x(jlu(k))-alu(k)*x(i)
        enddo
      enddo
c     ------------------------------
c     Resolution Descente (avec U^T)
c     ------------------------------
      do i=n,1,-1 
	do k=jlu(i),ju(i)-1
          x(jlu(k))=x(jlu(k))-alu(k)*x(i)
        enddo
      enddo
c     +----------------------------------------------------------------+
c     +----------------------------------------------------------------+ 
      return
      end
