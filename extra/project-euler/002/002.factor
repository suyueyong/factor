! Copyright (c) 2007 Aaron Schaefer, Alexander Solovyov.
! See http://factorcode.org/license.txt for BSD license.
USING: kernel math sequences shuffle ;
IN: project-euler.002

! http://projecteuler.net/index.php?section=problems&id=2

! DESCRIPTION
! -----------

! Each new term in the Fibonacci sequence is generated by adding the previous
! two terms. By starting with 1 and 2, the first 10 terms will be:

!     1, 2, 3, 5, 8, 13, 21, 34, 55, 89, ...

! Find the sum of all the even-valued terms in the sequence which do not exceed one million.


! SOLUTION
! --------

<PRIVATE

: (fib-upto) ( seq n limit -- seq )
    2dup <= [ [ over push dup 2 tail* sum ] dip (fib-upto) ] [ 2drop ] if ;

PRIVATE>

: fib-upto ( n -- seq )
    V{ 0 } clone 1 rot (fib-upto) ;

: euler002 ( -- answer )
    1000000 fib-upto [ even? ] filter sum ;

! [ euler002 ] 100 ave-time
! 0 ms run / 0 ms GC ave time - 100 trials


! ALTERNATE SOLUTIONS
! -------------------

: fib-upto* ( n -- seq )
    0 1 [ pick over >= ] [ tuck + dup ] [ ] unfold 3nip
    but-last-slice { 0 1 } prepend ;

: euler002a ( -- answer )
    1000000 fib-upto* [ even? ] filter sum ;

! [ euler002a ] 100 ave-time
! 0 ms run / 0 ms GC ave time - 100 trials

MAIN: euler002a
