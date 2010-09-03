c     RUNRC.f
c     +-----------------------------------------------------------------+
c     |  Fonction  : GESTION DES DIFFERENTS SOLVEURS POUR solv*=4       |
c     +-----------------------------------------------------------------+
c     |  Liste des variables :                                          |
c     |  Entrees   :                                                    |
c     |  Sorties   :                                                    |
c     |                                                                 |
c     +-----------------------------------------------------------------+ 
c     |  Appele par:                                                    |
c     |  Appelle   :                                                    |
c     |                                                                 |
c     |  Date      :                                                    |
c     +-----------------------------------------------------------------+
      SUBROUTINE runrc(n,rhs,sol,ipar,fpar,wk
     .                ,a,ja,ia,au,jau,ju
     .                ,methode,iout)
      IMPLICIT NONE
      INTEGER 
     .         n, ipar(16), ia(*), ja(*), ju(*)
     .      , jau(*), methode,iout
      DOUBLE PRECISION 
     .         fpar(16), rhs(*), sol(*)
     .       , wk(*), a(*), au(*)
c      DIMENSION au(2*lfil*mijkl),jau(2*lfil*mijkl)
c     ---------------------------------
c     DECLARATION DES VARIABLES LOCALES
c     ---------------------------------
      INTEGER 
     .         i, its
      DOUBLE PRECISION 
     .         res
c      SAVE 
c     .         its,res
 
      its=0
      res=0.0d0
      ipar(1)=0
 10   continue
c     ----------
c     METHODE CG
c     ----------
      if (methode.eq.1) then
        CALL cg(n,rhs,sol,ipar,fpar,wk)
        goto 1000
      endif
c     -----------
c     METHODE bCG
c     -----------
      if (methode.eq.2) then
        CALL bcg(n,rhs,sol,ipar,fpar,wk)
        goto 1000
      endif
c     ------------
c     METHODE dbCG
c     ------------
      if (methode.eq.3) then
        CALL dbcg(n,rhs,sol,ipar,fpar,wk)
        goto 1000
      endif
c     ------------
c     METHODE CGNR
c     ------------
      if (methode.eq.4) then
        CALL cgnr(n,rhs,sol,ipar,fpar,wk)
        goto 1000
      endif
c     -----------------
c     METHODE BI-CGStab
c     -----------------
      if (methode.eq.5) then
        CALL bcgstab(n,rhs,sol,ipar,fpar,wk)
        goto 1000
      endif
c     -------------
c     METHODE TFQMR
c     -------------
      if (methode.eq.6) then
        CALL tfqmr(n,rhs,sol,ipar,fpar,wk)
        goto 1000
      endif
c     -----------
c     METHODE FOM
c     -----------
      if (methode.eq.7) then
        CALL fom(n,rhs,sol,ipar,fpar,wk)
        goto 1000
      endif
c     -------------
c     METHODE GMRES
c     -------------
      if (methode.eq.8) then
        CALL gmres(n,rhs,sol,ipar,fpar,wk)
        goto 1000
      endif
c     --------------
c     METHODE FGMRES
c     --------------
      if (methode.eq.9) then
        CALL fgmres(n,rhs,sol,ipar,fpar,wk)
        goto 1000
      endif
c     ---------------
c     METHODE DQGMRES
c     ---------------
      if (methode.eq.10) then
        CALL dqgmres(n,rhs,sol,ipar,fpar,wk)
        goto 1000
      endif
c
 1000 continue
c
c     ----------------------------
c     SORTIE DES RESIDUS A L'ECRAN
c     ----------------------------
      if (ipar(7).ne.its) then
c         WRITE(iout,110) its, real(res)
         its=ipar(7)
      endif
      res=fpar(5)
c
      if (ipar(1).eq.1) then
        CALL amux(n,wk(ipar(8)),wk(ipar(9)),a,ja,ia)
        goto 10
c
      else if (ipar(1).eq.2) then
        CALL atmux(n,wk(ipar(8)),wk(ipar(9)),a,ja,ia)
        goto 10
c
      else if (ipar(1).eq.3 .or. ipar(1).eq.5) then
        CALL lusol(n,wk(ipar(8)),wk(ipar(9)),au,jau,ju)
	goto 10
c
      else if (ipar(1).eq.4 .or. ipar(1).eq.6) then
        CALL lutsol(n,wk(ipar(8)),wk(ipar(9)),au,jau,ju)
        goto 10
c
c      else if (ipar(1).le.0) then
c        if (ipar(1).eq.0) then
c           print *, 'Test de convergence satisfait par le solveur.'
c        else if (ipar(1).eq.-1) then
c           print *, 'Nombre d''iterations maximun atteint.'
c        else if (ipar(1).eq.-2) then
c           print *, 'Espace memoire insuffisant pour le solveur.'
c           print *, 'Espace memoire doit avoir au moins ', ipar(4)
c     .          , ' elements.'
c        else if (ipar(1).eq.-3) then
c           print *, 'Arret brutal du solveur iteratif.'
c        else
c           print *, 'Solveur iteratif termine. code =', ipar(1)
c        endif
      endif
c     
c     time=dtime(dt)
c
c        WRITE (*,110) ipar(7), real(fpar(6))
c        WRITE (*,*) '* Code renvoye =', ipar(1)
c     .              , ' Vitesse de convergence =', fpar(7)

      return
c 110  format(1x,i6,1x,e12.5)
      end


      
