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
