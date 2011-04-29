c----------------------------------------------------------------------c
c                          S P A R S K I T                             c
c----------------------------------------------------------------------c
c                   ITERATIVE SOLVERS MODULE                           c
c----------------------------------------------------------------------c
c This Version Dated: August 13, 1996. Warning: meaning of some        c
c ============ arguments have changed w.r.t. earlier versions. Some    c
c              Calling sequences may also have changed                 c
c----------------------------------------------------------------------c 
        subroutine qsort2(val,ind,stack,n)
        double precision val(n)
        integer ind(n),stack(n),n
c-----------------------------------------------------------------------
c     does a quick-sort of an integer array.
c     on input val(1:n), is a real array, ind(1:n) is an integer array
c     on output ind(1:n) is permuted such that its elements are in 
c               increasing order. val(1:n) is an real array which 
c               permuted in the same way as ind(*).
c
c  code taken from SPARSKIT of Yousef Saad.
c  adapted by Matthias Bollhoefer for the complex case
c-----------------------------------------------------------------------
        doubleprecision valtmp
        integer indtmp, key, first, last,top
c-----
        top=0
        first=1
        last =n
c
c     outer loop -- while first<last or top>0 do
c
 1      if (first.ge.last .and. top.eq.0) goto 999
        mid = first
        key = ind(mid)
        do 2 j=first+1, last
           if (ind(j) .lt. key) then
              mid = mid+1
c     interchange entries at position j and mid
              valtmp = val(mid)
              val(mid) = val(j)
              val(j)  = valtmp

              indtmp = ind(mid)
              ind(mid) = ind(j)
              ind(j) = indtmp
           endif
 2      continue
c
c     interchange
        valtmp = val(mid)
        val(mid) = val(first)
        val(first)  = valtmp
c
        indtmp = ind(mid)
        ind(mid) = ind(first)
        ind(first) = indtmp
c
c     test for while loop
        if (first.lt.mid-1 .or. last.gt.mid+1) then
           if (first .lt. mid-1) then
              top=top+1
              stack(top)=mid
              last=mid-1
           else
              first=mid+1
           endif
        else
           if (top.gt.0) then
              first=stack(top)+1
              stack(top)=0
              top=top-1
              if (top.gt.0) then
                 last=stack(top)-1
              else
                 last=n
              endif
           else
              first=last
           endif
        end if
        goto 1
 999    return
        end
c----------------end-of-qsort2------------------------------------------
c-----------------------------------------------------------------------
