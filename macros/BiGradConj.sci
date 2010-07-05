function [x, err, iter, flag, res] = BiGradConj(Mat,varargin)

//  -- Iterative template routine --
//     Univ. of Tennessee and Oak Ridge National Laboratory
//     October 1, 1993
//     Details of this algorithm are described in "Templates for the
//     Solution of Linear Systems: Building Blocks for Iterative
//     Methods", Barrett, Berry, Chan, Demmel, Donato, Dongarra,
//     Eijkhout, Pozo, Romine, and van der Vorst, SIAM Publications,
//     1993. (ftp netlib2.cs.utk.edu; cd linalg; get templates.ps).
//
//  [x, err, iter, flag, res] = bicg(A, Ap, b, x, M, Mp, max_it, tol)
//
// bicg.m solves the linear system Ax=b using the 
// BiConjugate Gradient Method with preconditioning.
//
// input   Mat      REAL matrix or function
//         b        REAL right hand side vector
//         Matp     REAL matrix or function, transposed of Mat
//         x        REAL initial guess vector
//         M        REAL preconditioner matrix
//         Mp       REAL preconditioner matrix, transposed of M
//         max_it   INTEGER maximum number of iterations
//         tol      REAL error tolerance
//
// output  x        REAL solution vector
//         err      REAL final residual norm
//         iter     INTEGER number of iterations performed
//         flag     INTEGER: 0 = solution found to tolerance
//                           1 = no convergence given max_it
//                          -1 = breakdown
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
  error("bicg: matrix or function is expected",502);
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

// Cas où A est une matrice pleine ou creuse
if (cpt==1),
  if (size(Mat,1) ~= size(Mat,2)),
    error("bicg: the matrix A must be square",502);
  end
  if (rhs == 1),
    error("bicg: right hand side vector b is expected",502);
  end
  deff('y=matvec(x)','y=Mat*x');
  deff('y=matvecp(x)','y=(x''*Mat)''');
  fct=0;
end

// Cas où A est une fonction
if (cpt==0),
  if (rhs == 1),
    error("bicg: transpose of the function A is expected",502);
  end
  matvec=Mat;
  fct=1;
end
if (rhs >= 2 & fct==1 ),
  matvecp=varargin(1);
  if ( type(matvecp) ~= 13 ),
    error("bicg: the second variable must be the transpose of the function A",502);
  end
end

//--------------------------------------------------------
// Parsing of the right hand side b
//--------------------------------------------------------

if ( rhs >= fct+2 ),
  b=varargin(fct+1);
  if ( size(b,2) ~= 1),
  error("bicg: right hand side member must be a column vector",502);
  end
else 
  error("bicg: right hand side vector b is expected",502);
end

//--------------------------------------------------------
// Parsing of the initial vector x
//--------------------------------------------------------

if ( rhs >= fct+3),
  x=varargin(fct+2);
  if (size(x,2) ~= 1),
    error("bicg: initial guess x0 must be a column vector",502);
  end
  if ( size(x,1) ~= size(b,1)),
    error("bicg: initial guess x0 must have the size of the vector b",502);
  end
else
  x=zeros(size(b,1),1);
end

//--------------------------------------------------------
// Parsing of the preconditioner matrix M
//--------------------------------------------------------

if (rhs >=fct+4),
  Prec=varargin(fct+3);
  select type(Prec)
  case 1 then
    cpt2=1;
  case 5 then
    cpt2=1;
  case 13 then
    cpt2=0;
  end 
  if ( cpt2==1 ),
    if (size(Prec,1) ~= size(Prec,2)),
      error("bicg: the preconditionner matrix M must be square",502);
    end 
    if (size(Prec,1)~=size(b,1)),
      error("bicg: the size of the preconditionner matrix M must be the size of b",502);
    end  
    deff('y=precond(x)','y=Prec \ x');
    deff('y=precondp(x)','y=Prec'' \ x');
  end
  if ( cpt2==0 ),
    precond=Prec;
    fct=fct+1;
    if ( rhs >= fct+4 ),
      precondp=varargin(fct+3);
      if ( type(precondp) ~= 13 ) ,
	error("bicg: the tranpose function of M is expected",502);
      end
    else
      error("bicg: the tranpose function of M must follow the function M",502);
    end
  end
else
  deff('y=precond(x)','y=x');
  deff('y=precondp(x)','y=x');   
end

//--------------------------------------------------------
// Parsing of the maximum number of iterations max_it
//--------------------------------------------------------

if (rhs >= fct+5),
  max_it=varargin(fct+4);
  if (size(max_it,1) ~= 1 | size(max_it,2) ~=1),
    error("bicg: max_it must be a scalar",502);
  end 
else
  max_it=size(Mat,1);
end

//--------------------------------------------------------
// Parsing of the error tolerance tol
//--------------------------------------------------------

if (rhs == fct+6),
  tol=varargin(fct+5);
  if (size(tol,1) ~= 1 | size(tol,2) ~=1),
    error("bicg: tol must be a scalar",502);
  end
else
  tol=10*%eps;
end

//--------------------------------------------------------
// test about input arguments number
//--------------------------------------------------------

if (rhs > fct+7),
  error("bicg: too many input arguments",502);
end

//========================================================
//========================================================
//
//		Begin of computations
//
//========================================================
//========================================================

i = 0;                              // initialization
flag = 0;

bnrm2 = norm( b );
if  ( bnrm2 == 0.0 ), bnrm2 = 1.0; end

//  r = b - A*x;

r = b - matvec(x);
err = norm( r ) / bnrm2;
res = err;
if ( err < tol ), return; end

r_tld  = r;

for i = 1:max_it                    // begin iteration

  //     z = M \ r;
  z = precond(r);
  //     z_tld = M' \ r_tld;
  z_tld = precondp(r_tld);
  rho   = ( z'*r_tld );
  if ( rho == 0.0 ),
    break
  end

  if ( i > 1 ),                    // direction vectors
    beta = rho / rho_1;
    p   = z  + beta*p;
    p_tld = z_tld + beta*p_tld;
  else
    p = z;
    p_tld = z_tld;
  end

  //     q = A*p;
  q = matvec(p);                       // compute residual pair
  //     q_tld = A'*p_tld;
  q_tld = matvecp(p_tld);
  alppha = rho / (p_tld'*q );

  x = x + alppha*p;                    // update approximation
  r = r - alppha*q;
  r_tld = r_tld - alppha*q_tld;

  err = sqrt(r'*r) / bnrm2;          // check convergence
  res= [res;err];

  if ( err <= tol ), iter=i;  break; end

  rho_1 = rho;
  
  if ( i == max_it ), iter=i; end

end

if ( err <= tol ),                   // converged
  flag =  0;
elseif ( rho == 0.0 ),                 // breakdown
  flag = -1;
else
  flag = 1;                           // no convergence
end
endfunction
// END bicg.sci
