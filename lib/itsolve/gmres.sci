function [x, err, iter, flag, res] = gmres( Mat, varargin)

//  -- Iterative template routine --
//     Univ. of Tennessee and Oak Ridge National Laboratory
//     October 1, 1993
//     Details of this algorithm are described in "Templates for the
//     Solution of Linear Systems: Building Blocks for Iterative
//     Methods", Barrett, Berry, Chan, Demmel, Donato, Dongarra,
//     Eijkhout, Pozo, Romine, and van der Vorst, SIAM Publications,
//     1993. (ftp netlib2.cs.utk.edu; cd linalg; get templates.ps).
//
// [x, err, iter, flag, res] = gmres( A, b, x, M, restrt, max_it, tol )
//
// gmres.m solves the linear system Ax=b
// using the Generalized Minimal residual ( GMRESm ) method with restarts .
//
// input   A        REAL nonsymmetric positive definite matrix or function
//         x        REAL initial guess vector
//         b        REAL right hand side vector
//         M        REAL preconditioner matrix or function
//         restrt   INTEGER number of iterations between restarts
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
  error("Matrix or function is expected");
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
  error("gmres: right hand side vector b is expected",502);
end 

// Cas où A est une matrice pleine ou creuse
if (cpt==1),
  if (size(Mat,1) ~= size(Mat,2)),
    error("gmres: matrix A must be square",502);
  end
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
  error("gmres: right hand side member must be a column vector",502);
end
if ( cpt==1 ),
  if ( size(b,1) ~= size(Mat,1) ),
    error("gmres: right hand side member must have the size of the matrix A",502);
  end 
end

//--------------------------------------------------------
// Parsing of the initial vector x
//--------------------------------------------------------

if (rhs >= 3),
  x=varargin(2);
  if (size(x,2) ~= 1),
    error("Initial guess x0 must be a column vector");
  end
  if ( size(x,1) ~= size(b,1) ),
    error("gmres: initial guess x0 must have the size of the matrix A",502);
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
      error("gmres: preconditionner matrix M must be square",502);
    end 
    if ( size(Prec,1) ~= size(b,1) ), 
      error("Preconditionner matrix M and the matrix A must have same size");
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
// Parsing of the number of iterations between restarts
//--------------------------------------------------------

if (rhs >= 5),
  restrt=varargin(4);
  if (size(restrt,1) ~= 1 | size(restrt,2) ~=1),
    error("gmres: restrt must be a scalar",502);
  end 
else
  restrt=15;
end

//--------------------------------------------------------
// Parsing of the maximum number of iterations max_it
//--------------------------------------------------------

if (rhs >= 6),
  max_it=varargin(5);
  if (size(max_it,1) ~= 1 | size(max_it,2) ~=1),
    error("gmres: max_it must be a scalar",502);
  end 
else
  max_it=size(b,1);
end

//--------------------------------------------------------
// Parsing of the error tolerance tol
//--------------------------------------------------------

if (rhs == 7),
  tol=varargin(6);
  if (size(tol,1) ~= 1 | size(tol,2) ~=1),
    error("gmres: tol must be a scalar",502);
  end
else
  tol=1000*%eps;
end

//--------------------------------------------------------
// test about input arguments number
//--------------------------------------------------------

if (rhs > 7),
  error("gmres: too many input arguments",502);
end

//========================================================
//========================================================
//
//                Begin of computations
//
//========================================================
//========================================================

   j = 0;                                         // initialization
   flag = 0;
   it2 = 0;
 
   bnrm2 = sqrt( b'*b );
   if  ( bnrm2 == 0.0 ), bnrm2 = 1.0; end

//   r = M \ ( b-A*x );

//   halt();

   r = precond( b-matvec(x) );
   err = sqrt( r'*r ) / bnrm2;
   res = err;
   if ( err < tol ), iter=0; return; end

//   [n,n] = size(A);                             // initialize workspace

   n = size(b,1);
   m = restrt;
   V = zeros(n,m+1);
   H = zeros(m+1,m);
   cs = zeros(m,1);
   sn = zeros(m,1);
   e1 = zeros(n,1);
   e1(1) = 1.0;

   for j = 1:max_it                               // begin iteration

//    r = M \ ( b-A*x );

//      halt();

      r = precond( b-matvec(x) );
      s = sqrt( r'*r );
      V(:,1) = r / s;
      s = s*e1;

      for i = 1:m                                    // construct orthonormal

         it2 = it2 + 1;

//	 w = M \ (A*V(:,i));                         // basis using Gram-Schmidt
         w = precond( matvec(V(:,i)) );
	 H(1:i,i)=(w'*V(:,1:i))';
	 w=w-V(:,1:i)*H(1:i,i);
	 //for k = 1:i 
	 //  H(k,i)= w'*V(:,k);
	 //  w = w - H(k,i)*V(:,k);
	 //end
	 H(i+1,i) = sqrt( w'*w );
	 V(:,i+1) = w / H(i+1,i);
	 for k = 1:i-1                               // apply Givens rotation
            temp     =  cs(k)*H(k,i) + sn(k)*H(k+1,i);
            H(k+1,i) = -sn(k)*H(k,i) + cs(k)*H(k+1,i);
            H(k,i)   = temp;
	 end
	 [tp1,tp2] = rotmat( H(i,i), H(i+1,i) ); // form i-th rotation matrix
         cs(i)  = tp1;
         sn(i)  = tp2;
         temp   = cs(i)*s(i);                        // approximate residual norm
         s(i+1) = -sn(i)*s(i);
	 s(i)   = temp;
         H(i,i) = cs(i)*H(i,i) + sn(i)*H(i+1,i);
         H(i+1,i) = 0.0;
	 err  = abs(s(i+1)) / bnrm2;
         res = [res;err];
	 //plot2d('nl',length(res),res($),0)
 	 if ( err <= tol ),                        // update approximation
	    y = sparse(H(1:i,1:i)) \ s(1:i);                 // and exit
            x = x + V(:,1:i)*y;
  	    break;
	 end

      end

      if ( err <= tol ), iter=j-1+it2;break; end
      //y = H(1:m,1:m) \ s(1:m);
      // il faut faire quelque chose ici !!!!!!!!!!!!
      y = sparse(H(1:m,1:m)) \ s(1:m);
//       y = inv(H(1:m,1:m)) * s(1:m);
      x = x + V(:,1:m)*y;                            // update approximation
//    r = M \ ( b-A*x )                              // compute residual

      r = precond( b -matvec(x) ); 
      s(j+1) = sqrt(r'*r);
      err = s(j+1) / bnrm2;                        // check convergence
      res = [res;err];
      //plot2d('nl',length(res),res($),0)
      
      if ( err <= tol ), iter=j+it2;break; end
      if ( j== max_it ), iter=j+it2; end
    end

   if ( err > tol ), flag = 1; end                 // converged

// END of gmres.sci
