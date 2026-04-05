function [jac, funcEval] = nsold_diffjac(problem, xc, fc, funcEval)
% Function  : Compute a forward difference dense Jacobian f'(xc), 
%             return lu factors
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

%% Auxiliar and initilize variables
    n   = problem.auxiliar.n;
    jac = zeros(n,n);
    
%% Compute Jacobian
    for j = 1:n
        zz                   = zeros(n,1);
        zz(j)                = 1;
        [jac(:,j), funcEval] = nsold_dirder(problem, xc, zz, fc, funcEval);
    end

end % *** END FUNCTION % **************************************************************************************************************************************
