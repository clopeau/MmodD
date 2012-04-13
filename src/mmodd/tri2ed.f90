subroutine tri2ed(ntri,tri,ned,ed,tried)
  !-------------------------------------------------------------------
  !    indexation : edges from triangles
  !
  !------------------------------------------------------------------
  implicit none
  !
  INTEGER(kind=4) iii,prime
  INTEGER(kind=4) i,j,ind(2,3),htsiz
  INTEGER(kind=4) aa,bb,cc,k,ii
  INTEGER(kind=4), INTENT(in):: ntri
  INTEGER(kind=4), DIMENSION(1:ntri,1:3), INTENT(in):: tri
  INTEGER(kind=4), INTENT(out) ::ned
  INTEGER(kind=4), DIMENSION(1:3*ntri,1:2), INTENT(OUT) :: ed
  INTEGER(kind=4), DIMENSION(1:ntri,1:3),INTENT(OUT) :: tried
  INTEGER(kind=4), ALLOCATABLE :: ht(:)
  INTEGER(kind=4), ALLOCATABLE :: ed3(:)
 
  !--- hachtable
  htsiz = prime(ntri)
  ALLOCATE(ht(0:htsiz-1))
  do i=0,htsiz-1
     ht(i)=0
  end do

 
!---- inutile mais ...
  do i=1,3*ntri
     ed(i,1)=0
     ed(i,2)=0
  end do

  ALLOCATE(ed3(1:3*ntri))
  do i=1,3*ntri
    ed3(i)=0
  end do
  
  !--- indexation
  ind =reshape( (/ 2, 3, 1, 3, 1, 2 /) , (/ 2 , 3 /) )
  
  ned=0
  do j=1,3
     do i=1,ntri
        aa=tri(i,ind(1,j))
        bb=tri(i,ind(2,j))
        if (aa .gt. bb) then
           cc=aa
           aa=bb
           bb=cc
        end if
        k = modulo(aa*ntri + bb, htsiz)
        ii=ht(k)
        do while (ii /= 0)
           if (ed(ii,1)==aa .and. ed(ii,2)==bb) then
              tried(i,j)=ii
              exit
           end if
           ii = ed3(ii)
        end do
        if (ii == 0) then
           ned=ned+1
           ed(ned,1)=aa
           ed(ned,2)=bb
           ed3(ned)=ht(k)
           ht(k)=ned
           tried(i,j)=ned
        end if
       
     end do
  end do
  
  DEALLOCATE(ht)
  DEALLOCATE(ed3)
  
end subroutine tri2ed

   
