function [x, err, iter, flag, res] = pcg(Mat, varargin)

//  -- Iterative template routine --
//     Univ. of Tennessee and Oak Ridge National Laboratory
//     October 1, 1993
//     Details of this algorithm are described in "Templates for the
//     Solution of Linear Systems: Building Blocks for Iterative
//     Methods", Barrett, Berry, Chan, Demmel, Donato, Dongarra,
//     Eijkhout, Pozo, Romine, and van der Vorst, SIAM Publications,
//     1993. (ftp netlib2.cs.utk.edu; cd linalg; get templates.ps).
//
//  [x, err, iter, flag, res] = pcg(A, b, x, M, max_it, tol)
//
// cg.m solves the symmetric positive definite linear system Ax=b 
// using the Conjugate Gradient method with preconditioning.
//
// input   A        REAL symmetric positive definite matrix or function
//         x        REAL initial guess vector
//         b        REAL right hand side vector
//         M        REAL preconditioner matrix
//         max_it   INTEGER maximum number of iterations
//         tol      REAL error tolerance
//
// output  x        REAL solution vector
//         err      REAL final residual norm
//         iter     INTEGER number of iterations performed
//         flag     INTEGER: 0 = solution found to tolerance
//                           1 = no convergence given max_it
//         res      REAL residual vector


//========================================================
//========================================================
//
//               Parsing input arguments.
//
//========================================================
//========================================================

[lhs,rhs]=argn(0);
if ( rhs== 0 ),
  error("pcg: matrix or function is expected");
end

//--------------------------------------------------------
// Parsing of the matrix A
//--------------------------------------------------------

select type(Mat)
case 1 then
  cpt=1;
case 5 then
  cpt=1;
case 13 then
  cpt=0;
end

if (rhs == 1),
  error("pcg: right hand side vector b is expected",502);
end  

// Cas où A est une matrice pleine ou creuse
if (cpt==1),
  if (size(Mat,1) ~= size(Mat,2)),
    error("pcg: matrix A must be square",502);
  end
  // test de symmétrie supprime !!!
  //if ( bool2s(or( Mat ~= Mat')) == 1 ),
  //  error("pcg: matrix A must be symetric",502);
  //end
  deff('y=matvec(x)','y=Mat*x');
end

// Cas où A est une fonction
if (cpt==0),
  matvec=Mat;
end

//--------------------------------------------------------
// Parsing of the right hand side b
//--------------------------------------------------------

b=varargin(1);
if ( size(b,2) ~= 1 ),
  error("pcg: right hand side member must be a column vector",502);
end
if ( cpt==1 ),
  if ( size(b,1) ~= size(Mat,1) ),
    error("pcg: right hand side member must have the size of the matrix A",502);
  end 
end

//--------------------------------------------------------
// Parsing of the initial vector x
//--------------------------------------------------------
 
if (rhs >= 3),
   x=varargin(2);
   if (size(x,2) ~= 1),
      error("pcg: initial guess x0 must be a column vector",502);
   end
   if ( size(x,1) ~= size(b,1) ),
     error("pcg: initial guess x0 must have the size of b",502);
   end 
else
  x=zeros(size(b,1),1);
end

//--------------------------------------------------------
// Parsing of the preconditioner matrix M
//--------------------------------------------------------

if (rhs >=4),
   Prec=varargin(3);
   select type(Prec)
   case 1 then
      cpt=1;
   case 5 then
      cpt=1;
   case 13 then
      cpt=0;
   end 
   if ( cpt==1 ),
      if (size(Prec,1) ~= size(Prec,2)),
        error("pcg: preconditionner matrix M must be square",502);
      end 
      if ( size(Prec,1) ~= size(b,1) ),
	error("pcg: preconditionner matrix M must have the size of b",502);
      end
      deff('y=precond(x)','y=Prec \ x');
   end
   if ( cpt==0 ),
      precond=varargin(3);
   end
else
   deff('y=precond(x)','y=x');
end

//--------------------------------------------------------
// Parsing of the maximum number of iterations max_it
//--------------------------------------------------------

if (rhs >= 5),
   max_it=varargin(4);
   if (size(max_it,1) ~= 1 | size(max_it,2) ~=1),
      error("pcg: max_it must be a scalar",502);
   end 
else
   max_it=size(b,1);
end

//--------------------------------------------------------
// Parsing of the error tolerance tol
//--------------------------------------------------------

if (rhs == 6),
   tol=varargin(5);
   if (size(tol,1) ~= 1 | size(tol,2) ~=1),
      error("pcg: tol must be a scalar",502);
   end
else
   tol=1000*%eps;
end

//--------------------------------------------------------
// test about input arguments number
//--------------------------------------------------------

if (rhs > 6),
   error("pcg: too many input arguments",502);
end

//========================================================
//========================================================
//
//               Begin of computations
//
//========================================================
//========================================================

  flag = 0;                                 // initialization
  i = 0;

  bnrm2 = sqrt( b'*b );
  if  ( bnrm2 == 0.0 ), bnrm2 = 1.0; end

//  r = b - A*x;

  r = b - matvec(x);
  err = sqrt( r'*r ) / bnrm2;
  res = err;
  if ( err < tol ), return; end

  for i = 1:max_it,                       // begin iteration

//     z  = M \ r;
     z  = precond(r);
     rho = (r'*z);

     if ( i > 1 ),                       // direction vector
        Beta = rho / rho_1;
        p = z + Beta*p;
     else
        p = z;
     end

//     q = A*p;

     q=matvec(p);
     alppha = rho / (p'*q );
     x = x + alppha * p;                    // update approximation vector

     r = r - alppha*q;                      // compute residual
     err = sqrt( r'*r ) / bnrm2;            // check convergence
     res = [res;err];
     if ( err <= tol ), iter=i; break; end 

     rho_1 = rho;
     
     if ( i == max_it ), iter=i; end
     
     plot2d('nl',length(res),res($),0)
  end

  if ( err > tol ),flag = 1; end         // no convergence

// END cg.m
