function [problem] = nsoli_eisewal(problem)
% *************************************************************************************************************************************************************
% Function  : Adjust eta as per Eisenstat-Walker
%             (Kelley, C.T., Solving Nonlinear Equations with Newton's Method)
%
% *** INPUTS **************************************************************************************************************************************************
%
% *** OUTPUTS *************************************************************************************************************************************************
%
% *************************************************************************************************************************************************************
% C. T. Kelley, April 1, 2003
% This code comes with no guarantee or warranty of any kind.
% *************************************************************************************************************************************************************

%% Auxilar variables
    fnrmo    = problem.auxiliar.fnrmo;
    fnrm     = problem.auxiliar.fnrm;
    stop_tol = problem.auxiliar.stop_tol;
    etamaxO  = problem.auxiliar.etamaxO;

%% Internal control parameters
    gamma  = problem.options.gamma;
    etamax = abs(problem.options.etamax);

%% Update etamax
    rat  = fnrm/fnrmo;
    if (etamaxO > 0)
        etaold = etamax;
        etanew = gamma*rat*rat;
        if (gamma*etaold*etaold > 0.1)
            etanew = max(etanew,gamma*etaold*etaold);
        end
        etamax = min([etanew,etamaxO]);
        etamax = max(etamax,0.5*stop_tol/fnrm);
    end
    
%% Update variables
    problem.options.etamax = etamax;
    
end % *** END FUNCTION % **************************************************************************************************************************************