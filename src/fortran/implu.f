c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c 
      subroutine implu(np,umm,beta,ypiv,u,permut,full)
      real*8 umm,beta,ypiv(*),u(*),x, xpiv
      logical full, perm, permut(*)
      integer np,k,npm1
c-----------------------------------------------------------------------
c     performs implicitly one step of the lu factorization of a
c     banded hessenberg matrix.
c-----------------------------------------------------------------------
      if (np .le. 1) goto 12
      npm1 = np - 1
c
c     -- perform  previous step of the factorization-
c
      do 6 k=1,npm1
         if (.not. permut(k)) goto 5
         x=u(k)
         u(k) = u(k+1)
         u(k+1) = x
 5       u(k+1) = u(k+1) - ypiv(k)*u(k)
 6    continue
c-----------------------------------------------------------------------
c     now determine pivotal information to be used in the next call
c-----------------------------------------------------------------------
 12   umm = u(np)
      perm = (beta .gt. abs(umm))
      if (.not. perm) goto 4
      xpiv = umm / beta
      u(np) = beta
      goto 8
 4    xpiv = beta/umm
 8    permut(np) = perm
      ypiv(np) = xpiv
      if (.not. full) return
c     shift everything up if full...
      do 7 k=1,npm1
         ypiv(k) = ypiv(k+1)
         permut(k) = permut(k+1)
 7    continue
      return
c-----end-of-implu
      end
