function [x, error, total_iters, exitflag, funcEval] = nsoli_dtfqmr(problem, xc, fc, xinit, exitflag, funcEval)
% *************************************************************************************************************************************************************
% Function  : Forward difference TFQMR solver for use in nsoli (see item 3.1)
%             Note that for Newton-GMRES we incorporate any preconditioning
%             into the function routine.
%             (Kelley, C.T., Solving Nonlinear Equations with Newton's Method)
%
% *** INPUTS **************************************************************************************************************************************************
% 	problem ........... data structure with the problem definition
%   xc ................ current point solution
% 	fc ................ current function solution
%   xinit ............. initial iterate (xinit = 0 is the default; this is
%                       a reasonable choice unless restarts are needed.
% 	funcEval .......... function evaluation count
%
% *** OUTPUTS *************************************************************************************************************************************************
%   x ................. solution
%   error ............. vector of residual norms for the history of the iteration
%   total_iters ....... number of iterations
% 	funcEval .......... updated function evaluation count
%
% *************************************************************************************************************************************************************
% C. T. Kelley, April 1, 2003
% This code comes with no guarantee or warranty of any kind.
% *************************************************************************************************************************************************************

%% Internal control parameters
    etamax  = problem.options.etamax;
    kmax    = problem.options.MaxIterInn;
    n       = problem.auxiliar.n;
    
%% Initialization
    b      = -fc;
    errtol = abs(etamax)*norm(b);
    error  = []; 
    x      = zeros(n,1);
    r      = b;
    if (~isempty(xinit))
        x             = xinit;
        [z, funcEval] = nsoli_dirder(problem, xc, x, fc, funcEval);
        r             = -z-fc;
    end
    u             = zeros(n,2);
    y             = zeros(n,2);
    w             = r;
    y(:,1)        = r; 
    k             = 0;
    d             = zeros(n,1); 
    [v, funcEval] = nsoli_dirder(problem, xc, y(:,1), fc, funcEval);
    u(:,1)        = v;
    theta         = 0;
    eta           = 0;
    tau           = norm(r);
    error         = [error,tau];
    rho           = tau*tau;
    
%% TFQMR iteration
    while(k < kmax)
        k     = k+1;
        sigma = r'*v;
        if sigma == 0
            fprintf('   ERROR: TFQMR breakdown, sigma = 0 \n');
            exitflag = 4;
            return;
        end
        alpha = rho/sigma;
        for j = 1:2
            % Compute y2 and u2 only if you have to
                if j == 2 
                    y(:,2)             = y(:,1)-alpha*v;
                    [u(:,2), funcEval] = nsoli_dirder(problem, xc, y(:,2), fc, funcEval);
                end
                m     = 2*k-2+j;
                w     = w-alpha*u(:,j);
                d     = y(:,j)+(theta*theta*eta/alpha)*d;
                theta = norm(w)/tau;
                c     = 1/sqrt(1+theta*theta);
                tau   = tau*theta*c;
                eta   = c*c*alpha;
                x     = x+eta*d;
            % Try to terminate the iteration at each pass through the loop
                if tau*sqrt(m+1) <=  errtol
                    error       = [error, tau];
                    total_iters = k;
                    return
                end
        end
        if rho == 0
            fprintf('   ERROR: TFQMR breakdown, rho = 0 \n');
            exitflag = 4;
            return;
        end
        rhon               = r'*w;
        beta               = rhon/rho;
        rho                = rhon;
        y(:,1)             = w + beta*y(:,2);
        [u(:,1), funcEval] = nsoli_dirder(problem, xc, y(:,1), fc, funcEval);
        v                  = u(:,1)+beta*(u(:,2)+beta*v);
        error              = [error, tau];
        total_iters        = k;
    end

end % *** END FUNCTION % **************************************************************************************************************************************
