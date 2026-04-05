function [lambdap] = nsoli_parab3p(problem, lambdac, lambdam, ff0, ffc, ffm)
% *************************************************************************************************************************************************************
% Function  : Apply three-point safeguarded parabolic model for a line search (see item 1.6)
%             (Kelley, C.T., Solving Nonlinear Equations with Newton's Method)
%
% *** INPUTS **************************************************************************************************************************************************
% 	problem ........... data structure with the problem definition
%   lambdac ........... current steplength
%   lambdam ........... previous steplength
%   ff0 ............... value of \| F(x_c) \|^2
%   ffc ............... value of \| F(x_c + \lambdac d) \|^2
%   ffm ............... value of \| F(x_c + \lambdam d) \|^2
%
% *** OUTPUTS *************************************************************************************************************************************************
%   lambdap ........... new value of lambda given parabolic model
%
% *************************************************************************************************************************************************************
% C. T. Kelley, April 1, 2003
% This code comes with no guarantee or warranty of any kind.
% *************************************************************************************************************************************************************

%% Internal control parameters
    sigma0 = problem.options.sigma0;
    sigma1 = problem.options.sigma1;
    
%% Compute coefficients of interpolation polynomial
% p(lambda) = ff0 + (c1 lambda + c2 lambda^2)/d1
% d1 = (lambdac - lambdam)*lambdac*lambdam < 0
% so, if c2 > 0 we have negative curvature and default to
% lambdap = sigam1 * lambda
    c2 = lambdam*(ffc-ff0)-lambdac*(ffm-ff0);
    if (c2 >= 0)
        lambdap = sigma1*lambdac;
        return
    end
    c1      = lambdac*lambdac*(ffm-ff0)-lambdam*lambdam*(ffc-ff0);
    lambdap = -c1*.5/c2;
    if (lambdap < sigma0*lambdac)
        lambdap = sigma0*lambdac;
    end
    if (lambdap > sigma1*lambdac)
        lambdap = sigma1*lambdac;
    end
    
end % *** END FUNCTION % **************************************************************************************************************************************
