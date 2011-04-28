c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c 
      subroutine silucupdate(n,k,alu,jlu,lnext,unext,Llist,Lfirst,      
     +                       Ufirst,jw,len,w)
c-----------------------------------------------------------------------
      implicit none 
      integer n,k,len
      integer jlu(*),lnext(n),unext(n),Llist(k),Lfirst(k-1),Ufirst(k-1),
     +        jw(2*n)
      doubleprecision    alu(*),w(n)
c----------------------------------------------------------------------*
c     update row k of the Schur complement (resp. column k)
c
c     n         size of the problem
c     k         current step of the update procedure
c     alu       numerical values
c     jlu       associated indices
c     lnext     pointers to the first space behind any column of L
c     unext     pointers to the first space behind any row of U
c     Llist     linked list for the nonzeros of L in row k
c     Lfirst    first nonzero entry in L(k:n,i)
c     Ufirst    first nonzero entry in U(i,k:n)
c     jw        indices of nonzero entries and associated list
c     len       length of this list
c     w         numerical values

      integer i,j,jj,l
      doubleprecision x

      i=Llist(k)
c     while i>0
 10      if (i.eq.0) goto 999
c        does there exist an entry in L(k:n,i)?
         jj=Lfirst(i)
         if (jj.lt.lnext(i)) then
c           if this is the case, is the first entry equal to k,
c           otherwise we don't need to do an update because L(k,i)=0
            if (jlu(jj).eq.k) then
c              L(k,i)/D(i,i)
               x=alu(jj)*alu(i)
c              nonzeros in row i of U, start at position at least k

               jj=Ufirst(i)
c              innermost loop, update 
               do 20 l=jj,unext(i)-1
c                 index j of U(i,j)
                  j=jlu(l)
c                 update numerical value
                  w(j)=w(j)-alu(l)*x
                  if (jw(j).eq.0) then
                     len=len+1
c                    flag component i as nonzero
                     jw(j)=len
c                    add j to the list of nonzeros
                     jw(n+len)=j
                  end if
 20            continue
            end if 
         end if
         i=Llist(i)
      goto 10
c     end while
 999  return
c----------------end-of-silucupdate-------------------------------------
c-----------------------------------------------------------------------
      end

