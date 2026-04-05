function [x, error, total_iters, funcEval] = nsoli_dgmres(problem, xc, fc, xinit, funcEval)
% Function  : GMRES linear equation solver for use in Newton-GMRES solver (see item 3.1)
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
    
%% The right side of the linear equation for the step is -fc. 
    b      = -fc;
    errtol = abs(etamax)*norm(b);
    reorth = 1;
    
%% Use zero vector as initial iterate for Newton step unless the calling routine has a better idea (useful for GMRES(m)).
    x = zeros(n,1);
    r = b;
    if (~isempty(xinit))
        x = xinit;
        [z, funcEval] = nsoli_dirder(problem, xc, x, fc, funcEval);
        r = -z-fc;
    end
    h      = zeros(kmax);
    v      = zeros(n,kmax);
    c      = zeros(kmax+1,1);
    s      = zeros(kmax+1,1);
    rho    = norm(r);
    g      = rho*eye(kmax+1,1);
    error  = [];
    
%% Test for termination on entry.
    error       = [error,rho];
    total_iters = 0;
    if (rho < errtol) 
        return
    end
    v(:,1) = r/rho;
    k      = 0;
    
%% GMRES iteration
    while((rho > errtol) && (k < kmax))
        k = k+1;
        % Call directional derivative function.
            [v(:,k+1), funcEval] = nsoli_dirder(problem, xc, v(:,k), fc, funcEval);
            normav   = norm(v(:,k+1));
        % Modified Gram-Schmidt
            for j = 1:k
                h(j,k)   = v(:,j)'*v(:,k+1);
                v(:,k+1) = v(:,k+1)-h(j,k)*v(:,j);
            end
            h(k+1,k) = norm(v(:,k+1));
            normav2  = h(k+1,k);
        % Reorthogonalize?
            if  ((reorth == 1 && normav + 0.001*normav2 == normav) || reorth ==  3)
                for j = 1:k
                    hr       = v(:,j)'*v(:,k+1);
                    h(j,k)   = h(j,k)+hr;
                    v(:,k+1) = v(:,k+1)-hr*v(:,j);
                end
                h(k+1,k) = norm(v(:,k+1));
            end
        % Watch out for happy breakdown.
            if (h(k+1,k) ~= 0)
                v(:,k+1) = v(:,k+1)/h(k+1,k);
            end
        % Form and store the information for the new Givens rotation.
            if (k > 1)
                h(1:k,k) = nsoli_givapp(c(1:k-1), s(1:k-1), h(1:k,k), k-1);
            end
        % Don't divide by zero if solution has  been found.
            nu = norm(h(k:k+1,k));
            if (nu ~= 0)
                %c(k) = h(k,k)/nu;
                c(k)     = conj(h(k,k)/nu);
                s(k)     = -h(k+1,k)/nu;
                h(k,k)   = c(k)*h(k,k)-s(k)*h(k+1,k);
                h(k+1,k) = 0;
                g(k:k+1) = nsoli_givapp(c(k), s(k), g(k:k+1), 1);
            end
        % Update the residual norm.
            rho   = abs(g(k+1));
            error = [error,rho];
    end
    
%% At this point either k > kmax or rho < errtol. It's time to compute x and leave
    y           = h(1:k,1:k)\g(1:k);
    total_iters = k;
    x           = x + v(1:n,1:k)*y;
    
end % *** END FUNCTION % **************************************************************************************************************************************