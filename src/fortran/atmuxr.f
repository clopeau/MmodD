c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c

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
