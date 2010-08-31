subroutine qsplit(a,ind,n,ncut)
        real*8 a(n)
        integer ind(n), n, ncut
c-----------------------------------------------------------------------
c     does a quick-sort split of a real array.
c     on input a(1:n). is a real array
c     on output a(1:n) is permuted such that its elements satisfy:
c
c     abs(a(i)) .ge. abs(a(ncut)) for i .lt. ncut and
c     abs(a(i)) .le. abs(a(ncut)) for i .gt. ncut
c
c     ind(1:n) is an integer array which permuted in the same way as a(*).
c-----------------------------------------------------------------------
        real*8 tmp, abskey
        integer itmp, first, last
c-----
        first = 1
        last = n
        if (ncut .lt. first .or. ncut .gt. last) return
c
c     outer loop -- while mid .ne. ncut do
c
 1      mid = first
        abskey = abs(a(mid))
        do 2 j=first+1, last
           if (abs(a(j)) .gt. abskey) then
              mid = mid+1
c     interchange
              tmp = a(mid)
              itmp = ind(mid)
              a(mid) = a(j)
              ind(mid) = ind(j)
              a(j)  = tmp
              ind(j) = itmp
           endif
 2      continue
c
c     interchange
c
        tmp = a(mid)
        a(mid) = a(first)
        a(first)  = tmp
c
        itmp = ind(mid)
        ind(mid) = ind(first)
        ind(first) = itmp
c
c     test for while loop
c
        if (mid .eq. ncut) return
        if (mid .gt. ncut) then
           last = mid-1
        else
           first = mid+1
        endif
        goto 1
c----------------end-of-qsplit------------------------------------------
c-----------------------------------------------------------------------
        end
