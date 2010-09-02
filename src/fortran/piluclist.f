      subroutine piluclist(n,k,jlu,jnext,Llist,Lfirst)
c-----------------------------------------------------------------------
      implicit none 
      integer n,k
      integer jlu(*),jnext(n),Llist(n),Lfirst(k)
c-----------------------------------------------------------------------
c     update linked lists of L 
c
c     n         size of the problem
c     k         current step of the update procedure
c     jlu       index array
c     jnext     pointers to the first space behind any column of L
c     Llist     linked list for the nonzeros of L in row k
c     Lfirst    first nonzero entry in L(i,k:n)

      integer i,j,l
      
c     position of the first nonzero entry L(i,k) in column k. Note
c     that L is stored by columns!
      i=Llist(k)
c     while i>0
 10      if (i.le.0) goto 20

c        does there exist an entry in L(i,k:n)?
         Lfirst(i)=Lfirst(i)+1
         l=Lfirst(i)
c        are there nonzeros leftover?
         if (l.lt.jnext(i)) then
            j=jlu(l)
c           save the old successor of i
            l=Llist(i)
c           add i to the linked list of row j
            Llist(i)=Llist(j)
            Llist(j)=i
c           restore the old successor
            i=l
         else
            i=Llist(i)
         end if
      goto 10
c     end while

 20   return
c----------------end-of-piluclist---------------------------------------
c-----------------------------------------------------------------------
      end
