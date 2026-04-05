function [problem] = nsolver(problem)
% Function  : Solvers for nonlinear system of equations based on the 
%             following Newton's methods:
%               - Newton's method with direct factorization of Jacobians (item 2)
%               - Inexact Newton-Krylov methods without matrix storage (item 3)
%               - Broyden's method (NOT WORKING)
%             (Kelley, C.T., Solving Nonlinear Equations with Newton's Method)
%
% *** INPUTS **************************************************************************************************************************************************
% 	problem ........... data structure with the problem definition
%       fun ........... handle function for nonlinear system of equations
%       x0 ............ initial iterate
%       auxiliar ...... auxiliar variables for internal calculations
%       options ....... options of the nonlinear solver
%           'Algorithm'     :  'newton-direct'  : Newton's method with direct factorization of Jacobians
%                              'newton-krylov'  : Inexact Newton-Krylov methods without matrix storage
%                              'newton-broyden' : Broyden's method (NOT WORKING)
%           -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
%           Algorithm: 'newton-direct'
%           -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
%           'FinDiffRelStep'   : Scalar step size factor (scale for difference increment). 
%           'MaxIter'          : Maximum number of iterations allowed, a positive integer. The default is 400
%           'TypicalX'         : Typical x values. The number of elements in TypicalX is equal to the number of elements in x0, the starting point. 
%                                TypicalX is used for scaling finite differences for gradient estimation.
%           'TolFunAbs'        : Absolute termination tolerance on the function value, a positive scalar.
%           'TolFunRel'        : Relative termination tolerance on the function value, a positive scalar.
%           'Isham'            : The Jacobian matrix is computed and factored after 'Isham' updates of x
%           'Rsham'            : The Jacobian matrix is computed and factored whenever the ratio of successive l2 norms of the nonlinear residual exceeds 'Rsham'
%                                   isham = -1, rsham = .5 is the default
%                                   isham =  1, rsham = 0 is Newton's method,
%                                   isham = -1, rsham = 1 is the chord method,
%                                   isham =  m, rsham = 1 is the Shamanskii method with m steps per Jacobian evaluation
%                                   The Jacobian is computed and factored whenever the stepsize is reduced in the line search.
%                                   DEFAULT: Isham = 1 ; Rsham = 0
%           'Jdiff'            : Jacobian computation
%                                   jdiff = 1: compute Jacobians with forward differences
%                                   jdiff = 0: a call to f will provide analytic Jacobians using the syntax [function,jacobian] = f(x)
%                                   DEFAULT: Jdiff = 1
%           'nl'               : Lower bandwidths of a banded Jacobian
%           'nu'               : Upper bandwidths of a banded Jacobian
%                                   If you include nl and nu in the parameter list, the Jacobian will be evaluated with a banded differencing
%                                   scheme and stored as a sparse matrix.
%                                   DEFAULT: nl = 0 ; nu = 0
%           'alpha'            : measure sufficient decrease for the line search
%                                   DEFAULT: alfa = 1e-4
%           'sigma0'           : lower safeguarding bound for the line search
%                                   DEFAULT: sigma0 = 0.1
%           'sigma1'           : upper safeguarding bound for the line search
%                                   DEFAULT: sigma1 = 0.5
%           'maxarm'           : maximum number of steplength reductions before failure is reported
%                                   DEFAULT: maxarm = 20
%           -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
%           Algorithm: 'newton-krylov'
%           -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
%           'MaxIterInn'       : maximum number of inner iterations before restart in GMRES(m), m = maxitl
%                                For iterative methods other than GMRES(m) maxitl is the upper bound on linear iterations
%                                   DEFAULT: MaxIterInn = 40
%           'etamax'           : Maximum error tolerance for residual in inner iteration. The inner iteration terminates
%                                when the relative linear residual is smaller than eta*| F(x_c) |. eta is determined
%                                by the modified Eisenstat-Walker formula if etamax > 0.
%                                If etamax < 0, then eta = |etamax| for the entire iteration.
%                                   DEFAULT: etamax = 0.9
%           'lmeth'            : choice of linear iterative method
%                                   1 GMRES
%                                   2 GMRES(m)
%                                   3 BICGSTAB
%                                   4 TFQMR
%                                   DEFAULT: lmeth = 1 (GMRES, no restarts)
%           'restart_limit'    : max number of restarts for GMRES(m)
%                                   DEFAULT: restart_limit = 20
%           'gamma'            : adjust parameter for the Eisenstat-Walker forcing term
%                                   DEFAULT: restart_limit = 0.9
%           -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
%           Algorithm: 'newton-broyden'
%           -----------------------------------------------------------------------------------------------------------------------------------------------------------------------
%           'maxdimBroyden'    : maximum number of Broyden iterations before restart
%                                   DEFAULT: 40
%
%       output ........... data structure with the problem solution
%           x ............ vector solution x
%           fval ......... vector function at the solution x
%           jacobian ..... value of the jabocian matrix at the solution x
%           iterations ... number of iterations taken
%           funcEval ..... number of function evaluations
%           iterHist ..... array of iteration history
%               1st column: iteration number
%               2nd column: accumulated function evaluation
%               3rd column: residual norm
%               4th column: step norm
%           xHist ........ matrix of the entire interation history
%               1st column  : iteration number
%               2nd-n column: vector solution x
%           exitflag ..... convergence status
%               exitflag = 1  : upon successful termination
%               exitflag = 2  : number of iterations exceeded options MaxIter
%               exitflag = 3  : failure in the line search
%               exitflag = 4  : failure Krylov linear solver (only for 'newton-krylov' algorithm)
%           message ...... exit message    
%
% *************************************************************************************************************************************************************

%% Solution of the nonlinear system of equation
    switch problem.options.Algorithm
            case 'newton-direct'           % Newton's method with direct factorization of Jacobians
                problem = nsold_createAuxiliar(problem);
                problem = nsold_createOutput(problem);
                problem = nsold(problem);
            case 'newton-krylov'           % Inexact Newton-Krylov methods without matrix storage
                problem = nsoli_createAuxiliar(problem);
                problem = nsoli_createOutput(problem);
                problem = nsoli(problem);
            case 'newton-broyden'          % Broyden's method (NOT WORKING)
                problem = brsola_createAuxiliar(problem);
                problem = brsola_createOutput(problem);
                problem = brsola(problem);
        otherwise
            error('Unknown Newton''s solver');
    end

end % *** END FUNCTION % **************************************************************************************************************************************
    