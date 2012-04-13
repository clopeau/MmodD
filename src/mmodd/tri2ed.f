!     Copyright (C) 2012 - Thierry Clopeau
! 
!     This file must be used under the term of the CeCILL
!     http://www.cecill.info

      subroutine tri2ed(ntri,tri,ned,ed,tried,htsiz,ht,ed3)
!-------------------------------------------------------------------
!    indexation : edges from triangles
!
!------------------------------------------------------------------
      implicit none
!
      INTEGER prime,i,j,ind(3,2),htsiz
      INTEGER aa,bb,cc,k,ii
      INTEGER ntri,tri(ntri,3),ned,ed(3*ntri,2),tried(ntri,3)
      INTEGER ht(htsiz),ed3(3*ntri)
 !---- initialisation 
      do i=1,htsiz
         ht(i)=0
      enddo
      do i=1,3*ntri
         ed(i,1)=0
         ed(i,2)=0
      enddo
      do i=1,3*ntri
         ed3(i)=0
      end do
      
!--- indexation
      ind(1,1)=2
      ind(1,2)=3
      ind(2,1)=1
      ind(2,2)=3
      ind(3,1)=1
      ind(3,2)=2
!----- begin
      ned=0
      do 10 i=1,ntri
        do 20 j=1,3
           aa=tri(i,ind(j,1))
           bb=tri(i,ind(j,2))
           if (aa .gt. bb) then
              cc=aa
              aa=bb
              bb=cc
           endif
           k = abs(mod(aa*ntri + bb, htsiz))+1
           ii=ht(k)
           do 30 while (ii .gt. 0)
              if (ed(ii,1).eq.aa .and. ed(ii,2).eq.bb) then
                 tried(i,j)=ii
                 exit
              endif
              ii = ed3(ii)
 30        continue
           if (ii .eq. 0) then
              ned=ned+1
              ed(ned,1)=aa
              ed(ned,2)=bb
              ed3(ned)=ht(k)
              ht(k)=ned
              tried(i,j)=ned
           endif
 20     continue
 10   continue
       
      end 

   
