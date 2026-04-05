function [jac, funcEval] = nsold_bandjac(problem, xc, fc, funcEval)
% Function  : Compute a banded Jacobian f'(xc) by forward differeneces
%             (Kelley, C.T., Solving Nonlinear Equations with Newton's Method)
%
% *** INPUTS **************************************************************************************************************************************************
%
% *** OUTPUTS *************************************************************************************************************************************************
%
% *************************************************************************************************************************************************************
% C. T. Kelley, April 27, 2001
% This code comes with no guarantee or warranty of any kind.
% *************************************************************************************************************************************************************

%% Internal control parameters
    epsnew = problem.options.FinDiffRelStep;
    nl     = problem.options.nl;
    nu     = problem.options.nu;
    n      = problem.auxiliar.n;

%% Auxiliar and initilize variables
    jac    = sparse(n,n);
    delr   = zeros(n,1);
    ih     = zeros(n,1);
    il     = zeros(n,1);
    for ip = 1:n
        delr(ip) = min([nl+nu+ip,n]);  
        ih(ip)   = min([ip+nl,n]);
        il(ip)   = max([ip-nu,1]);
    end

%% Sweep thought the delr(1) perturbations of f.
    for is = 1:delr(1)
        ist = is;
        % Build the perturbation vector.
            pt = zeros(n,1);
            while (ist <= n)
                pt(ist) = 1;
                ist     = delr(ist)+1;
            end
        % Compute the forward difference.
            x1       = xc + epsnew*pt;
            f1       = feval(problem.fun,x1);
            funcEval = funcEval + 1;
            dv       = (f1-fc)./epsnew;
            ist      = is;
        % Fill the appropriate columns of the Jacobian.
            while (ist <= n)
                ilt              = il(ist); 
                iht              = ih(ist);
                m                = iht-ilt;
                jac(ilt:iht,ist) = dv(ilt:iht);
                ist              = delr(ist)+1;
            end
    end
    
end % *** END FUNCTION % **************************************************************************************************************************************
