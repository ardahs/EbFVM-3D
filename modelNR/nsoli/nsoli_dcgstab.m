function [x, error, total_iters, exitflag, funcEval] = nsoli_dcgstab(problem, xc, fc, xinit, exitflag, funcEval)
% Function  : Forward difference Bi-CGSTAB solver for use in nsoli (see item 3.1)
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
% 	kryflag ........... flag for Krylov method occurence
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
    rho    = zeros(kmax+1,1);
    
%% Use zero vector as initial iterate for Newton step unless the calling routine has a better idea (useful for GMRES(m))
    x = zeros(n,1);
    r = b;
    if (~isempty(xinit))
        x             = xinit;
        [z, funcEval] = nsoli_dirder(problem, xc, x, fc, funcEval);
        r             = -z-fc;
    end
    hatr0  = r;
    k      = 0;
    rho(1) = 1;
    alpha  = 1;
    omega  = 1;
    v      = zeros(n,1);
    p      = zeros(n,1);
    rho(2) = hatr0'*r;
    zeta   = norm(r);
    error  = [error,zeta];
    
%% Bi-CGSTAB iteration
    while((zeta > errtol) && (k < kmax))
        k = k+1;
        if (omega == 0)
            fprintf('   ERROR: Bi-CGSTAB breakdown, omega = 0 \n');
            exitflag = 4;
            return;
        end
        beta          = (rho(k+1)/rho(k))*(alpha/omega);
        p             = r+beta*(p - omega*v);
        [v, funcEval] = nsoli_dirder(problem, xc, p, fc, funcEval);
        tau           = hatr0'*v;
        if (tau == 0)
            fprintf('   ERROR: Bi-CGSTAB breakdown, tau = 0 \n');
            exitflag = 4;
            return;
        end 
        alpha         = rho(k+1)/tau;
        s             = r-alpha*v; 
        [t, funcEval] = nsoli_dirder(problem, xc, s, fc, funcEval);
        tau           = t'*t;
        if (tau == 0)
            fprintf('   ERROR: Bi-CGSTAB breakdown, t = 0 \n');
            exitflag = 4;
            return;
        end
        omega       = t'*s/tau; 
        rho(k+2)    = -omega*(hatr0'*t);
        x           = x+alpha*p+omega*s;
        r           = s-omega*t;
        zeta        = norm(r);
        total_iters = k;
        error       = [error, zeta];
    end

end % *** END FUNCTION % **************************************************************************************************************************************
