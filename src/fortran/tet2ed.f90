program tet2ed
!-------------------------------------------------------------------
!    Programme d'indexation des tetraedres et des aretes
!
!------------------------------------------------------------------
  implicit none
!
  integer iii,u,ios,prime
  integer(kind=8) i,j,tmp(12),ind(2,6),ntet,ned,ncoor,htsiz
  integer(kind=8) aa,bb,cc,k,ii
  INTEGER(kind=8), ALLOCATABLE, DIMENSION(:,:):: tet
  INTEGER(kind=8), ALLOCATABLE, DIMENSION(:,:) :: ed
  INTEGER(kind=8), ALLOCATABLE, DIMENSION(:,:) :: teted
  INTEGER(kind=8), ALLOCATABLE, DIMENSION(:) :: ht

!  integer(kind=8) ht(999959)
! integer tet(5,17000000),face(5,999959),ht(999959),tetface(4,1700000)
  double precision coor(3)
  character arg*80,infich*80,outfich*80,charbuff*80
  integer nargs,iargc, nbtet
!
!  ecran = 0  

  nargs = iargc() 
  do iii = 1,nargs 
     call getarg( iii, arg ) 
     if ( lle(arg,'-i') .and. lge(arg,'-i') ) then 
        call getarg( iii+1, infich)
     end if
     if ( lle(arg,'-o') .and. lge(arg,'-o') ) then 
        call getarg( iii+1,outfich)
     end if
  end do
  
  u=11
  open(unit=u,file=infich,status='old',iostat=ios)
  
  read (u,*) ncoor,ntet,ned
! ---------- Allocation ------------------
  i=4
  ALLOCATE(tet(4,ntet))
  ALLOCATE(teted(6,ntet))
  ALLOCATE(ed(3,ned))

  do i=1,ntet
     read (u,*) (tet(j,i),j=1,4)
  end do

! passer à 5 ....
  read (u,*) ((ed(j,i),j=1,2),i=1,ned)
  close(u)

!--- mise en place de la hachtable
  htsiz = prime(ned+2)
  ALLOCATE(ht(0:htsiz-1))
  
  do i=0,htsiz-1
     ht(i)=0
  end do

  do i=1,ned
     aa=ed(1,i)
     bb=ed(2,i)
     k = mod(aa*ned + bb, htsiz)
     ed(3,i)=ht(k)
     ht(k) = i
  end do

  ind =reshape( (/ 1, 2, 1, 3, 1, 4, 2, 3, 2, 4, 3, 4 /) , (/ 2 , 6 /) )
   
  do i=1,ntet
     do j=1,6
        aa=tet(ind(1,j),i)
        bb=tet(ind(2,j),i)
        k = mod(aa*ned + bb, htsiz)
        ii=ht(k)
        if (ii == 0) then
            write ( *, 521) i,k
        end if
        do while (ii /= 0)
           if (ed(1,ii)==aa .and. ed(2,ii) == bb) then
              exit
           end if
           ii = ed(3,ii)
        end do
        teted(j,i)=ii
     end do
  end do

  u=10
 open(unit=u,file=outfich,status='unknown',form='formatted')
  do i=1,ntet
     write (u,*) (teted(j,i),j=1,6)
  end do
  close(u)


521 format (' Erreur tetraedre ',i9,' edge  ',i9) 
700 format (/(1x,4i7))

end program tet2ed

   
