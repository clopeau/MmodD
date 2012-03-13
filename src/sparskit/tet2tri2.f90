function tet2tri(tet)
!-------------------------------------------------------------------
!    Programme d'indexation des tetraedres et des faces
!    Modification pour rendre "nonconforme" un maillage de 
!    TETGEN
!------------------------------------------------------------------
  implicit none
!
  integer iii,u,ios,prime
  integer(kind=8) i,j,tmp(12),ind(3,4),nit,ntet,nf,ncoor,htsiz
  integer(kind=8) aa,bb,cc,k,ii,nnf
  INTEGER(kind=8), ALLOCATABLE, DIMENSION(:,:):: tet
  INTEGER(kind=8), ALLOCATABLE, DIMENSION(:,:) :: face
  INTEGER(kind=8), ALLOCATABLE, DIMENSION(:,:) :: tetface
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
  
  read (u,*) ntet,nf
  !write(*,*) ntet,nf
  
! ---------- Allocation ------------------
  i=5
  ALLOCATE(tet(i,ntet))
  ALLOCATE(tetface(i-1,ntet))
  ALLOCATE(face(i,8*ntet))

  do i=1,ntet
     read (u,*) (tet(j,i),j=1,4)
     !write(*,*) (tet(j,i),j=1,4)
  end do

! passer à 5 ....
  read (u,*) ((face(j,i),j=1,4),i=1,nf)
  !write(*,*) ((face(j,i),j=1,4),i=1,nf)
  close(u)

!--- mise en place de la hachtable
  htsiz = prime(4*ntet)
  ALLOCATE(ht(0:htsiz-1))
  
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
     !write(*,*) k
     face(5,i)=ht(k)
     ht(k) = i

  end do

  ind =reshape( (/ 2, 3, 4, 1, 3, 4, 1, 2, 4, 1, 2, 3 /) , (/ 3 , 4 /) )
  nnf=nf   
  do i=1,ntet
     do j=1,4
        aa=tet(ind(1,j),i)
        bb=tet(ind(2,j),i)
        cc=tet(ind(3,j),i)
        call order3(aa,bb,cc)
        !write(*,*) aa,bb,cc
        k = mod(aa*nf + bb, htsiz)
        k = mod(k*nf + cc, htsiz)
        !write(*,*) k,ht(k)
        ii=ht(k)
        if (ii == 0) then
           nnf=nnf+1
           !write(*,*) (nf)
           face(1,nnf) = aa
           face(2,nnf) = bb 
           face(3,nnf) = cc
           face(4,nnf) = 0
           face(5,nnf) = ht(k)
           ht(k)=nnf
           tetface(j,i)=nnf
        end if
        do while (ii /= 0)
           !write(*,*) (ii)
           if (face(1,ii)==aa .and. face(2,ii) == bb &
                .and. face(3,ii) == cc) then
              tetface(j,i)=ii
              ii=0
           else if (face(5,ii) == 0) then
              nnf=nnf+1
              face(1,nnf) = aa
              face(2,nnf) = bb 
              face(3,nnf) = cc
              face(4,nnf) = 0
              face(5,nnf) = ht(k)
              ht(k)=nnf
              !face(5,ii) = nf
              tetface(j,i)=nnf
              ii=0
              !write(*,*) (nf)
           else
              ii = face(5,ii)
           end if
           !write(*,*) ii
        end do
        !tetface(j,i)=ii
     end do
  end do

  u=10
 open(unit=u,file=outfich,status='unknown',form='formatted')
 write(u,*) ntet,nnf
  do i=1,ntet
     write (u,*) (tetface(j,i),j=1,4)
  end do
  do i=1,nnf
     write (u,*) (face(j,i),j=1,4)
  end do
  close(u)


521 format (' Erreur tetraedre ',i9,' face  ',i9) 
700 format (/(1x,4i7))

end function tet2tri

   
