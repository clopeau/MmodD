!     Copyright (C) 2012 - Thierry Clopeau
! 
!     This file must be used under the term of the CeCILL
!     http://www.cecill.info

      subroutine fastsparse(nnz,nl,ij,a,pij,jout)
!-------------------------------------------------------------------
!     indexation : edges from triangles
!     
!------------------------------------------------------------------
      implicit none
!     
      INTEGER nnz,nl,i,j,ii,ii_old,ii_old2,itmp,jtmp,jref,newnnz,ierr
      INTEGER ij(nnz,2),pij(nnz),jout(nl)
      REAL*8 a(nnz)
!---- initialisation 
      ierr=0
      do i=1,nl
         jout(i)=0
      enddo
      do i=1,nnz
         pij(i)=0
      enddo
!-----begin
      newnnz=0
      do 10 i=1,nnz
         itmp=ij(i,1)
         ii=jout(itmp)
         if (ii.eq.0) then
            newnnz=newnnz+1
            jout(itmp)=i
         else
            jref=ij(i,2)
            jtmp=0
            ii_old2=0
            ii_old=0
            do 30 while ((ii .gt. 0).and.(jtmp.lt.jref))
               jtmp=ij(ii,2)
               ii_old2=ii_old
               ii_old=ii;
               ii=pij(ii);
 30         continue
            if (jtmp.eq.jref) then
               a(ii_old) = a(ii_old) + a(i)
            elseif ((ii_old2.eq.0).and.(jref.lt.jtmp)) then
               newnnz=newnnz+1
               pij(i)=ii_old
               jout(itmp)=i
            elseif (jref.lt.jtmp) then
               newnnz=newnnz+1
               pij(i)=ii_old
               pij(ii_old2)=i
            else 
               newnnz=newnnz+1
               pij(ii_old)=i
               pij(i)=ii
            endif
         endif
 10   continue
      nnz=newnnz
      end 

   
