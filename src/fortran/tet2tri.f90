program tet2tri
!-------------------------------------------------------------------
!    Programme d'indexation des tetraedres et des faces
!
!------------------------------------------------------------------
  implicit none
!
  integer i,j,u,prime,tmp(12),ind(3,4),ios,nit,ntet,nf,ncoor,htsiz
  integer aa,bb,cc,k,ii
  integer tet(5,1000000),face(5,999959),ht(999959),tetface(4,1000000)
  double precision coor(3)
  character arg*80,infich*80,outfich*80,charbuff*80
  integer nargs,iargc, nbtet
!
!  ecran = 0
  nargs = iargc() 
  do i = 1,nargs 
     call getarg( i, arg ) 
     if ( lle(arg,'-i') .and. lge(arg,'-i') ) then 
        call getarg( i+1, infich)
     end if
     if ( lle(arg,'-o') .and. lge(arg,'-o') ) then 
        call getarg( i+1,outfich)
     end if
  end do
  
  u=11
  open(unit=u,file=infich,status='old',iostat=ios)
  
  read (u,*) ncoor,ntet,nf,nit
  nf=nf+nit
  do i=1,ncoor
     read (u,*) (coor(i),j=1,3)
  end do

  read (u,*) ((tet(j,i),j=1,5),i=1,ntet)
! passer à 5 ....
  read (u,*) ((face(j,i),j=1,4),i=1,nf)

  close(u)

!--- mise en place de la hachtable
  htsiz = prime(nf+2)
  do i=0,htsiz-1
     ht(i)=0
  end do
  do i=1,nf
     aa=face(1,i)
     bb=face(2,i)
     cc=face(3,i)
     call order3(aa,bb,cc)
     face(1,i)=aa
     face(2,i)=bb
     face(3,i)=cc
     k = mod(aa*nf + bb, htsiz)
     k = mod(k*nf + cc, htsiz)
     face(5,i)=ht(k)
     ht(k) = i
  end do

  ind =reshape( (/ 2, 3, 4, 1, 3, 4, 1, 2, 4, 1, 2, 3 /) , (/ 3 , 4 /) )
   
  do i=1,ntet
     do j=1,4
        aa=tet(ind(1,j),i)
        bb=tet(ind(2,j),i)
        cc=tet(ind(3,j),i)
        call order3(aa,bb,cc)
        k = mod(aa*nf + bb, htsiz)
        k = mod(k*nf + cc, htsiz)
        ii=ht(k)
        if (ii == 0) then
            write ( *, 521) i,k
        end if
        do while (ii /= 0)
           if (face(1,ii)==aa .and. face(2,ii) == bb &
                .and. face(3,ii) == cc) then
              exit
           end if
           ii = face(5,ii)
        end do
        tetface(j,i)=ii
     end do
  end do

  u=10
 open(unit=u,file=outfich,status='unknown',form='formatted')
  do i=1,ntet
     write (u,*) (tetface(j,i),j=1,4)
  end do
  close(u)


521 format (' Erreur tetraedre ',i9,' face  ',i9) 
700 format (/(1x,4i7))

end program tet2tri

   
